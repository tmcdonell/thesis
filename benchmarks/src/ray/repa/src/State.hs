
module State
  where

import Light
import Object
import World
import Vec3


-- World ----------------------------------------------------------------------
-- | World and interface state.
data State
        = State
        { stateTime             :: !Float
        , stateEyePos           :: !Vec3
        , stateEyeLoc           :: !Vec3

        , stateMoveSpeed        :: !Float
        , stateMovingForward    :: !Bool
        , stateMovingBackward   :: !Bool
        , stateMovingLeft       :: !Bool
        , stateMovingRight      :: !Bool

        , stateObjects          :: ![Object]
        , stateObjectsView      :: ![Object]

        , stateLights           :: ![Light]
        , stateLightsView       :: ![Light] }

        deriving (Eq, Show)


-- | Initial world and interface state.
initState :: Float -> State
initState time
        = advanceState 0.75
        $ State
        { stateTime             = time
        , stateEyePos           = Vec3 50    (-100) (-700)
        , stateEyeLoc           = Vec3 (-50) 200   1296

        , stateMoveSpeed        = 400
        , stateMovingForward    = False
        , stateMovingBackward   = False
        , stateMovingLeft       = False
        , stateMovingRight      = False

        , stateObjects          = makeObjects time
        , stateObjectsView      = makeObjects time

        , stateLights           = makeLights  time
        , stateLightsView       = makeLights  time }


-- | Advance the world forward in time.
advanceState :: Float -> State -> State
advanceState advTime state
 = let  time'   = stateTime state + advTime

        speed   = stateMoveSpeed state
        move    = (if stateMovingForward state
                        then moveEyeLoc (Vec3 0 0 (-speed * advTime))
                        else id)
                . (if stateMovingBackward state
                        then moveEyeLoc (Vec3 0 0 (speed * advTime))
                        else id)
                . (if stateMovingLeft state
                        then moveEyeLoc (Vec3 (speed * advTime) 0 0)
                        else id)
                . (if stateMovingRight state
                        then moveEyeLoc (Vec3 (-speed * advTime) 0 0)
                        else id)

   in   setTime time' $ move state
{-# NOINLINE advanceState #-}


-- | Set the location of the eye.
setEyeLoc :: Vec3 -> State -> State
setEyeLoc eyeLoc state
 = let  objects = makeObjects (stateTime state)
        lights  = makeLights  (stateTime state)
   in state
        { stateEyeLoc           = eyeLoc
        , stateObjectsView      = map (translateObject (stateEyeLoc state)) objects
        , stateLightsView       = map (translateLight  (stateEyeLoc state)) lights
        }
{-# NOINLINE setEyeLoc #-}


moveEyeLoc :: Vec3 -> State -> State
moveEyeLoc v state
 = let  objects = stateObjects state
        lights  = stateLights  state
        eyeLoc  = stateEyeLoc  state + v
   in state
        { stateEyeLoc           = eyeLoc
        , stateObjectsView      = map (translateObject eyeLoc) objects
        , stateLightsView       = map (translateLight  eyeLoc) lights
        }
{-# NOINLINE moveEyeLoc #-}


-- | Set the time of the world.
setTime   :: Float -> State -> State
setTime time state
 = let  objects = makeObjects time
        lights  = makeLights  time
   in state
        { stateTime             = time
        , stateObjects          = objects
        , stateObjectsView      = map (translateObject (stateEyeLoc state)) objects

        , stateLights           = lights
        , stateLightsView       = map (translateLight  (stateEyeLoc state)) lights
        }
{-# NOINLINE setTime #-}

