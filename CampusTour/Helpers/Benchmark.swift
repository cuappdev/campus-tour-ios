//
//  Benchmark.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/8/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation
import SwiftDate

func benchmark<T>(label: String, execute block: ()->T) -> T {
    let startTime = Date()
    let val = block()
    let endTime = Date()
    
    let elapsedTimeSeconds = (endTime - startTime)
    print("[BENCHMARK] elapsedTime for \(label) is \(elapsedTimeSeconds)s")
    
    return val
}
