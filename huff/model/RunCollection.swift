//
//  RunCollection.swift
//  huff
//
//  Created by Xing Hui Lu on 12/22/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class RunCollection {
    var bestDistance: Double?
    var bestPace: Run?
    var currentRun: Run!
    
    var shouldUpdateBestDistance: Bool {
        guard let bDistance = bestDistance else {
            // if there's no best distances, then we should set one.
            return true
        }
        return currentRun.distance > bDistance
    }
    
    var shouldUpdateBestPace: Bool {
        guard let bPace = bestPace else {
            // if there's no best pace, then we should set one
            return true
        }
        let (bPaceMin, bPaceSec) = bPace.determinePace()
        let (cPaceMin, cPaceSec) = currentRun.determinePace()
        
        // if current run pace min is lower or if current run pace min 
        // and best run pace min is the same, check the seconds
        return cPaceMin < bPaceMin  || (cPaceMin == bPaceMin && cPaceSec < bPaceSec)
    }
    
    init(currentRun: Run) {
        self.currentRun = currentRun
    }
}
