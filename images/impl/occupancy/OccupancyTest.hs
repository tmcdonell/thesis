import Text.Printf
import Foreign.CUDA.Analysis

printData :: IO ()
printData
  = putStrLn
  $ unlines
  $ map (\(t,x,y,z,w) -> printf "%d\t%.2f\t%.2f\t%.2f\t%.2f" t x y z w) testData

testData :: [(Int, Double, Double, Double, Double)]
testData =
  map (\t -> let smem = 16 * t
                 regs = 22
             in (t, occupancy100 $ occupancy device13 t regs smem
                  , occupancy100 $ occupancy device21 t regs smem
                  , occupancy100 $ occupancy device35 t regs smem
                  , occupancy100 $ occupancy device50 t regs smem
                ))
      threads



basicDevice :: DeviceProperties
basicDevice =  DeviceProperties
  { deviceName                  = ""
  , computeCapability           = Compute 0 0
  , totalGlobalMem              = 0
  , totalConstMem               = 0
  , sharedMemPerBlock           = -1
  , regsPerBlock                = -1
  , warpSize                    = 32
  , maxThreadsPerBlock          = -1
  , maxThreadsPerMultiProcessor = -1
  , maxBlockSize                = (0,0,0)
  , maxGridSize                 = (0,0,0)
  , maxTextureDim1D             = 0
  , maxTextureDim2D             = (0,0)
  , maxTextureDim3D             = (0,0,0)
  , clockRate                   = 0
  , multiProcessorCount         = 0
  , memPitch                    = 0
  , memBusWidth                 = 0
  , memClockRate                = 0
  , textureAlignment            = 0
  , computeMode                 = Default
  , deviceOverlap               = True
  , concurrentKernels           = True
  , eccEnabled                  = True
  , asyncEngineCount            = 0
  , cacheMemL2                  = -1
  , tccDriverEnabled            = True
  , pciInfo                     = PCI { busID = 1, deviceID = 0, domainID = 0 }
  , kernelExecTimeoutEnabled    = True
  , integrated                  = False
  , canMapHostMemory            = True
  , unifiedAddressing           = True
  }

device13 :: DeviceProperties
device13 = basicDevice
  { computeCapability           = Compute 1 3
  , sharedMemPerBlock           = 16384
  , regsPerBlock                = 16384
  , maxThreadsPerBlock          = 512
  , maxThreadsPerMultiProcessor = 1024
  }

device21 :: DeviceProperties
device21 = basicDevice
  { computeCapability           = Compute 2 1
  , sharedMemPerBlock           = 16384
  , regsPerBlock                = 32768
  , maxThreadsPerBlock          = 1024
  , maxThreadsPerMultiProcessor = 1536
  }

device35 :: DeviceProperties
device35 = basicDevice
  { computeCapability           = Compute 3 5
  , sharedMemPerBlock           = 16384
  , regsPerBlock                = 65536
  , maxThreadsPerBlock          = 1024
  , maxThreadsPerMultiProcessor = 2048
  }

device50 :: DeviceProperties
device50 = basicDevice
  { computeCapability           = Compute 5 0
  , sharedMemPerBlock           = 16384
  , regsPerBlock                = 65536
  , maxThreadsPerBlock          = 1024
  , maxThreadsPerMultiProcessor = 2048
  }


threads :: [Int]
threads =
  [ 32
  , 64
  , 96
  , 128
  , 160
  , 192
  , 224
  , 256
  , 288
  , 320
  , 352
  , 384
  , 416
  , 448
  , 480
  , 512
  , 544
  , 576
  , 608
  , 640
  , 672
  , 704
  , 736
  , 768
  , 800
  , 832
  , 864
  , 896
  , 928
  , 960
  , 992
  , 1024
  , 1056
  , 1088
  , 1120
  , 1152
  , 1184
  , 1216
  , 1248
  , 1280
  , 1312
  , 1344
  , 1376
  , 1408
  , 1440
  , 1472
  , 1504
  , 1536 ]

