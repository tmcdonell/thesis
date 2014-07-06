{-# LANGUAGE CPP #-}

module Main where

-- friends
import Scene.State
import Ray.Trace

-- frenemies
import Data.Array.Accelerate                                    as A
import Graphics.Gloss.Accelerate.Data.Color.RGB

import qualified Data.Array.Accelerate.CUDA                     as CUDA

-- import Data.Array.Accelerate.IO

-- library
import Prelude                                                  as P
import Control.Exception
import Criterion.Config
import Criterion.Main
import Data.Label
import System.Environment
import Text.Printf


main :: IO ()
main = do
  argv          <- getArgs
  (conf, rest)  <- parseArgs defaultConfig defaultOptions argv

  let (width,height)
                = case rest of
                    w:h:_ | [(w',[])] <- reads w, [(h',[])] <- reads h
                      -> (w',h')
                    _ -> error "usage: ray width height [criterion options]"

      fov       = 100
      bounces   = 4
      state     = initState 0
      ambient   = rawColor 0.3 0.3 0.3

      scene     = (get stateObjects state, get stateLights state)
      render st =
          let eye               = constant (get stateEyePos state)
              eyeDir            = castViewRays width height fov eye
              eyePos            = fill (constant (Z :. height :. width)) eye
              (objects, lights) = unlift st
          in
          A.map packABGR
              $ A.zipWith (traceRay bounces objects lights ambient) eyePos eyeDir

      name n    = printf "%s/%dx%d" n width height

      runCUDA   = CUDA.run1 render

--  putStrLn "initialising Accelerate"
--  _     <- evaluate (runCUDA scene)

--  writeImageToBMP "ray-cuda.bmp" (runCUDA scene)

  withArgs (P.drop 2 rest) $
    defaultMainWith conf (return ())
        [ bench (name "acc-cuda")       $ whnf runCUDA scene
        ]

