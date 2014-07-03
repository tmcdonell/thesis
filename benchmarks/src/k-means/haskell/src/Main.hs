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

  let (c1,n1) = S.kmeans 600 nclusters points' clusters'
  printf "strat: iterations=%d, clusters=%s\n" n1 (show c1)

  let (c2,n2) = P.kmeans 600 nclusters points' clusters'
  printf "par: iterations=%d, clusters=%s\n" n2 (show c2)

  let (c3,n3) = DP.kmeans 7 nclusters npoints points' clusters'
  printf "div-par: iterations=%d, clusters=%s\n" n3 (show c3)

  let (c4,n4) = DE.kmeans 7 nclusters npoints points' clusters'
  printf "div-eval: iterations=%d, clusters=%s\n" n4 (show c4)

  let runCUDA   = CUDA.run1 (A.kmeans (use points))
      c5        = runCUDA clusters
  printf "cuda: clusters=%s\n" (show c5)

  defaultMain
    [ bench "acc-cuda"  $ whnf runCUDA clusters
    , bench "strat"     $ nf   (S.kmeans 600 nclusters points') clusters'
    , bench "par"       $ nf   (P.kmeans 600 nclusters points') clusters'
    , bench "div-par"   $ nf   (DP.kmeans 7 nclusters npoints points') clusters'
    , bench "div-eval"  $ nf   (DE.kmeans 7 nclusters npoints points') clusters'
    ]

