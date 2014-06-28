{-# LANGUAGE BangPatterns, PatternGuards #-}

import Trace
import State
import Vec3

import System.Environment
import qualified Graphics.Gloss.Data.Color              as G
import qualified Graphics.Gloss.Data.Point              as G
import qualified Graphics.Gloss.Raster.Field            as G
import qualified Data.Array.Repa                        as R
import qualified Data.Array.Repa.IO.BMP                 as R
import Criterion.Main
import Criterion.Config
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

      name n    = printf "%s/%dx%d" n width height

      fov       = 100
      bounces   = 4
      state     = initState 0

      scene     = G.makeFrame  width height
                $ tracePixel   width height fov bounces state

  R.writeImageToBMP "ray-repa.bmp" =<< R.computeUnboxedP scene

  withArgs (drop 2 rest) $
    defaultMainWith conf (return ())
        [ bench (name "repa")   $ whnfIO (R.computeUnboxedP scene)
        ]


-- Trace ----------------------------------------------------------------------
-- | Render a single pixel of the image.
tracePixel :: Int -> Int -> Int -> Int -> State -> G.Point -> G.Color
tracePixel !sizeX !sizeY !fov !bounces !state (x, y)
 = let  !sizeX'  = fromIntegral sizeX
        !sizeY'  = fromIntegral sizeY
        !aspect  = sizeX' / sizeY'
        !fov'    = fromIntegral fov
        !fovX    = fov' * aspect
        !fovY    = fov'

        !ambient = Vec3 0.3 0.3 0.3
        !eyePos  = stateEyePos state
        !eyeDir  = normaliseV3 ((Vec3 (x * fovX) ((-y) * fovY) 0) - eyePos)

        Vec3 r g b
          = traceRay    (stateObjectsView state)
                        (stateLightsView  state) ambient
                        eyePos eyeDir
                        bounces

   in   G.rawColor r g b 1.0
{-# INLINE tracePixel #-}

