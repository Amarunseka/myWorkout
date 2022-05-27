//
//  SpecialSlider.swift
//  myWorkout
//
//  Created by Миша on 12.04.2022.
//

import UIKit

class SpecialSlider: UISlider {
    
    private var action: (()->())?
    
    convenience init(maximumValue: Float, action: @escaping ()->()) {
        self.init()
        self.action = action
        self.maximumValue = maximumValue
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
        translatesAutoresizingMaskIntoConstraints = false
        minimumValue = 0
        maximumTrackTintColor = .specialBrown
        minimumTrackTintColor = .specialGreen
        thumbTintColor = .specialYellow
        addTarget(self, action: #selector(sliderAction), for: .valueChanged)

    }
    
    @objc
    private func sliderAction() {
        guard let action = action else {return}
        action()
    }
}
