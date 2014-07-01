--
-- A Mandelbrot set generator.
-- Originally submitted by Simon Marlow as part of Issue #49.
--

import qualified Solver.Repa                            as R
import qualified Solver.Accelerate1                     as A1
import qualified Solver.Accelerate2                     as A2
import qualified Solver.Accelerate3                     as A3

import Criterion.Config
import Criterion.Main
import System.Environment
import Text.Printf

import Prelude
import qualified Data.Array.Accelerate                  as A
import qualified Data.Array.Accelerate.CUDA             as CUDA


main :: IO ()
main = do
  (cfg,args)            <- parseArgs defaultConfig defaultOptions =<< getArgs

  let (width,height)    = case args of
                            w:h:_ | [(w',[])] <- reads w
                                  , [(h',[])] <- reads h
                              -> (w',h')
                            _ -> error "usage: mandelbrot width height [criterion options]"

      test s            = printf "%s/%dx%d" s width height

      view :: (Float,Float,Float,Float)
      view      = (-2.23, -1.15, 0.83, 1.15)
      view'     = A.fromList A.Z [view]
      depth     = 255

      runCUDA1  = CUDA.run1 (A1.mandelbrot width height depth)
      runCUDA2  = CUDA.run1 (A2.mandelbrot width height depth)
      runCUDA3  = CUDA.run1 (A3.mandelbrot width height depth)

  withArgs (drop 2 args) $
    defaultMainWith cfg (return ())
      [ bench (test "acc-cuda-1")       $ whnf runCUDA1 view'
      , bench (test "acc-cuda-2")       $ whnf runCUDA2 view'
      , bench (test "acc-cuda-3")       $ whnf runCUDA3 view'
      , bench (test "repa")             $ whnfIO (R.mandelbrot width height depth view)
      ]

