{-# LANGUAGE BangPatterns #-}

module Main
  where

import Random.Graph
import qualified Solver.Accelerate              as A
import qualified Solver.Repa                    as R
import qualified Solver.MonadPar                as P
import qualified Data.Array.Accelerate.CUDA     as CUDA

import qualified Data.IntSet                    as Set

import Criterion.Main
import Criterion.Config
import System.Environment
import System.Random.MWC
import Text.Printf


main :: IO ()
main = do
  (cfg,args)    <- parseArgs defaultConfig defaultOptions =<< getArgs

  let (n,m)     = case args of
                    x:y:_ | [(x',[])] <- reads x
                          , [(y',[])] <- reads y
                      -> (x',y')
                    _ -> error "usage: floyd-warshall edges vertices [criterion options]"

      test s    = printf "%s/%d-%d" s n m

  putStrLn "generating data"
  gen                   <- create       -- fixed seed
  (graph,vertices)      <- randomGraph gen (n-1) n m
  let !adjMatrix = toAdjMatrix (n-1) graph

      !graphR    = R.fromAdjMatrix adjMatrix
      !graphA    = A.fromAdjMatrix adjMatrix

      runCUDA    = CUDA.run1 (A.shortestPaths graphA)

  withArgs (drop 2 args) $
    defaultMainWith cfg (return ())
      [ bench (test "acc-cuda")         $ whnf runCUDA graphA
      , bench (test "repa")             $ whnf R.shortestPaths graphR
      , bench (test "monad-par")        $ whnf (P.shortestPaths (Set.toList vertices)) graph
      ]

