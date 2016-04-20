//
//  ViewController.swift
//  HIIT
//
//  Created by Dmitry Roytman on 20.04.16.
//  Copyright © 2016 Dmitry Roytman. All rights reserved.
//

import UIKit

let actionColor = UIColor.orangeColor()
let relaxColor = UIColor(red: 84/255, green: 193/255, blue: 158/255, alpha: 1.0)

class ViewController: UIViewController {
    // MARK: - IBOutlet's
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var relaxIndicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var actionIndicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var relaxIndicator: UIView!
    @IBOutlet weak var actionIndicator: UIView!
    private(set) var training: Training!
    private var isStarted = false
    // MARK: - IBAction's
    @IBAction func action(sender: AnyObject) {
        isStarted = !isStarted
        if isStarted {
            training.start()
        } else {
            training.stop()
        }
        actionButton.setTitle(isStarted ? "Pause" : "Continue", forState: .Normal)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
}

// MARK: Helper's thats update view relating on current cycle state
extension ViewController {
    func setTimerLabel() {
        let duration = training.duration
        let MULTPL = 60
        let DELIM = 10
        let minutes = (duration/DELIM) / MULTPL
        let seconds = (duration/DELIM) % MULTPL
        let ms = ((duration - minutes*MULTPL - seconds*DELIM) * 100) % 1000
        timerTitle.text = String(format: "%.02dm:%.02ds.%.03dms", minutes, seconds, ms)
        timerTitle.textColor = training.inActivePhase ? actionColor : relaxColor
        actionTitle.text = training.inActivePhase ? "Action" : "Relax"
        actionTitle.textColor = training.inActivePhase ? actionColor : relaxColor
    }
    func updateActivityIndicator() {
        if training.inActivePhase {
            actionIndicatorHeight.constant += floor(actionIndicator.frame.height / 150)
        } else {
            actionIndicatorHeight.constant = 0
        }
    }
    func updateRelaxIndicator() {
        if !training.inActivePhase {
            relaxIndicatorHeight.constant += floor(relaxIndicator.frame.height / 600)
        } else {
            relaxIndicatorHeight.constant = 0
        }
    }
    
    private func reset() {
        training = Training()
        training.onTimerFire = { [unowned self] in
            self.setTimerLabel()
            self.updateActivityIndicator()
            self.updateRelaxIndicator()
        }
        timerTitle.text = String(format: "%.02dm:%.02ds.%.03dms", 0, 0, 0)
        timerTitle.textColor = UIColor.blackColor()
        actionTitle.text = "To begin training please tap to \"Start\" button"
        actionTitle.textColor = UIColor.blackColor()
        actionButton.setTitle("Start", forState: .Normal)
        actionIndicatorHeight.constant = 0
        relaxIndicatorHeight.constant = 0
    }
}


