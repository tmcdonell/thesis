-- Originally written by Simon Marlow for the book
--   Parallel and Concurrent Programming in Haskell
--
-- With some assistance from Trevor L. McDonell.
--
-- The critical fixes are:
--
--   split Extend/Cunctation: 0bc2581441111b572903e68d7aea545330749058
--   aletD complexity:        7e45693620a24814d7ab7729e15257d339ceeba4
--

module Main
  where

import Prelude                                  as P
import Data.Array.Accelerate                    as A

import Data.Array.Accelerate.Trafo
import Criterion.Main
import Criterion.Config
import System.Environment


-- Main ------------------------------------------------------------------------

main :: IO ()
main = do
  (cfg,args)    <- parseArgs defaultConfig defaultOptions =<< getArgs

  let n         = case args of
                    x:_ | [(x',[])] <- reads x
                      -> (x')
                    _ -> error "usage: floyd-warshall edges [criterion options]"

  -- 'convertAcc' is the entire HOAS -> de Bruijn pipeline, not just fusion, but
  -- this is easier to measure.
  --
  withArgs (P.tail args) $
    defaultMainWith cfg (return ())
      [ bench "convertAcc" $ nf (show . convertAcc) (test n)]

test :: Int -> Acc Graph
test n
  = shortestPathsAcc n
  $ A.fill (constant (Z:.n:.n)) (constant 0)


-- Floyd-Warshall --------------------------------------------------------------
--
-- This is the original implementation of the Floyd-Warshall algorithm that was
-- sent by Simon Marlow. It has somewhat worse behaviour with 'convertAcc' than
-- the final version.
--

type Weight = Int32
type Graph  = Array DIM2 Weight                 -- distance between vertices as an adjacency matrix


shortestPathsAcc :: Int -> Acc Graph -> Acc Graph
shortestPathsAcc n g0 = P.fst r
  where
    r :: (Acc Graph, Acc (Array DIM0 Int))
    r = unlift $ P.iterate next (lift (g0, unit 0)) P.!! n

next :: Acc (Graph, Array DIM0 Int) -> Acc (Graph, Array DIM0 Int)
next gk = lift (generate (shape g) sp, unit (k+1))
  where
    (g, ka)     = unlift gk                                 -- g contains the shortest paths for vertices up to (k-1)
    k           = the ka

    sp :: Exp DIM2 -> Exp Weight
    sp ix = let Z :. i :. j = unlift ix                     -- the shortest path from i to j...
            in  min (g ! (index2 i j))                      -- ...is either the path (i -> j), or...
                    (g ! (index2 i k') + g ! (index2 k' j)) -- ...the path (i -> k) then (k -> j)

