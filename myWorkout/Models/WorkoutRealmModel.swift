//
//  WorkoutRealmModel.swift
//  myWorkout
//
//  Created by Миша on 14.04.2022.
//

import Foundation
import RealmSwift

class WorkoutRealmModel: Object {
    @Persisted var workoutDate: Date
    @Persisted var workoutNumberOfWeekday: Int = 0
    @Persisted var workoutName: String = "Unknown"
    @Persisted var workoutRepeat: Bool = true
    @Persisted var workoutSets: Int = 0
    @Persisted var workoutReps: Int = 0
    @Persisted var workoutTimer: Int = 0
    @Persisted var workoutImage: Data?
    @Persisted var workoutStatus: Bool = false
}
