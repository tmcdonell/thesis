{-# LANGUAGE BangPatterns #-}
-- Originally written by Simon Marlow for the book
--   Parallel and Concurrent Programming in Haskell
--

module Solver.Repa (

  Graph, Weight,
  shortestPaths, fromAdjMatrix,

) where

import Data.Ix
import Data.Array.Repa
import Data.Array.IArray                        ( bounds, elems )
import Data.Functor.Identity

import Random.Graph                             ( AdjacencyMatrix )

type Weight  = Int
type Graph r = Array r DIM2 Weight

shortestPaths :: Graph U -> Graph U
shortestPaths g0 = runIdentity $ go g0 0
  where
    Z :. _ :. n = extent g0

    go !g !k | k == n    = return g
             | otherwise = do
                 g' <- computeP (fromFunction (Z:.n:.n) sp)
                 go g' (k+1)
     where
        sp (Z:.i:.j) = min (g ! (Z:.i:.j))
                           (g ! (Z:.i:.k) + g ! (Z:.k:.j))


fromAdjMatrix :: AdjacencyMatrix -> Graph U
fromAdjMatrix m =
  let ((u,v), (u',v')) = bounds m
  in  fromListUnboxed (Z :. rangeSize (u,u') :. rangeSize (v,v')) (elems m)

