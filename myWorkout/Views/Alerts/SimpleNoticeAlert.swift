//
//  SimpleNoticeAlert.swift
//  myWorkout
//
//  Created by Миша on 19.04.2022.
//

import UIKit

extension UIViewController {
    
    func simpleNoticeAlert(title: String, message: String?){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
