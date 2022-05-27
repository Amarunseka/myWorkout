//
//  WorkoutTableViewCell.swift
//  myWorkout
//
//  Created by Миша on 07.04.2022.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    // MARK: - initial elements
    var tapStartButton: ((WorkoutRealmModel) -> ())?
    private var workoutModel = WorkoutRealmModel()
     var labelsStackView = UIStackView()
    
    private let backgroundCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .specialLightBrown
        return view
    }()

    private let workoutBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()

    private let workoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bicepsImage")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .specialBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pull Ups"
        label.textColor = .specialBlack
        label.font = .robotoMedium22()
        return label
    }()
    
    private let workoutRepsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reps: 10"
        label.textColor = .specialGray
        label.font = .robotoMedium16()
        return label
    }()

    private let workoutSetsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sets: 2"
        label.textColor = .specialGray
        label.font = .robotoMedium16()
        return label
    }()

    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .specialYellow
//        button.setTitle("START", for: .normal)
        button.titleLabel?.font = .robotoBold16()
//        button.tintColor = .specialDarkGreen
        button.layer.cornerRadius = 10
        button.addShadowOnView()
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods-actions
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        labelsStackView = UIStackView(
            arrangedSubviews: [workoutRepsLabel, workoutSetsLabel],
            axis: .horizontal,
            spacing: 10)
        // add Suviews
        addSubview(backgroundCell)
        addSubview(workoutBackgroundView)
        workoutBackgroundView.addSubview(workoutImageView)
        addSubview(workoutNameLabel)
        addSubview(labelsStackView)
        contentView.addSubview(startButton)
    }
    
    @objc private func startButtonTapped() {
        guard let tapStartButton = tapStartButton else {return}
        tapStartButton(workoutModel)
    }
    
    private func cellConfigure(model: WorkoutRealmModel){
        workoutModel = model
        // кортеж вычисления минут секунд
        let (min, sec) = { (secs: Int) -> (Int, Int) in
            return (secs / 60, secs % 60)
        }(model.workoutTimer) // после фигурных скобок это мы как бы сразу запускам наше замыкание
        

        workoutNameLabel.text = model.workoutName
        // !!! СДЕЛАТЬ ТАК ЧТОБЫ СЕКУНДЫ ОТОБРАЖАЛИСЬ С НОЛЯМИ
        workoutRepsLabel.text = model.workoutTimer == 0 ? "Reps: \(model.workoutReps)" : "Timer: \(min) min \(sec.setZeroForSecond()) sec"
        workoutSetsLabel.text = "Sets: \(model.workoutSets)"
        
        if model.workoutStatus {
            startButton.setTitle("COMPLETE", for: .normal)
            startButton.tintColor = .white
            startButton.backgroundColor = .specialGreen
            startButton.isEnabled = false
        } else {
            startButton.setTitle("START", for: .normal)
            startButton.tintColor = .specialDarkGreen
            startButton.backgroundColor = .specialYellow
            startButton.isEnabled = true
        }
        
        guard let imageData = model.workoutImage else {return}
        guard let image = UIImage(data: imageData) else {return}
        workoutImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    func workoutCellConfigure(model: WorkoutRealmModel) {
        cellConfigure(model: model)
    }
}

// MARK: - constraints
extension WorkoutTableViewCell {
    private func setupConstraints(){
        let constraints = [
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        
            workoutBackgroundView.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            workoutBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            workoutBackgroundView.heightAnchor.constraint(equalToConstant: 70),
            workoutBackgroundView.widthAnchor.constraint(equalToConstant: 70),
        
            workoutImageView.topAnchor.constraint(equalTo: workoutBackgroundView.topAnchor, constant: 10),
            workoutImageView.leadingAnchor.constraint(equalTo: workoutBackgroundView.leadingAnchor, constant: 10),
            workoutImageView.trailingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: -10),
            workoutImageView.bottomAnchor.constraint(equalTo: workoutBackgroundView.bottomAnchor, constant: -10),
        
            workoutNameLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 5),
            workoutNameLabel.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            workoutNameLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
        
            labelsStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 0),
            labelsStackView.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            labelsStackView.heightAnchor.constraint(equalToConstant: 20),
        
            startButton.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 5),
            startButton.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 30)
            ]
        NSLayoutConstraint.activate(constraints)
    }
}
