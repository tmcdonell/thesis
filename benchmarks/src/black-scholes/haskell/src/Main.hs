module Main
  where

import Random.Array
import qualified Solver.Accelerate              as Acc
import qualified Solver.Repa                    as Repa

import Data.Array.Repa                          as R ( copyP )
import Data.Array.Accelerate                    as A ( Z(..), (:.)(..) )
import Data.Array.Accelerate.IO                 as A
import Data.Array.Accelerate.CUDA               as CUDA

import Control.Exception
import Criterion.Main
import Criterion.Config
import System.Environment
import System.Random.MWC


main :: IO ()
main = do
  (cfg,args)    <- parseArgs defaultConfig defaultOptions =<< getArgs

  let n         = case args of
                    x:_ | [(x',[])] <- reads x
                      -> x'
                    _ -> error "usage: blackscholes N [criterion options]"

      test s    = s ++ "/" ++ show n

      runCUDA   = CUDA.run1 Acc.blackscholes

  putStrLn "generating data"
  psyA          <- randomArrayIO (\_ -> uniformR ((5,1,0.25), (30,100,10))) (Z:.n)
  psyR          <- copyP (A.toRepa psyA)

  putStrLn "initialising Accelerate"
  _             <- evaluate (runCUDA psyA)

  withArgs (tail args) $
    defaultMainWith cfg (return ())
      [ bench (test "acc-cuda")         $ whnf runCUDA psyA
      , bench (test "repa")             $ whnfIO (Repa.blackscholes psyR)
      ]

