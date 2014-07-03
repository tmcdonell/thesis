
module Main where

-- friends
import Random.Array

import qualified Solver.Vector                  as V
import qualified Solver.Accelerate              as A

import Data.Array.Accelerate                    as A
import Data.Array.Accelerate.IO                 as A
import Data.Array.Accelerate.CUDA               as A

-- standard library
import Prelude                                  as P
import Text.Printf
import System.Environment
import System.Random.MWC
import qualified Data.Vector.Unboxed            as V

import Criterion.Main
import Criterion.Config


main :: IO ()
main = do
  (cfg, args)   <- parseArgs defaultConfig defaultOptions =<< getArgs

  let n         = case args of
                    x:_ | [(x',[])] <- reads x
                      -> x'
                    _ -> error "usage: radixsort elements [criterion options]"

      test s    = printf "%s/%d" s n

  printf "generating data\n"
  xs_arr        <- randomArrayIO (const uniform) (Z :. n)       :: IO (Vector Int32)
  let xs_vec    =  V.convert $ P.snd (toVectors xs_arr)

  withArgs (P.tail args) $
    defaultMainWith cfg (return ())
      [ bench (test "vector")     $ nf V.sort xs_vec
      , bench (test "accelerate") $ whnf (A.run1 A.sort) xs_arr
      ]

