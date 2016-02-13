// Modified
// Original taken from https://gist.github.com/jstn/d93c86f7bd2b6f22f0bf

import Darwin

class Timer {
    static var base: UInt64 = 0
    var startTime: UInt64 = 0
    var stopTime: UInt64 = 0
    
    init() {
        if Timer.base == 0 {
            var info = mach_timebase_info(numer: 0, denom: 0)
            mach_timebase_info(&info)
            Timer.base = UInt64(info.numer / info.denom)
        }
    }
    
    func start() {
        startTime = mach_absolute_time()
    }
    
    func elapsed_seconds() -> Double {
        stopTime = mach_absolute_time()
        return self.seconds
    }
    
    var nanoseconds: UInt64 {
        return (stopTime - startTime) * Timer.base
    }
    
    var milliseconds: Double {
        return Double(nanoseconds) / 1_000_000
    }
    
    var seconds: Double {
        return Double(nanoseconds) / 1_000_000_000
    }
}