//
//  Cycle.swift
//  HIIT
//
//  Created by Dmitry Roytman on 20.04.16.
//  Copyright © 2016 Dmitry Roytman. All rights reserved.
//

import Foundation

protocol Cycle {
    var actionTime: Int {get set}
    var relaxTime: Int {get set}
    var duration: Int {get}
}

extension Cycle {
    var duration: Int {
        return actionTime + relaxTime
    }
}

class FirstPhaseCycle: Cycle {
    var actionTime = 15
    var relaxTime = 45
}

class SecondPhaseCycle: Cycle {
    var actionTime = 30
    var relaxTime = 60
}

class ThirdPhaseCycle: Cycle {
    var actionTime = 30
    var relaxTime = 30
}

class FourthPhaseCycle: Cycle {
    var actionTime = 45
    var relaxTime = 15
}

class CustomPhaseCycle: Cycle {
    var actionTime: Int
    var relaxTime: Int
    init(actionTime: Int, recoveryTime: Int) {
        self.actionTime = actionTime
        self.relaxTime = recoveryTime
    }
    convenience init() {
        self.init(actionTime: PreferencesManager.shared.customPhaseActionTime, recoveryTime: PreferencesManager.shared.customPhaseRecoveryTime)
    }
}

enum Phase: Int {
    case First = 0, Second, Third, Fourth, Custom
    
    var cyclesQuantity: Int {
        switch self {
        case .First, .Second: return 12
        case .Third: return 19
        case .Fourth: return 26
        case .Custom: return PreferencesManager.shared.customPhaseCyclesQuantity
        }
    }
    
    var cycleFabric: Cycle {
        switch self {
        case .First: return FirstPhaseCycle()
        case .Second: return SecondPhaseCycle()
        case .Third: return ThirdPhaseCycle()
        case .Fourth: return FourthPhaseCycle()
        default:
            return CustomPhaseCycle()
        }
    }
    
    var name: String {
        return self == .Custom ? "Custom" : "\(self.rawValue+1)"
    }
}

final class PreferencesManager {
    static let shared = PreferencesManager()
    enum Keys: String {
        case CustomPhaseCyclesQuantity, ChoosenPhase, CustomPhaseRecoveryTime, CustomPhaseActionTime, IsShakeGestureAllow
    }
    
    var choosenPhase: Phase {
        get {
            let phase = NSUserDefaults.standardUserDefaults().integerForKey(Keys.ChoosenPhase.rawValue) ?? 0
            return Phase(rawValue: phase)!
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: Keys.ChoosenPhase.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var customPhaseCyclesQuantity: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Keys.CustomPhaseCyclesQuantity.rawValue) ?? 1
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: Keys.CustomPhaseCyclesQuantity.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var customPhaseRecoveryTime: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Keys.CustomPhaseRecoveryTime.rawValue) ?? 1
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: Keys.CustomPhaseRecoveryTime.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var customPhaseActionTime: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(Keys.CustomPhaseActionTime.rawValue) ?? 1
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: Keys.CustomPhaseActionTime.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var isShakeGestureAllow: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Keys.IsShakeGestureAllow.rawValue) ?? false
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Keys.IsShakeGestureAllow.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}