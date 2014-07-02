
module Type where

import Data.Word

-- This implementation works on 2D points. In future, generalise this to some
-- arbitrary "feature vector".
--
type Point a = (a, a)

-- Clusters consist of the centroid location as well as its identifier
--
type Id         = Word32
type Cluster a  = (Id, (a, a))

-- We'll use this as an intermediate structure; it contains the number of points
-- in the set as well as the sum of the x and y coordinates respectively.
--
type PointSum a = (Word32, (a, a))

