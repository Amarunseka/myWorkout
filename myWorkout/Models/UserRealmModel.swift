//
//  UserRealmModel.swift
//  myWorkout
//
//  Created by Миша on 17.05.2022.
//

import Foundation
import RealmSwift

class UserRealmModel: Object {
    @Persisted var userFirstName: String = "Unknown"
    @Persisted var userLastName: String = "Unknown"
    @Persisted var userWeight: Int = 0
    @Persisted var userHeight: Int = 0
    @Persisted var userTarget: Int = 0
    @Persisted var userImage: Data?
}
