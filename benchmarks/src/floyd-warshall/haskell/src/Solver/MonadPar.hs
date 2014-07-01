-- Originally written by Simon Marlow for the book
--   Parallel and Concurrent Programming in Haskell
--

module Solver.MonadPar (

  shortestPaths

) where

import Control.Monad.Par.Scheds.Trace                   hiding ( new )
  -- gives slightly better results than Control.Monad.Par with monad-par-0.3.4
import Data.IntMap                                      ( IntMap )
import Data.List
import Data.Traversable                                 hiding ( mapM )

import qualified Data.IntMap                            as Map

import Random.Graph

type Graph = SparseGraph

weight :: Graph -> Vertex -> Vertex -> Maybe Weight
weight g i j = do
  jmap <- Map.lookup i g
  Map.lookup j jmap

shortestPaths :: [Vertex] -> Graph -> Graph
shortestPaths vs g0 = foldl' update g0 vs
  where
    update g k = runPar $ do
      m <- Map.traverseWithKey (\i jmap -> spawn (return (shortmap i jmap))) g
      traverse get m

      where
        shortmap :: Vertex -> IntMap Weight -> IntMap Weight
        shortmap i jmap = foldr shortest Map.empty vs
            where shortest j m =
                    case (old,new) of
                       (Nothing, Nothing) -> m
                       (Nothing, Just w ) -> Map.insert j w m
                       (Just w,  Nothing) -> Map.insert j w m
                       (Just w1, Just w2) -> Map.insert j (min w1 w2) m
                    where
                      old = Map.lookup j jmap
                      new = do w1 <- weight g i k
                               w2 <- weight g k j
                               return (w1+w2)

