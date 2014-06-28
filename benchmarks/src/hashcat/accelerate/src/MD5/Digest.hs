{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE CPP          #-}
{-# LANGUAGE MagicHash    #-}

module MD5.Digest (

  digests, fromDigest,
  dictionary, fromDict,

) where


import MD5.Hash

import Prelude
import Data.Bits
import Control.Exception
import Control.Monad
import qualified Data.Vector                    as V
import qualified Data.ByteString                as S
import qualified Data.ByteString.Unsafe         as S
import qualified Data.ByteString.Lazy           as L (foldlChunks)
import qualified Data.ByteString.Lazy.Char8     as L

import qualified Data.ByteString.Internal       as S
import Foreign.Ptr
import Foreign.ForeignPtr
import Foreign.Storable

import qualified Data.Array.Accelerate          as A
import Data.Array.Accelerate.Array.Data         as A
import Data.Array.Accelerate.Array.Sugar        ( Array(..), Z(..), (:.)(..), fromElt, size )

#if defined(__GLASGOW_HASKELL__) && !defined(__HADDOCK__)
import GHC.Base
import GHC.Word
#endif

import GHC.Conc


-- MD5 block sizes
--
blockSizeBits, blockSizeBytes, blockSizeWords :: Int
blockSizeBits  = 512
blockSizeBytes = blockSizeBits `div` 8
blockSizeWords = blockSizeBytes `div` 4


-- Create an MD5 block from the given message. This appends The '1' bit to the
-- message, pads the block with zeros until the length in bits is 448, and
-- finally appends the length in bits (mod 2^64).
--
{-# INLINE digest #-}
digest :: L.ByteString -> IO S.ByteString
digest msg =
  let
      len               = fromIntegral (L.length msg)
      lenBits           = 8 * fromIntegral len :: Word64
      lenZeroPad
        | len + 1 <= blockSizeBytes - 8 = (blockSizeBytes - 8) - (len + 1)
        | otherwise                     = (2 * blockSizeBytes - 8) - (len + 1)
  in
  -- Creating the ByteString directly is ~6x faster than using the builders from
  -- the cereal package. The last step assumes the host is little endian.
  --
  do
    buf <- S.mallocByteString blockSizeBytes
    withForeignPtr buf $ \ptr -> do
      copyLazyByteString ptr msg
      pokeElemOff ptr len 0x80
      void $! S.memset (ptr `plusPtr` (len + 1)) 0 (fromIntegral lenZeroPad)
      pokeByteOff ptr (len + 1 + lenZeroPad) lenBits
    --
    return $! S.fromForeignPtr buf 0 blockSizeBytes


-- Create a vector of MD5 chunks for each line in the given bytestring. Because
-- we only do a single MD5 chunk, we discard entries with more than
-- (length > blockSizeBytes - 8 = 55) characters.
--
{-# NOINLINE digests #-}
digests :: Maybe Int -> L.ByteString -> IO (V.Vector S.ByteString)
digests mlimit dict
  = let fromList = case mlimit of
                     Just n      -> V.fromListN n
                     Nothing     -> V.fromList
    in
    sequentially
        $ fmap fromList
        $ mapM digest
        $ filter (\w -> fromIntegral (L.length w) < blockSizeBytes - 8)
        $ L.lines dict

-- For some reason, when the program is run on multiple threads the 'digests'
-- function uses all of the cores and takes significantly longer to process than
-- when running sequentially. This forces the action to run sequentially by
-- reporting that there is only one capability, but it is still 2x slower than
-- running with only one core (using the RTS command line options).
--
{-# NOINLINE sequentially #-}
sequentially :: IO a -> IO a
sequentially action =
  bracket (do n <- getNumCapabilities
              setNumCapabilities 1
              return n)
          (setNumCapabilities)
          (const action)


-- Turn a vector of MD5 blocks into an array suitable for processing with
-- Accelerate. This can copy the array into either a column-major or row-major
-- representation. The column major representation is suitable for parallel
-- processing on GPUs, while the row-major representation is better suited to
-- conventional CPU-style processors. The data itself is unchanged.
--
{-# NOINLINE dictionary #-}
dictionary :: Align -> V.Vector S.ByteString -> Dictionary
dictionary align blocks =
  let
      entries           = V.length blocks
      (sh, step, start) =
        case align of
          C -> (Z :. blockSizeWords :. entries, entries, id)
          R -> (Z :. entries :. blockSizeWords, 1, (* blockSizeWords))

      (adata,_) = runArrayData $ do
        arr <- newArrayData (size sh)
        --
        let pack !n !word = go (start n) 0
              where
                go !i !o
                  | o >= blockSizeBytes = return ()
                  | otherwise
                  = do unsafeWriteArrayData arr i ((), getWord32le o word)
                       go (i + step) (o + 4)
        --
        V.mapM_ (uncurry pack) (V.indexed blocks)
        return (arr, undefined)
  in
  adata `seq` Array (fromElt sh) adata


-- Extract a word from the digests at a given index
--
{-# INLINE fromDigest #-}
fromDigest :: V.Vector S.ByteString -> Int -> S.ByteString
fromDigest dict i = S.takeWhile (/= 0x80) (dict V.! i)

{-# INLINE fromDict #-}
fromDict :: Align -> Dictionary -> Int -> S.ByteString
fromDict align dict i
  = S.takeWhile (/= 0x80) . fst
  . S.packUptoLenBytes blockSizeBytes
  . concatMap unpack
  $ map (get align) [0 .. blockSizeWords - 1]
  where
    get C n     = dict `A.indexArray` (Z:.n:.i)
    get R n     = dict `A.indexArray` (Z:.i:.n)

    unpack x    = [ fromIntegral x
                  , fromIntegral (x `shiftr_w32`  8)
                  , fromIntegral (x `shiftr_w32` 16)
                  , fromIntegral (x `shiftr_w32` 24) ]


-- low-level stuff
-- ---------------

-- Copy the chunks of a lazy ByteString beginning at the given address. This
-- assumes that the pointer is large enough to hold the data.
--
{-# INLINE copyLazyByteString #-}
copyLazyByteString :: Ptr Word8 -> L.ByteString -> IO ()
copyLazyByteString to msg = void $! L.foldlChunks copy (return to) msg
  where
    copy :: IO (Ptr Word8) -> S.ByteString -> IO (Ptr Word8)
    copy ptr (S.toForeignPtr -> (fp, off, len)) = do
      dst <- ptr
      withForeignPtr fp $ \src -> S.memcpy dst (src `plusPtr` off) len
      return $! dst `plusPtr` len


-- Read four consecutive bytes from the ByteString beginning at the given index
-- as a little-endian unsigned 32-bit integer.
--
{-# INLINE getWord32le #-}
getWord32le :: Int -> S.ByteString -> Word32
getWord32le o s
  = (fromIntegral (s `S.unsafeIndex` (o)))                   .|.
    (fromIntegral (s `S.unsafeIndex` (o+1)) `shiftl_w32`  8) .|.
    (fromIntegral (s `S.unsafeIndex` (o+2)) `shiftl_w32` 16) .|.
    (fromIntegral (s `S.unsafeIndex` (o+3)) `shiftl_w32` 24)


-- Unchecked shifts
--
{-# INLINE shiftl_w32 #-}
{-# INLINE shiftr_w32 #-}
shiftl_w32 :: Word32 -> Int -> Word32
shiftr_w32 :: Word32 -> Int -> Word32
#if defined(__GLASGOW_HASKELL__) && !defined(__HADDOCK__)
shiftl_w32 (W32# w) (I# i) = W32# (w `uncheckedShiftL#`   i)
shiftr_w32 (W32# w) (I# i) = W32# (w `uncheckedShiftRL#`  i)
#else
shiftl_w32 = shiftL
shiftr_w32 = shiftR
#endif


-- Slower than the above version with shifts
--
-- {-# INLINE getWord32le' #-}
-- getWord32le :: Int -> S.ByteString -> Word32
-- getWord32le o (S.toForeignPtr -> (fp, off, _))
--   = unsafePerformIO
--   $ withForeignPtr fp $ \ptr -> peekByteOff ptr (off + o)


-- No quicker than the simpler cast and read version
--
-- {-# INLINE pokeWord64le #-}
-- pokeWord64le :: Ptr Word8 -> Word64 -> IO ()
-- pokeWord64le p w = do
--   poke        p   (fromIntegral w)
--   pokeElemOff p 1 (fromIntegral (w `shiftr_w64`  8))
--   pokeElemOff p 2 (fromIntegral (w `shiftr_w64` 16))
--   pokeElemOff p 3 (fromIntegral (w `shiftr_w64` 24))
--   pokeElemOff p 4 (fromIntegral (w `shiftr_w64` 32))
--   pokeElemOff p 5 (fromIntegral (w `shiftr_w64` 40))
--   pokeElemOff p 6 (fromIntegral (w `shiftr_w64` 48))
--   pokeElemOff p 7 (fromIntegral (w `shiftr_w64` 56))
--
-- {-# INLINE shiftr_w64 #-}
-- shiftr_w64 :: Word64 -> Int -> Word64
-- #if defined(__GLASGOW_HASKELL__) && !defined(__HADDOCK__)
-- #if WORD_SIZE_IN_BITS < 64
-- shiftr_w64 (W64# w) (I# i) = W64# (w `uncheckedShiftRL64#` i)
-- #else
-- shiftr_w64 (W64# w) (I# i) = W64# (w `uncheckedShiftRL#`   i)
-- #endif
-- #else
-- shiftr_w64 = shiftR
-- #endif

