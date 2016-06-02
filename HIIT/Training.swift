//
//  Training.swift
//  HIIT
//
//  Created by Dmitry Roytman on 20.04.16.
//  Copyright © 2016 Dmitry Roytman. All rights reserved.
//

import Foundation

class Training {
    private(set) var duration: Int = 0
    private(set) var cycles: [Cycle] = []
    private var timer: NSTimer!
    private(set) var phase: Phase
    var isFinished: Bool { return cycles.isEmpty }
    var inActivePhase: Bool = true {
        willSet {
            if newValue != inActivePhase {
                SpeechManager.shared.speech(newValue ? "Action" : "Relax")
            }
        }
    }
    var onTimerFire: (()->())!
    init(phase: Phase = .First) {
        self.phase = phase
        refresh()
    }
    
    func start() {
        stop()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    @objc private func fire() {
        guard var cycle = getFirstCycle() else { stop(); return }
        onTimerFire?()
        if duration % 10 == 0 {
            cycle.actionTime > 0 ? (cycle.actionTime -= 1) : (cycle.relaxTime -= 1)
        }
        duration += 1
        inActivePhase = cycle.actionTime > 0
    }
    private func refresh() {
        for _ in 0..<phase.cyclesQuantity {
            cycles.append(phase.cycleFabric)
        }
        if cycles.isEmpty { return }
        cycles[cycles.count-1].relaxTime = 0
    }
    
    func getFirstCycle() -> Cycle? {
        if cycles.isEmpty { return nil }
        if cycles[0].duration == 0 {
            cycles.removeAtIndex(0)
            return getFirstCycle()
        }
        return cycles[0]
    }
}