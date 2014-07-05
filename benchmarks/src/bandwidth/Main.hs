{-# LANGUAGE ScopedTypeVariables #-}

module Main
  where

import Numeric
import Data.Bits
import Data.Word
import Criterion.Main

import Foreign.Ptr
import Foreign.Marshal                          as Host
import Foreign.CUDA.Driver                      as CUDA


kilobyte, megabyte :: Int
kilobyte = 1 `shift` 10
megabyte = 1 `shift` 20

shmooBytes :: [Int]
shmooBytes =
  [    kilobyte,   2*kilobyte  ..  20*kilobyte ] ++
  [ 22*kilobyte,  24*kilobyte  ..  50*kilobyte ] ++
  [ 60*kilobyte,  70*kilobyte  .. 100*kilobyte ] ++
  [ 200*kilobyte, 300*kilobyte .. 900*kilobyte ] ++
  [   1*megabyte,   2*megabyte ..  16*megabyte ] ++
  [  18*megabyte,  20*megabyte ..  32*megabyte ] ++
  [  36*megabyte,  40*megabyte ..  64*megabyte ]

showFFloatSIBase :: RealFloat a => Maybe Int -> a -> a -> ShowS
showFFloatSIBase p b n
  = showString
  $ showFFloat p n' si_unit
  where
    n'          = n / (b ^^ pow)
    pow         = (-4) `max` floor (logBase b n) `min` 4        :: Int
    si_unit     = case pow of
                       -4 -> "p"
                       -3 -> "n"
                       -2 -> "µ"
                       -1 -> "m"
                       0  -> ""
                       1  -> "k"
                       2  -> "M"
                       3  -> "G"
                       4  -> "T"
                       _  -> error "not possible"


main :: IO ()
main = do

  CUDA.initialise []
  dev   <- CUDA.device 0
  ctx   <- CUDA.create dev []

  let n = maximum shmooBytes

  Host.allocaBytes n $ \(h_ptr :: Ptr Word8)       -> do
  CUDA.allocaArray n $ \(d_ptr :: DevicePtr Word8) -> do
    defaultMain
      [ bgroup (showFFloatSIBase (Just 0) 1024 (fromIntegral i :: Double) "B")
        [ bench "hostToDevice" $ nfIO (CUDA.pokeArray i h_ptr d_ptr)
        , bench "deviceToHost" $ nfIO (CUDA.peekArray i d_ptr h_ptr)
        ]
      | i <- shmooBytes
      ]

  CUDA.destroy ctx

