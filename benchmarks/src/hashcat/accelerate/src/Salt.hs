
module Salt where

import Data.ByteString.Lazy     ( ByteString )

-- Add salt to an MD5 password block. Salt can be added before or after the
-- password.
--
-- TODO: implement helpers to extract salt from a hash, append/prepend to a
--       password
--
type Salt = ByteString -> ByteString

{-# INLINE unsalted #-}
unsalted :: Salt
unsalted = id

