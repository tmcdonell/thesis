
module Solver.Accelerate.Common (

  View, Bitmap, Render, RGBA32,
  prettyRGBA,

) where

import Data.Array.Accelerate                    as A
import Data.Array.Accelerate.IO                 as A


-- Types -----------------------------------------------------------------------

-- Current view into the complex plane
type View a             = (a, a, a, a)

-- Image data
type Bitmap             = Array DIM2 RGBA32

-- Action to render a frame
type Render a           = Scalar (View a) -> Bitmap


-- Rendering -------------------------------------------------------------------

prettyRGBA :: Exp Int32 -> Exp Int32 -> Exp RGBA32
prettyRGBA cmax c = c ==* cmax ? ( 0xFF000000, escapeToColour (cmax - c) )

-- Directly convert the iteration count on escape to a colour. The base set
-- (x,y,z) yields a dark background with light highlights.
--
escapeToColour :: Exp Int32 -> Exp RGBA32
escapeToColour m = constant 0xFFFFFFFF - (packRGBA32 $ lift (x,y,z,w))
  where
    x   = constant 0
    w   = A.fromIntegral (3 * m)
    z   = A.fromIntegral (5 * m)
    y   = A.fromIntegral (7 * m)


{--
-- A simple colour scheme
--
prettyRGBA :: Elt a => Exp Int -> Exp (Complex a, Int) -> Exp RGBA32
prettyRGBA lIMIT s' = r + g + b + a
  where
    s   = A.snd s'
    t   = A.fromIntegral $ ((lIMIT - s) * 255) `quot` lIMIT
    r   = (t     `rem` 128 + 64) * 0x1000000
    g   = (t * 2 `rem` 128 + 64) * 0x10000
    b   = (t * 3 `rem` 256     ) * 0x100
    a   = 0xFF
--}
{--
prettyRGBA :: forall a. (Elt a, IsFloating a) => Exp Int -> Exp (Complex a, Int) -> Exp RGBA32
prettyRGBA lIMIT s =
  let cmax      = A.fromIntegral lIMIT          :: Exp a
      c         = A.fromIntegral (A.snd s)
  in
  c >* 0.98 * cmax ? ( 0xFF000000, rampColourHotToCold 0 cmax c )

-- Standard Hot-to-Cold hypsometric colour ramp. Colour sequence is
--   Red, Yellow, Green, Cyan, Blue
--
rampColourHotToCold
    :: (Elt a, IsFloating a)
    => Exp a                            -- ^ minimum value of the range
    -> Exp a                            -- ^ maximum value of the range
    -> Exp a                            -- ^ data value
    -> Exp RGBA32
rampColourHotToCold vmin vmax vNotNorm
  = let v       = vmin `A.max` vNotNorm `A.min` vmax
        dv      = vmax - vmin
        --
        result  = v <* vmin + 0.28 * dv
                ? ( lift ( constant 0.0
                         , 4 * (v-vmin) / dv
                         , constant 1.0
                         , constant 1.0 )

                , v <* vmin + 0.5 * dv
                ? ( lift ( constant 0.0
                         , constant 1.0
                         , 1 + 4 * (vmin + 0.25 * dv - v) / dv
                         , constant 1.0 )

                , v <* vmin + 0.75 * dv
                ? ( lift ( 4 * (v - vmin - 0.5 * dv) / dv
                         , constant 1.0
                         , constant 0.0
                         , constant 1.0 )

                ,   lift ( constant 1.0
                         , 1 + 4 * (vmin + 0.75 * dv - v) / dv
                         , constant 0.0
                         , constant 1.0 )
                )))
    in
    rgba32OfFloat result
--}

