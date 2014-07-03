--
-- Adapted from K-Means sample from "Parallel and Concurrent Programming in
-- Haskell", (c) Simon Marlow, 2013.
--

module Solver.Common
  where


import Type

import Data.Word
import Data.Function
import Data.List

import Data.Vector.Unboxed                              ( Vector, Unbox )
import qualified Data.Vector.Unboxed                    as Vector
import qualified Data.Vector.Unboxed.Mutable            as MVector


-- Lists -----------------------------------------------------------------------

split :: Int -> [a] -> [[a]]
split numChunks xs = chunk (length xs `quot` numChunks) xs

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = as : chunk n bs
  where
    (as,bs) = splitAt n xs


-- Trees -----------------------------------------------------------------------

data Tree a = Leaf a
            | Node (Tree a) (Tree a)

mkPointTree :: Int -> [Point a] -> Int -> Tree [Point a]
mkPointTree threshold = go 0
  where
    go depth points npoints
      | depth >= threshold      = Leaf points
      | otherwise               = Node (go (depth+1) xs half) (go (depth+1) ys half)
          where
            half        = npoints `quot` 2
            (xs,ys)     = splitAt half points


-- Points & Clusters -----------------------------------------------------------

converged :: (Floating a, Ord a) => [Cluster a] -> [Cluster a] -> Bool
converged []     []     = True
converged (u:us) (v:vs) = eq u v && converged us vs
  where
    eq (_, (x1,y1)) (_, (x2,y2)) = abs (x1-x2) <= 0.001 && abs (y1-y2) <= 0.001
converged _      _      = False

sqDistance :: Floating a => Point a -> Point a -> a
sqDistance (x1,y1) (x2,y2) = ((x1-x2) ^ (2::Int)) + ((y1-y2) ^ (2::Int))

makeNewClusters :: (Floating a, Unbox a) => Vector (PointSum a) -> [Cluster a]
makeNewClusters vec =
  [ pointSumToCluster i ps
  | (i,ps@(count,_)) <- zip [0..] (Vector.toList vec)
  , count > 0
  ]

assign :: (Ord a, Floating a, Unbox a) => Int -> [Cluster a] -> [Point a] -> Vector (PointSum a)
assign nclusters clusters points = Vector.create $ do
    vec <- MVector.replicate nclusters (0,(0,0))
    let
        addpoint p = do
          let c         = nearest p
              cid       = fromIntegral $ fst c
          ps <- MVector.read vec cid
          MVector.write vec cid $! addToPointSum ps p

    mapM_ addpoint points
    return vec
 where
  nearest p = fst
            $ minimumBy (compare `on` snd) [ (c, sqDistance (snd c) p) | c <- clusters ]

addToPointSum :: Floating a => PointSum a -> Point a -> PointSum a
addToPointSum (count, (xs,ys)) (x,y)
  = (count+1, (xs + x,ys + y))

addPointSums :: Floating a => PointSum a -> PointSum a -> PointSum a
addPointSums (c1,(x1,y1)) (c2,(x2,y2))
  = (c1+c2, (x1+x2, y1+y2))

combine :: (Floating a, Unbox a) => Vector (PointSum a) -> Vector (PointSum a) -> Vector (PointSum a)
combine = Vector.zipWith addPointSums

pointSumToCluster :: Floating a => Word32 -> PointSum a -> Cluster a
pointSumToCluster i (count,(xs,ys)) =
  ( i
  , (xs / fromIntegral count, ys / fromIntegral count)
  )


