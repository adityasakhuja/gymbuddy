//
//  Rest.swift
//  GymBuddy
//
//  Created by Daniil Tarakanov on 11/03/2016.
//  Copyright © 2016 Daniil Tarakanov. All rights reserved.
//

import Foundation
import Bond

class Rest: NSObject {
    var time:Observable<Int> = Observable((0))
    var reps:Observable<Int> = Observable((0))
    
    init(time: Int, reps: Int) {
        self.time.value = time
        self.reps.value = reps
    }
}