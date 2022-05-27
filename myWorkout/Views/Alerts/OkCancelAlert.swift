//
//  OkCancelAlert.swift
//  myWorkout
//
//  Created by Миша on 05.05.2022.
//

import UIKit

extension UIViewController {
    
    func okCancelAlert(title: String, message: String?, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
}
