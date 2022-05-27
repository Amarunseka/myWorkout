//
//  DetailsView.swift
//  myWorkout
//
//  Created by Миша on 14.04.2022.
//

import UIKit

class DetailsView: UIView {
    
    // MARK: - initial elements
    private let exerciseNameLabel = UILabel.bigGrayLabel(text: "Biceps")
    private let setsLabel = UILabel.midlGrayLabel(text: "Sets")
    private let setsCoutLabel = UILabel.bigGrayLabel(text: "1/4")
    private let setsReparatorBarView = UIView.separatorBarView()
    private let repsLabel = UILabel.midlGrayLabel(text: "Reps")
    private let repsCountLabel = UILabel.bigGrayLabel(text: "20")
    private let repsReparatorBarView = UIView.separatorBarView()
    private let editingLabel = UILabel.midlBrownLabel(text: "Editing")
    private let pencilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pencil")
        return imageView
    }()

    
    private lazy var setsStackView = UIStackView(
        arrangedSubviews: [setsLabel, setsCoutLabel],
        axis: .horizontal,
        spacing: 10)
    
    private lazy var repsStackView = UIStackView(
        arrangedSubviews: [repsLabel, repsCountLabel],
        axis: .horizontal,
        spacing: 10)
    
    private lazy var editingStackView = UIStackView(
        arrangedSubviews: [pencilImageView, editingLabel],
        axis: .horizontal,
        spacing: 0)
    
    let nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .specialDarkYellow
        button.setTitle("NEXT SET", for: .normal)
        button.tintColor = .specialGray
        button.titleLabel?.font = UIFont.robotoBold16()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - methods-actions
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialLightBrown
        layer.cornerRadius = 10
        
        addSubview(exerciseNameLabel)
        addSubview(setsStackView)
        addSubview(setsReparatorBarView)
        addSubview(repsStackView)
        addSubview(repsReparatorBarView)
        addSubview(editingStackView)
        addSubview(nextSetButton)
    }
    
    @objc
    func nextSetButtonTapped(){
        print("nextSetButtonTapped")
    }
}

// MARK: - Constraints
extension DetailsView {
    private func setupConstraints() {
        let constraints = [
            exerciseNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            exerciseNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            setsStackView.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 25),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            setsReparatorBarView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 0),
            setsReparatorBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsReparatorBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            setsReparatorBarView.heightAnchor.constraint(equalToConstant: 1),
            
            repsStackView.topAnchor.constraint(equalTo: setsReparatorBarView.bottomAnchor, constant: 20),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            repsReparatorBarView.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 0),
            repsReparatorBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            repsReparatorBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            repsReparatorBarView.heightAnchor.constraint(equalToConstant: 1),
            
            editingStackView.topAnchor.constraint(equalTo: repsReparatorBarView.bottomAnchor, constant: 15),
            editingStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nextSetButton.topAnchor.constraint(equalTo: editingStackView.bottomAnchor, constant: 10),
            nextSetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextSetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextSetButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
