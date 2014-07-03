{-# LANGUAGE ScopedTypeVariables #-}

module Solver.DivPar (kmeans)
  where

import Type
import Solver.Common

import Data.Vector.Unboxed                              ( Vector, Unbox )
import Control.Monad.Par


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
          divconq :: Tree [Point a] -> Par (Vector (PointSum a))
          divconq (Leaf pt) = return $ assign nclusters clusters pt
          divconq (Node left right) = do
            i1 <- spawn $ divconq left
            i2 <- spawn $ divconq right
            c1 <- get i1
            c2 <- get i2
            return $! combine c1 c2

          clusters' = makeNewClusters $ runPar $ divconq tree
      in
      if converged clusters' clusters
         then (clusters, n)
         else loop (n+1) clusters'

