//
//  RealmManager.swift
//  myWorkout
//
//  Created by Миша on 14.04.2022.
//

import Foundation
import RealmSwift

class RealmManager {
    
    // синглтон для работы с реалмом
    static let shared = RealmManager()
    private init(){}
    
    let localRealm = try! Realm()
}

// MARK: - Workout settings
extension RealmManager {

    func saveWorkoutModel(model: WorkoutRealmModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteWorkoutModel(model: WorkoutRealmModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    // обновление модели при редактировании
    func udateSetsRepsWorkoutModel(model: WorkoutRealmModel, sets: Int, reps: Int) {
        try! localRealm.write {
            model.workoutSets = sets
            model.workoutReps = reps
        }
    }
    
    // обновление при выполнении упражнения
    func updateStatusWorkoutModel(model: WorkoutRealmModel) {
        try! localRealm.write {
            model.workoutStatus = true
        }
    }
    
    // обновление таймера
    func updateSetsTimerWorkoutModel(model: WorkoutRealmModel, sets: Int, timer: Int) {
        try! localRealm.write {
            model.workoutSets = sets
            model.workoutTimer = timer
        }
    }
}


// MARK: - User settings
extension RealmManager {
    
    func saveUserModel(model: UserRealmModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteUserModel(model: UserRealmModel) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    // обновление при выполнении упражнения
    func updateUserModel(model: UserRealmModel) {
        let users = localRealm.objects(UserRealmModel.self)
        try! localRealm.write {
            users[0].userFirstName = model.userFirstName
            users[0].userLastName = model.userLastName
            users[0].userHeight = model.userHeight
            users[0].userWeight = model.userWeight
            users[0].userTarget = model.userTarget
            users[0].userImage = model.userImage
        }
    }
}
