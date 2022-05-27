//
//  SpecialTextField.swift
//  myWorkout
//
//  Created by Миша on 07.05.2022.
//

import UIKit

class SpecialTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .specialLightBrown
        self.tintColor = .specialGreen
        self.textColor = .specialGray
        self.font = UIFont.robotoBold20()
        self.layer.cornerRadius = 10
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.leftViewMode = .always
        self.clearButtonMode = .always
        self.returnKeyType = .done
    }
}
