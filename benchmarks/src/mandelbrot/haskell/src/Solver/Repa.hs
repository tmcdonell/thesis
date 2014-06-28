{-# LANGUAGE BangPatterns        #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Solver.Repa (mandelbrot) where

import Data.Array.Repa                          as R
import Data.Array.Repa.Repr.HintInterleave      as R

import Data.Bits
import Data.Word


type RGBA32     = Word32

-- Mandelbrot Set --------------------------------------------------------------

mandelbrot
    :: (Floating a, Ord a)
    => Int
    -> Int
    -> Int
    -> (a, a, a, a)
    -> IO (Array U DIM2 RGBA32)
mandelbrot screenX screenY countMax (xmin, ymin, xmax, ymax)
  = R.computeP
  $ R.hintInterleave
  $ R.fromFunction (Z :. screenY :. screenX) pixelOfIndex
  where
    sizex       = xmax - xmin
    sizey       = ymax - ymin
    viewx       = fromIntegral screenX
    viewy       = fromIntegral screenY

    {-# INLINE pixelOfIndex #-}
    pixelOfIndex (Z :. y :. x) =
      let x' = xmin + (fromIntegral x * sizex) / viewx
          y' = ymin + (fromIntegral y * sizey) / viewy
      in
      prettyRGBA countMax $ mandelRun countMax x' y'
{-# INLINE mandelbrot #-}


mandelRun :: forall a. (Floating a, Ord a) => Int -> a -> a -> Int
mandelRun countMax cr ci = go cr ci 0
  where
    go :: a -> a -> Int -> Int
    go !zr !zi  !count
      | count >= countMax       = count
      | zr * zr + zi * zi > 4   = count

      | otherwise
      = let !z2r     = zr*zr - zi*zi
            !z2i     = 2 * zr * zi
            !yr      = z2r + cr
            !yi      = z2i + ci
        in  go yr yi (count + 1)
{-# INLINE mandelRun #-}


-- Rendering -------------------------------------------------------------------

prettyRGBA :: Int -> Int -> RGBA32
prettyRGBA cmax c
  | c == cmax   = 0xFF000000
  | otherwise   = escapeToColour (cmax - c)
{-# INLINE prettyRGBA #-}

escapeToColour :: Int -> RGBA32
escapeToColour m = 0xFFFFFFFF - (packRGBA32 (x,y,z,w))
  where
    x   = 0
    w   = fromIntegral (3 * m)
    z   = fromIntegral (5 * m)
    y   = fromIntegral (7 * m)

    packRGBA32 :: (Word8, Word8, Word8, Word8) -> RGBA32
    packRGBA32 (r, g, b, a)
        = let r'      = fromIntegral r
              g'      = fromIntegral g
              b'      = fromIntegral b
              a'      = fromIntegral a

          in    unsafeShiftL a' 24
            .|. unsafeShiftL b' 16
            .|. unsafeShiftL g' 8
            .|. r'
{-# INLINE escapeToColour #-}

