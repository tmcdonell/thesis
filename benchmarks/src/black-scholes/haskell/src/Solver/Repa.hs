module Solver.Repa
  where

import Solver.Common
import Data.Array.Repa                  as R

blackscholes :: Array U DIM1 (Float, Float, Float) -> IO (Array U DIM1 (Float, Float))
blackscholes = computeP . R.map go
  where
  go (price, strike, years) =
    let r       = riskfree
        v       = volatility
        v_sqrtT = v * sqrt years
        d1      = (log (price / strike) + (r + 0.5 * v * v) * years) / v_sqrtT
        d2      = d1 - v_sqrtT
        cnd d   = let c = cnd' d in if d > 0 then 1.0 - c
                                             else c
        cndD1   = cnd d1
        cndD2   = cnd d2
        x_expRT = strike * exp (-r * years)
    in
    ( price * cndD1 - x_expRT * cndD2
    , x_expRT * (1.0 - cndD2) - price * (1.0 - cndD1))

