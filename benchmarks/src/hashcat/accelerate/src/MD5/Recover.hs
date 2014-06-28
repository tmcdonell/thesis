{-# LANGUAGE RankNTypes      #-}
{-# LANGUAGE RecordWildCards #-}

module MD5.Recover
  where

import MD5.Hash
import MD5.Digest

import Prelude                                          as P
import Numeric
import Data.List
import Control.Monad
import Criterion.Measurement
import Text.Printf
import Data.Array.Accelerate                            as A
import qualified Data.ByteString.Char8                  as S
import qualified Data.ByteString.Lazy.Char8             as L


data Stats = S
  { recovered   :: {-# UNPACK #-} !Int
  , processed   :: {-# UNPACK #-} !Int
  }


recover :: Align
        -> (forall a b. (Arrays a, Arrays b) => (Acc a -> Acc b) -> a -> b)
        -> Dictionary
        -> [L.ByteString]
        -> IO ()
recover align run1 dict unknowns =
  let
      recover1 :: L.ByteString -> Maybe S.ByteString
      recover1 hash =
        let abcd = readMD5 hash
            idx  = run1 (hashcat align (use dict)) (fromList Z [abcd])
        in
        case indexArray idx Z of
          -1    -> Nothing
          i     -> Just (fromDict align dict i)

      yes (S r p) = S (r+1) (p+1)
      no  (S r p) = S r     (p+1)

      go stats hash =
        case recover1 hash of
          Nothing       -> return (no stats)
          Just plain    -> do L.putStr hash >> putStr ": " >> S.putStrLn plain
                              return (yes stats)

      entries =
        let Z:.r:.c = arrayShape dict
        in case align of
             R -> r
             C -> c
  in do
  putStrLn "beginning recovery..."
  (elapsed, S{..}) <- time $ foldM go (S 0 0) unknowns

  putStrLn $ printf "\nrecovered %d/%d (%.2f %%) digests in %s, %s"
    recovered
    processed
    (P.fromIntegral recovered / P.fromIntegral processed * 100.0 :: Double)
    (secs elapsed)
    (showFFloatSIBase (Just 2) 1000 (P.fromIntegral processed * P.fromIntegral entries / elapsed) "hash/s")


showFFloatSIBase :: RealFloat a => Maybe Int -> a -> a -> ShowS
showFFloatSIBase p b n
  = showString
  . nubBy (\x y -> x == ' ' && y == ' ')
  $ showFFloat p n' [ ' ', si_unit ]
  where
    n'          = n / (b ^^ (pow-4))
    pow         = max 0 . min 8 . (+) 4 . P.floor $ logBase b n
    si_unit     = "pnµm kMGT" P.!! pow

