//
//  UserPhotoImageView.swift
//  myWorkout
//
//  Created by Миша on 09.05.2022.
//

import UIKit

class UserPhotoImageView: UIImageView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGray3
        self.image = UIImage(named: "honeybadger")
        self.contentMode = .scaleToFill
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
        
    }
}
