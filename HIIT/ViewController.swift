//
//  ViewController.swift
//  HIIT
//
//  Created by Dmitry Roytman on 20.04.16.
//  Copyright © 2016 Dmitry Roytman. All rights reserved.
//

import UIKit

let actionColor = UIColor(red: 253/255, green: 107/255, blue: 7/255, alpha: 1.0)
let relaxColor = UIColor(red: 84/255, green: 193/255, blue: 158/255, alpha: 1.0)

class ViewController: UIViewController {
    // MARK: - IBOutlet's
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var actionIndicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var actionIndicator: UIView!
    private(set) var training: Training!
    private var isStarted = false
    @IBOutlet weak var blindView: UIView!
    @IBOutlet weak var cyclesLabel: UILabel!
    
    // MARK: - IBAction's
    @IBAction func action(sender: AnyObject) {
        isStarted = !isStarted
        isStarted ? training.start() : training.stop()
        actionButton.setTitle(isStarted ? "Pause" : "Continue", forState: .Normal)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !isStarted { reset() }
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && PreferencesManager.shared.isShakeGestureAllow {
            resetAction()
        }
    }
}

// MARK: Helper's thats update view relating on current cycle state
extension ViewController {
    private func updateLabels() {
        let duration = training.duration
        let MULTPL = 60
        let DELIM = 10
        let minutes = (duration/DELIM) / MULTPL
        let seconds = (duration/DELIM) % MULTPL
        let ms = ((duration - minutes*MULTPL - seconds*DELIM) * 100) % 1000
        timerTitle.text = String(format: "%.02dm:%.02ds.%.03dms", minutes, seconds, ms)
        actionTitle.text = training.inActivePhase ? "Action" : "Relax"
        cyclesLabel.text = String(format: "Cycles: %d of %d", (training.phase.cyclesQuantity-training.cycles.count+1),training.phase.cyclesQuantity)
    }
    private func updateActivityIndicator() {
        var ms = training.duration % 10
        if ms == 0 { ms = 10 }
        if training.inActivePhase {
            let seconds = CGFloat(150 - training.getFirstCycle()!.actionTime * 10 + ms)
            actionIndicatorHeight.constant = floor(actionIndicator.frame.height * seconds / 150)
            view.backgroundColor = relaxColor
            blindView.backgroundColor = relaxColor
            actionIndicator.backgroundColor = actionColor
        } else {
            let seconds = CGFloat(600 - training.getFirstCycle()!.relaxTime * 10 + ms)
            actionIndicatorHeight.constant = floor(actionIndicator.frame.height * seconds / 600)
            view.backgroundColor = actionColor
            blindView.backgroundColor = actionColor
            actionIndicator.backgroundColor = relaxColor
        }
    }
    func resetAction() {
        if isStarted { action(actionButton) }
        let alert = UIAlertController(title: "Reset?", message: "Do you really want to reset current state?", preferredStyle: .Alert)
        let reset = UIAlertAction(title: "Reset", style: .Destructive, handler: {
            [unowned self] _ in
            self.reset()
            })
        alert.addAction(reset)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func reset() {
        training = Training(phase: PreferencesManager.shared.choosenPhase)
        training.onTimerFire = { [unowned self] in
            self.updateLabels()
            self.updateActivityIndicator()
        }
        timerTitle.text = "HIIT PHASE \(PreferencesManager.shared.choosenPhase.name)"
        actionTitle.text = "To begin training please tap to \"Start\" button"
        actionButton.setTitle("Start", forState: .Normal)
        actionIndicatorHeight.constant = 0
        view.backgroundColor = actionColor
        cyclesLabel.text = ""
    }
}


