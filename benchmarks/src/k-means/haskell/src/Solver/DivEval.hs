{-# LANGUAGE ScopedTypeVariables #-}

module Solver.DivEval (kmeans)
  where

import Type
import Solver.Common

import Control.Parallel.Strategies
import Data.Vector.Unboxed                              ( Vector, Unbox )


kmeans :: forall a. (Eq a, Ord a, Floating a, Unbox a)
       => Int -> Int -> Int -> [Point a] -> [Cluster a] -> ([Cluster a], Int)
kmeans threshold nclusters npoints points = loop 1
  where
    tooMany     = 120
    tree        = mkPointTree threshold points npoints

    loop :: Int -> [Cluster a] -> ([Cluster a], Int)
    loop n clusters
      | n > tooMany = (clusters, n)

    loop n clusters =
      let
          divconq :: Tree [Point a] -> Vector (PointSum a)
          divconq (Leaf pt) = assign nclusters clusters pt
          divconq (Node left right) = runEval $ do
            c1 <- rpar $ divconq left
            c2 <- rpar $ divconq right
            _  <- rdeepseq c1
            _  <- rdeepseq c2
            return $! combine c1 c2

          clusters' = makeNewClusters $ divconq tree
      in
      if converged clusters' clusters
         then (clusters, n)
         else loop (n+1) clusters'

