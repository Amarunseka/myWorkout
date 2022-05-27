//
//  StatisticsTableViewCell.swift
//  myWorkout
//
//  Created by Миша on 08.04.2022.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    // MARK: - initial elements
    let exerciseNameLabel = UILabel.bigGrayLabel(text: "Biceps")
    private let progressLabel = UILabel.bigColorLabel(text: "+0", color: .specialGreen)
    private let beforeLabel = UILabel.smallBrownLabel(text: "Before: 00")
    private let nowLabel = UILabel.smallBrownLabel(text: "Now: 00")
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [beforeLabel, nowLabel],
        axis: .horizontal,
        spacing: 10)
    
    // MARK: - life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        backgroundColor = .clear
        selectionStyle = .none
  
        addSubview(exerciseNameLabel)
        addSubview(progressLabel)
        addSubview(stackView)
    }
    
    // ДОДЕЛАТЬ ОТОБРАЖЕНИЕ СТАТИСТИКИ У ТАЙМЕРА И СДЕЛАТЬ БОЛЕЕ БЕЗОПАСНЫЙ ВЫБОР МЕЖДУ ТАЙМЕРОМ И ПОВТОРЕНИЕМ
    private func cellConfigure(differenceWorkout: DifferenceWorkout){
        exerciseNameLabel.text = differenceWorkout.name
        var difference = 0
        var labelText = ""
        if differenceWorkout.previousTimer == 0 {
            beforeLabel.text = "Before: \(differenceWorkout.previousReps)"
            nowLabel.text = "Now: \(differenceWorkout.currentReps)"
            difference = differenceWorkout.currentReps - differenceWorkout.previousReps
            labelText = "\(difference)"
        } else {
            beforeLabel.text = "Before: \(convertTimerValue(differenceWorkout.previousTimer))"
            nowLabel.text = "Now: \(convertTimerValue(differenceWorkout.currentTimer))"
            difference = differenceWorkout.currentTimer - differenceWorkout.previousTimer
            labelText = convertTimerValue(difference)
        }
        
        progressLabel.text = "\(labelText)"
        
        switch difference {
        case ..<0:
            progressLabel.textColor = .systemRed
        case 1...:
            progressLabel.textColor = .specialGreen
        default:
            progressLabel.textColor = .specialYellow
        }
    }

    private func convertTimerValue(_ value: Int) -> String {
        let (min, sec) = value.convertSeconds()
        let sec00 = sec.setZeroForSecond()
        return "\(min):\(sec00)"
    }

    
    func statisticCellConfigure(differenceWorkout: DifferenceWorkout){
        cellConfigure(differenceWorkout: differenceWorkout)
    }
}

// MARK: - constraints
extension StatisticsTableViewCell {
    private func setupConstraints(){
        let constraints = [
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

            exerciseNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            exerciseNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 5),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: progressLabel.leadingAnchor, constant: 5)
            ]
        NSLayoutConstraint.activate(constraints)
    }
}

/*
private func cellConfigure(differenceWorkout: DifferenceWorkout){
    exerciseNameLabel.text = differenceWorkout.name
    if differenceWorkout.previousTimer == 0 {
        beforeLabel.text = "Before: \(differenceWorkout.previousReps)"
        nowLabel.text = "Now: \(differenceWorkout.currentReps)"
    } else {
        beforeLabel.text = "Before: \(convertTimerValue(differenceWorkout.previousTimer))"
        nowLabel.text = "Now: \(convertTimerValue(differenceWorkout.currentTimer))"
    }
    
    let difference = differenceWorkout.currentReps - differenceWorkout.previousReps
    progressLabel.text = "\(difference)"
    
    switch difference {
    case ..<0:
        progressLabel.textColor = .systemRed
    case 1...:
        progressLabel.textColor = .specialGreen
    default:
        progressLabel.textColor = .specialYellow
    }
}

private func convertTimerValue(_ value: Int) -> String {
    let (min, sec) = value.convertSeconds()
    let sec00 = sec.setZeroForSecond()
    return "\(min):\(sec00)"
}
*/
