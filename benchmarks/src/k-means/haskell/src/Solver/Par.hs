{-# LANGUAGE ScopedTypeVariables #-}

module Solver.Par (kmeans)
  where

import Type
import Solver.Common

import Data.List
import Data.Vector.Unboxed                              ( Unbox )
import Control.Monad.Par


kmeans :: forall a. (Eq a, Ord a, Floating a, Unbox a)
       => Int -> Int -> [Point a] -> [Cluster a] -> ([Cluster a], Int)
kmeans mappers nclusters points = loop 1
  where
    tooMany     = 120
    chunks      = split mappers points

    loop :: Int -> [Cluster a] -> ([Cluster a], Int)
    loop n clusters
      | n > tooMany = (clusters, n)

    loop n clusters
      | clusters' <- step nclusters clusters chunks
      = if converged clusters' clusters
           then (clusters, n)
           else loop (n+1) clusters'


step :: (Ord a, Floating a, Unbox a) => Int -> [Cluster a] -> [[Point a]] -> [Cluster a]
step nclusters clusters pointss
  = makeNewClusters
  $ foldl1' combine
  $ (runPar $ parMap (assign nclusters clusters) pointss)

