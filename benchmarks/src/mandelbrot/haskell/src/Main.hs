--
-- A Mandelbrot set generator.
-- Originally submitted by Simon Marlow as part of Issue #49.
--

import qualified Solver.Repa                            as R
import qualified Solver.Accelerate                      as A
import qualified Solver.AccelerateUnrolled              as U

import Criterion.Config
import Criterion.Main
import System.Environment
import Text.Printf

import Prelude
import Control.Exception
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

      view :: (Double,Double,Double,Double)
      view      = (-2.23, -1.15, 0.83, 1.15)
      view'     = A.fromList A.Z [view]
      depth     = 255

      runCUDA   = CUDA.run1 (A.mandelbrot width height depth)
      runCUDA'  = CUDA.run1 (U.mandelbrot width height depth)

  putStrLn "initialising Accelerate"
  _             <- evaluate (runCUDA  view')
  _             <- evaluate (runCUDA' view')

  withArgs (drop 2 args) $
    defaultMainWith cfg (return ())
      [ bench (test "acc-cuda")         $ whnf runCUDA  view'
      , bench (test "acc-cuda-fixed")   $ whnf runCUDA' view'
      , bench (test "repa")             $ whnfIO (R.mandelbrot width height depth view)
      ]

