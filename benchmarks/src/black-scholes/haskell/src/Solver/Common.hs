module Solver.Common
  where

riskfree, volatility :: Floating a => a
riskfree   = 0.02
volatility = 0.30


-- {-# INLINE horner #-}
-- horner :: Num a => [a] -> a -> a
-- horner coeff x = x * foldr1 madd coeff
--   where
--     madd a b = a + x*b

-- {-# INLINE poly #-}
poly :: Floating a => a -> a
poly k
  =  k * (0.31938154
  + (k * (-0.35656378
  + (k * (1.7814779
  + (k * (-1.8212559
  + (k * (1.3302745)))))))))

-- {-# INLINE cnd' #-}
cnd' :: Floating a => a -> a
cnd' d =
  let -- poly     = horner coeff
      -- coeff    = [0.31938153,-0.356563782,1.781477937,-1.821255978,1.330274429]
      rsqrt2pi = 0.39894228040143267793994605993438
      k        = 1.0 / (1.0 + 0.2316419 * abs d)
  in
  rsqrt2pi * exp (-0.5*d*d) * poly k

