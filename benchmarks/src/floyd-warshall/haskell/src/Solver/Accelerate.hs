-- Originally written by Simon Marlow for the book
--   Parallel and Concurrent Programming in Haskell
--
-- With some assistance from Trevor L. McDonell.
--

module Solver.Accelerate (

  Graph, Weight,
  shortestPaths, fromAdjMatrix,

) where

import Prelude                                  as P
import Data.Array.Accelerate                    as A
import Data.Array.Accelerate.CUDA               as CUDA

import Random.Graph                             ( AdjacencyMatrix )
import Data.Array.IArray                        ( amap )


type Weight = Int32
type Graph  = Array DIM2 Weight                 -- distance between vertices as an adjacency matrix

shortestPaths :: Graph -> Graph
shortestPaths g0 = run1 (shortestPathsAcc n) g0
  where
    Z :. _ :. n = arrayShape g0

shortestPathsAcc :: Int -> Acc Graph -> Acc Graph
shortestPathsAcc n g0 = foldl1 (.) steps g0
  where
    steps :: [ Acc Graph -> Acc Graph ]         -- apply step in the sequence [0 .. n-1]
    steps =  [ step (unit (constant k)) | k <- [0 .. n-1] ]

step :: Acc (Scalar Int) -> Acc Graph -> Acc Graph
step k g = generate (shape g) sp                -- previous graph contains the lengths of...
  where                                         -- ...the shortest paths for vertices up to (k-1)
    k' = the k

    sp :: Exp DIM2 -> Exp Weight
    sp ix = let Z :. i :. j = unlift ix                     -- the shortest path from i to j...
            in  min (g ! (index2 i j))                      -- ...is either the path (i -> j), or...
                    (g ! (index2 i k') + g ! (index2 k' j)) -- ...the path (i -> k) then (k -> j)



fromAdjMatrix :: AdjacencyMatrix -> Graph
fromAdjMatrix = fromIArray . amap P.fromIntegral

