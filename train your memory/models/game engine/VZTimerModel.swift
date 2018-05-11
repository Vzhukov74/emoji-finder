//
//  VZTimerModel.swift
//  emojiFinder
//
//  Created by Vlad on 24.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class VZTimerFormatter {
    class private func getWith(units: NSCalendar.Unit) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }
    
    class func timeAsStringFor(time: Double) -> String {
        if time > (60 * 60) {
            return VZTimerFormatter.getWith(units: [.hour, .minute, .second]).string(from: time) ?? ""
        } else {
            return VZTimerFormatter.getWith(units: [.minute, .second]).string(from: time) ?? ""
        }
    }
}

class VZTimerModel {
    
    private enum State {
        case suspended
        case resumed
    }
    
    private let queue = DispatchQueue(label: "md.vz.timer")
    private var _timer: DispatchSourceTimer?
    private var _start: CFTimeInterval?
    private var _totalElapsed = CFTimeInterval(0)//CFTimeInterval?
    private var _state: State = .suspended
    
    var updateTime: ((_ time: String?) -> Void)?
    var isTimerActive: Bool {
        return _start != nil
    }
    
    init() {
        createTimer()
    }
    
    func toggle() {
        assert(self.updateTime != nil)
        if _start == nil {
            startTimer()
        } else {
            pauseTimer()
        }
    }
    
    func pause() {
        pauseTimer()
    }
    
    func getTime() -> Int64 {
        return Int64(_totalElapsed)
    }
    
    func reset() {
        self.updateTime?("")
        _totalElapsed = CFTimeInterval(0)
    }
        
    private func createTimer() {
        _timer = DispatchSource.makeTimerSource(queue: queue)
        _timer?.schedule(deadline: .now(), repeating: 1.0)
        
        _timer?.setEventHandler { [weak self] in
            guard let start = self?._start else { return }
            guard let totalElapsed = self?._totalElapsed else { return }
            
            let elapsed = totalElapsed + CACurrentMediaTime() - start
            
            self?.updateTime?(VZTimerFormatter.timeAsStringFor(time: elapsed))
        }
    }
    
    private func startTimer() {
        if _state == .resumed {
            return
        }
        _state = .resumed
        
        _start = CACurrentMediaTime()
        _timer?.resume()
    }
    
    private func pauseTimer() {
        
        if _state == .suspended {
            return
        }
        _state = .suspended
        
        _timer?.suspend()
        _totalElapsed += (CACurrentMediaTime() - (_start ?? CFTimeInterval(0)))
        _start = nil
    }
    
    deinit {
        _timer?.setEventHandler {}
        _timer?.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here
         https://forums.developer.apple.com/thread/15902
         */
        startTimer()
        updateTime = nil
        
        print("deinit - VZTimerModel")
    }
}
