//
//  SaveButton.swift
//  myWorkout
//
//  Created by Миша on 13.04.2022.
//

import UIKit

import UIKit

class SaveButton: UIButton {

    private var action: (()->())?
    private var text: String?
    
    convenience init(text: String, action: @escaping ()->()) {
        self.init(type: .system)
        self.action = action
        self.text = text
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialGreen
        setTitle(text, for: .normal)
        tintColor = .specialBackground
        titleLabel?.font = .robotoBold16()
        layer.cornerRadius = 10
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    private func buttonTapped() {
        guard let action = action else {return}
        action()
    }
}
