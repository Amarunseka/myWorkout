//
//  ProfileCollectionViewCell.swift
//  myWorkout
//
//  Created by Миша on 10.05.2022.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let workoutNameLabel = UILabel.bigColorLabel(text: "PUSH UPS", color: .white)
   
    private let repsCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "180"
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Bold", size: 40)
        return label
    }()
    
    private let workoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bicepsImage")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor = .specialGreen
        layer.cornerRadius = 10
        
        addSubview(workoutNameLabel)
        addSubview(repsCounterLabel)
        addSubview(workoutImageView)
        
        workoutNameLabel.textAlignment = .center
    }
    
    private func configureCell(color: UIColor, model: ResultWorkoutModel) {
        backgroundColor = color
        workoutNameLabel.text = model.name
        repsCounterLabel.text = "\(model.result)"
    }
    
    func configureProfileCell(color: UIColor, model: ResultWorkoutModel) {
        configureCell(color: color, model: model)
    }
}

// MARK: - constraints
extension ProfileCollectionViewCell {
    
    private func setupConstraints(){
        let constraints = [
            workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            workoutNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            workoutNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            repsCounterLabel.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 20),
            repsCounterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            workoutImageView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 12),
            workoutImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

