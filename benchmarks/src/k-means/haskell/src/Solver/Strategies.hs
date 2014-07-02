{-# LANGUAGE ScopedTypeVariables #-}
--
-- Adapted from K-Means sample from "Parallel and Concurrent Programming in
-- Haskell", (c) Simon Marlow, 2013.
--

module Solver.Strategies (kmeans)
  where

import Control.Parallel.Strategies
import Data.Vector.Unboxed                              ( Unbox )

import Type
import Solver.Common


kmeans :: forall a. (Eq a, Ord a, Floating a, Unbox a)
       => Int -> Int -> [Point a] -> [Cluster a] -> [Cluster a]
kmeans numChunks nclusters points = loop 0
  where
    tooMany     = 80
    chunks      = split numChunks points

    loop :: Int -> [Cluster a] -> [Cluster a]
    loop n clusters
      | n > tooMany
      = clusters

    loop n clusters
      | clusters' <- step nclusters clusters chunks
      = if clusters' == clusters
           then clusters
           else loop (n+1) clusters'

step :: (Ord a, Floating a, Unbox a) => Int -> [Cluster a] -> [[Point a]] -> [Cluster a]
step nclusters clusters pointss
  = makeNewClusters
  $ foldr1 combine
  $ (map (assign nclusters clusters) pointss `using` parList rseq)

