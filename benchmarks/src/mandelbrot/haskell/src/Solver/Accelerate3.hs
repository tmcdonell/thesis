{-# LANGUAGE ScopedTypeVariables #-}
--
-- A Mandelbrot set generator.
-- Originally submitted by Simon Marlow as part of Issue #49.
--
module Solver.Accelerate3 (

  -- Types
  View, Render, Bitmap, RGBA32,

  -- Pretty pictures
  mandelbrot, prettyRGBA

) where

import Prelude                                  as P
import Data.Array.Accelerate                    as A
import Data.Array.Accelerate.Math.Complex

import Solver.Accelerate.Common


-- Mandelbrot Set --------------------------------------------------------------

-- Compute the mandelbrot as repeated application of the recurrence relation:
--
--   Z_{n+1} = c + Z_n^2
--
mandelbrot
    :: forall a. (Elt a, IsFloating a)
    => Int
    -> Int
    -> Int
    -> Acc (Scalar (View a))
    -> Acc Bitmap
mandelbrot screenX screenY depth view =
  generate (constant (Z:.screenY:.screenX))
           (\ix -> let c = initial ix
                   in prettyRGBA lIMIT
                        $ A.snd
                        $ A.while (\zi -> A.snd zi <* lIMIT &&* dot (A.fst zi) <* 4)
                                      (\zi -> lift1 (next c) zi)
                                      (lift (c, constant 0)))
  where
    -- The view plane
    (xmin,ymin,xmax,ymax)     = unlift (the view)
    sizex                     = xmax - xmin
    sizey                     = ymax - ymin

    viewx                     = constant (P.fromIntegral screenX)
    viewy                     = constant (P.fromIntegral screenY)

    -- initial conditions for a given pixel in the window, translated to the
    -- corresponding point in the complex plane
    initial :: Exp DIM2 -> Exp (Complex a)
    initial ix                = lift ( (xmin + (x * sizex) / viewx) :+ (ymin + (y * sizey) / viewy) )
      where
        pr = unindex2 ix
        x  = A.fromIntegral (A.snd pr :: Exp Int)
        y  = A.fromIntegral (A.fst pr :: Exp Int)

    -- take a single step of the iteration
    next :: Exp (Complex a) -> (Exp (Complex a), Exp Int32) -> (Exp (Complex a), Exp Int32)
    next c (z, i) = (c + (z * z), i+1)

    dot c = let r :+ i = unlift c
            in  r*r + i*i

    lIMIT = constant (P.fromIntegral depth)

