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
    var relaxTime = 60
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
    var actionTime = 30
    var relaxTime = 15
}