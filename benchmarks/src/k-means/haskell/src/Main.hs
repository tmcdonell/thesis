{-# LANGUAGE CPP #-}
--
-- K-Means sample. This uses the CUDA backend to execute the program.
--
-- Run the generate-samples program first to create some random data.
--

import Prelude                                          as P
import Criterion.Main
import Data.Binary                                      (decodeFile)
import System.Mem
import Text.Printf

import Data.Array.Accelerate                            as A
import Data.Array.Accelerate.CUDA                       as CUDA

import Type
import qualified Solver.Accelerate                      as A
import qualified Solver.Strategies                      as S
import qualified Solver.Par                             as P
import qualified Solver.DivPar                          as DP
import qualified Solver.DivEval                         as DE


main :: IO ()
main = do
  points'   <- decodeFile "points.bin"
  clusters' <- read `fmap` readFile "clusters"

  let nclusters = P.length clusters'
      npoints   = P.length points'

      clusters :: Vector (Cluster Float)
      clusters  = A.fromList (Z:.nclusters) clusters'

      points :: Vector (Point Float)
      points    = A.fromList (Z:.npoints)   points'

  clusters `seq` points `seq` performGC

  printf "kmeans: grouping %d points into %d clusters\n" npoints nclusters

  defaultMain
    [ bench "acc-cuda"  $ whnf (CUDA.run1 (A.kmeans (use points))) clusters
    , bench "strat"     $ nf   (S.kmeans 600 nclusters points') clusters'
    , bench "par"       $ nf   (P.kmeans 600 nclusters points') clusters'
    , bench "div-par"   $ nf   (DP.kmeans 7 nclusters npoints points') clusters'
    , bench "div-eval"  $ nf   (DE.kmeans 7 nclusters npoints points') clusters'
    ]

