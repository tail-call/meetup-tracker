//
//  ViewController.swift
//  Meetup Tracker
//
//  Created by Anton Istomin on 2019-02-14.
//  Copyright © 2019 Tail Call. All rights reserved.
//

import Cocoa

extension TimeInterval {
    var formatted: String {
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let secondsString = String(format: "%02d", seconds)
        let minutes = Int(self / 60)
        let minutesString = String(format: "%02d", minutes)
        return "\(minutesString):\(secondsString)"
    }
}

struct TimeMark {
    var time: TimeInterval
    var length: TimeInterval
    var comment: String
}

class ViewController: NSViewController {
    private var timeMarks: [TimeMark] = []
    private var dateStarted: Date?
    private var passed: Double {
        return Date().timeIntervalSince(self.dateStarted!)
    }
    private var difference: Double {
        if let lastMark = timeMarks.last?.time {
            return passed - lastMark
        } else {
            return passed
        }
    }

    
    // MARK: - Outlets

    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var timeMarksTableView: NSTableView!
    @IBOutlet weak var timeColumn: NSTableColumn!
    @IBOutlet weak var lengthColumn: NSTableColumn!
    @IBOutlet weak var commentColumn: NSTableColumn!
    @IBOutlet weak var actionButton: NSButton!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        

        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        if dateStarted == nil {
            dateStarted = Date()
            actionButton.title = "Mark"
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.displayTime()
            }
        } else {
            timeMarks.append(TimeMark(time: passed, length: difference, comment: "-------------"))
            timeMarksTableView.reloadData()
            displayTime()
        }
    }
    
    @IBAction func cellTextEdited(_ sender: Any) {
        guard let textField = sender as? NSTextField else {
            return
        }
        
        timeMarks[timeMarksTableView.selectedRow].comment = textField.stringValue
    }
    
    // MARK: - Private methods
    
    private func displayTime() {
        timerLabel.stringValue = "\(passed.formatted) \(difference.formatted)"
    }
    
}

// MARK: - NSTableViewDelegate implementation

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        
        if tableColumn == timeColumn {
            view.textField?.stringValue = timeMarks[row].time.formatted
        } else if tableColumn == lengthColumn {
            view.textField?.stringValue = timeMarks[row].length.formatted
        } else if tableColumn == commentColumn {
            view.textField?.stringValue = timeMarks[row].comment
        }
        
        return view
    }
}

// MARK: - NSTableViewDataSource implementation

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return timeMarks.count
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
    }
}
