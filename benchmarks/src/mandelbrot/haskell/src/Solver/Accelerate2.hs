{-# LANGUAGE ScopedTypeVariables #-}
--
-- A Mandelbrot set generator.
-- Originally submitted by Simon Marlow as part of Issue #49.
--
module Solver.Accelerate2 (

  -- Pretty pictures
  mandelbrot,

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
-- This replicates the loop recovery pass that is no longer activate.
--
mandelbrot
    :: forall a. (Elt a, IsFloating a)
    => Int
    -> Int
    -> Int
    -> Acc (Scalar (View a))
    -> Acc Bitmap
mandelbrot screenX screenY depth view
  = A.generate (constant (Z:.screenY:.screenX))
  $ \ix -> let c  = initial ix
               z0 = lift (c, constant 0) :: Exp (Complex a, Int32)
           in prettyRGBA lIMIT
                $ A.snd
                $ A.fst
                $ A.while (\zii -> A.snd zii <* lIMIT)
                          (\zii -> let (zi,i) = unlift zii :: (Exp (Complex a, Int32), Exp Int32)
                                       zi'    = iter c zi
                                   in
                                   lift (zi', i+1))
                          (lift (z0, constant 0))

  where
    -- The view plane
    (xmin,ymin,xmax,ymax)     = unlift (the view)
    sizex                     = xmax - xmin
    sizey                     = ymax - ymin

    viewx                     = constant (P.fromIntegral screenX)
    viewy                     = constant (P.fromIntegral screenY)

    -- initial conditions for a given pixel in the window
    initial :: Exp DIM2 -> Exp (Complex a)
    initial ix = lift ( (xmin + (x * sizex) / viewx) :+ (ymin + (y * sizey) / viewy) )
      where
        pr = unindex2 ix
        x  = A.fromIntegral (A.snd pr :: Exp Int)
        y  = A.fromIntegral (A.fst pr :: Exp Int)

    -- take a single step of the iteration
    iter :: Exp (Complex a) -> Exp (Complex a, Int32) -> Exp (Complex a, Int32)
    iter c zi = next (A.fst zi) (A.snd zi)
     where
      next :: Exp (Complex a) -> Exp Int32 -> Exp (Complex a, Int32)
      next z i =
        let z' = c + z*z
        in (dot z' >* 4) ? ( zi , lift (z', i+1) )

    dot :: Exp (Complex a) -> Exp a
    dot c = let r :+ i = unlift c
            in  r*r + i*i

    lIMIT = P.fromIntegral depth

