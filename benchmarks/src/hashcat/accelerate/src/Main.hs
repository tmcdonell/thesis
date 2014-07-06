{-# LANGUAGE OverloadedStrings #-}

module Main where

import MD5.Hash                                         as MD5
import MD5.Digest                                       as MD5
import MD5.Recover                                      as MD5

import Criterion.Config
import Criterion.Main
import Criterion.Measurement
import System.Environment
import System.IO
import Text.Printf
import qualified Data.Vector                            as V
import qualified Data.ByteString.Lazy.Char8             as L

import qualified Data.Array.Accelerate                  as A
import qualified Data.Array.Accelerate.CUDA             as CUDA


main :: IO ()
main = do
  (cfg,args)    <- parseArgs defaultConfig defaultOptions =<< getArgs

  let args' = takeWhile (/= "--")
            $ case mlimit of
                Just _       -> drop 3 args
                Nothing      -> drop 2 args

      (wordlist, hashlist, mlimit)
            = case args of
                w:u:rest -> case rest of
                              n:_ | [(n',[])] <- reads n
                                -> (w,u,Just n')
                              _ -> (w,u,Nothing)
                _ -> error "usage: hashcat dictionary unknowns [N] [criterion options]"

      password = readMD5 "5f4dcc3b5aa765d61d8327deb882cf99"

  -- Load the dictionary
  --
  putStr "loading dictionary... " >> hFlush stdout
  (elapsed, (entries, dictR, dictC)) <- time $ do
      wl <- MD5.digests mlimit =<< L.readFile wordlist
      let dictR = MD5.dictionary R wl
          dictC = MD5.dictionary C wl
      --
      return (V.length wl, dictR, dictC)

  putStrLn $ printf "%d entries in %s" entries (secs elapsed)

  -- Read the list of unknown hashes to crack
  --
  unknowns <- L.lines `fmap` L.readFile hashlist

  withArgs args' $
    defaultMainWith cfg (return ())
      [ bench "acc-cuda"        $ whnf (CUDA.run1 (hashcat C (A.use dictC))) (A.fromList A.Z [password])
--      , bench "acc-llvm-cpu"    $ whnf (CPU.run1  (hashcat R (A.use dictR))) (A.fromList A.Z [password])
      ]

{--
  let runCUDA   = MD5.recover C CUDA.run1 dictC
      runPTX    = MD5.recover C PTX.run1  dictC
      runCPU    = MD5.recover R CPU.run1  dictR

  withArgs args' $
    defaultMainWith cfg (return ())
      [ bench "acc-cuda"        $ nfIO (runCUDA unknowns)
      , bench "acc-llvm-ptx"    $ nfIO (runPTX  unknowns)
      , bench "acc-llvm-cpu"    $ nfIO (runCPU  unknowns)
      ]
--}
{--
  let runCUDA   = CUDA.run1 (MD5.md5 C)

  withArgs args' $
    defaultMainWith cfg (return ())
      [ bench "acc-cuda"        $ whnf runCUDA dictC
      ]
--}
