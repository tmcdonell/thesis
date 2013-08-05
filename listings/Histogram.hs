{-# LANGUAGE TypeOperators #-}

import Prelude               as P
import Data.Array.Accelerate as A


histogram :: Acc (Vector Float) -> Acc (Vector Int)
histogram vec =
  let
      bins      = 10
      zeros     = fill (constant (Z :. bins)) 0
      ones      = fill (shape vec)            1
  in
  permute (+) zeros (\ix -> index1 (A.floor ((vec ! ix) / P.fromIntegral bins))) ones



-- wasting time doing stupid things...
{--
histogram :: Int -> Acc (Vector Float) -> Acc (Vector Int)
histogram bins vec =
  let
      zeros     = fill (constant (Z :. bins)) 0
      ones      = fill (shape vec)            1
      (m,n)     = unlift $ the (minmax vec)
      bin x     = ((x-m) / (n-m) * P.fromIntegral bins) - 1
  in
  permute (+) zeros (\ix -> index1 (A.round (bin (vec ! ix)) :: Exp Int)) ones


minmax :: (IsScalar a, Elt a, Shape sh) => Acc (Array (sh :. Int) a) -> Acc (Array sh (a,a))
minmax arr =
  let
      arr2      = A.map (\x -> lift (x,x)) arr
      cmp       = lift2 (\(m,n) (x,y) -> (A.min m x, A.max n y))
  in
  A.fold1 cmp arr2
--}

