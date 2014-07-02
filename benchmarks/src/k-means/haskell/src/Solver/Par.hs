{-# LANGUAGE ScopedTypeVariables #-}

module Solver.Par (kmeans)
  where

import Type
import Solver.Common

import Data.List
import Data.Vector.Unboxed                              ( Unbox )
import Control.Monad.Par


kmeans :: forall a. (Eq a, Ord a, Floating a, Unbox a)
       => Int -> Int -> [Point a] -> [Cluster a] -> [Cluster a]
kmeans mappers nclusters points = loop 0
  where
    tooMany     = 80
    chunks      = split mappers points

    loop :: Int -> [Cluster a] -> [Cluster a]
    loop n clusters
      | n > tooMany = clusters

    loop n clusters
      | clusters' <- step nclusters clusters chunks
      = if clusters' == clusters
           then clusters
           else loop (n+1) clusters'


step :: (Ord a, Floating a, Unbox a) => Int -> [Cluster a] -> [[Point a]] -> [Cluster a]
step nclusters clusters pointss
  = makeNewClusters
  $ foldl1' combine
  $ (runPar $ parMap (assign nclusters clusters) pointss)

