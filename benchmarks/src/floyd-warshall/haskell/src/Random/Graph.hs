
module Random.Graph
  where

import Data.IntMap                              ( IntMap )
import Data.IntSet                              ( IntSet )
import Data.Array.Unboxed
import System.Random.MWC
import qualified Data.IntMap                    as Map
import qualified Data.IntSet                    as Set

type Weight             = Int
type Vertex             = Int
type VertexSet          = IntSet
type SparseGraph        = IntMap (IntMap Weight)
type AdjacencyMatrix    = UArray (Int,Int) Weight


randomGraph
    :: GenIO
    -> Int
    -> Int
    -> Int
    -> IO (SparseGraph, VertexSet)
randomGraph gen max_vertex max_weight edges = do
  g     <- go Map.empty edges
  return (g, vertices g)
  where
    go :: SparseGraph -> Int -> IO SparseGraph
    go g 0 = return g
    go g n = do
      i <- uniformR (0,max_vertex) gen
      j <- uniformR (0,max_vertex) gen
      w <- uniformR (1,max_weight) gen
      go (insertEdge i j w g) (n-1)

    vertices :: SparseGraph -> VertexSet
    vertices g =
      let is = Map.keysSet g
          js = map Map.keysSet (Map.elems g)
      in
      Set.unions (is : js)

    insertEdge :: Vertex -> Vertex -> Weight -> SparseGraph -> SparseGraph
    insertEdge i j w g = Map.insertWith Map.union i (Map.singleton j w) g


toAdjMatrix :: Int -> SparseGraph -> AdjacencyMatrix
toAdjMatrix k g =
  let m = accumArray (flip const) 999 ((0,0), (k,k))
              [ ((i,j), w) | (i,jmap) <- Map.toList g
                           , (j, w)   <- Map.toList jmap ]
  in
  m // [ ((i,i), 1) | i <- [0 .. k]]

