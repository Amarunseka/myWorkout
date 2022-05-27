//
//  AddButton.swift
//  myWorkout
//
//  Created by Миша on 06.04.2022.
//

import UIKit

class AddWorkoutButton: UIButton {

    private var action: (()->())?
    
    convenience init(action: @escaping ()->()) {
        self.init(type: .system)
        self.action = action
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
        backgroundColor = .specialYellow
        setTitle("Add workout", for: .normal)
        titleLabel?.font = .robotoMedium12()
        setImage(UIImage(named: "addWorkout"), for: .normal)
        tintColor = .specialDarkGreen
        layer.cornerRadius = 10
        addShadowOnView()
        imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 15,
            right: 0)
        titleEdgeInsets = UIEdgeInsets(
            top: 50,
            left: -40,
            bottom: 0,
            right: 0)
        addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func addWorkoutButtonTapped() {
        guard let action = action else {return}
        action()
    }
}
