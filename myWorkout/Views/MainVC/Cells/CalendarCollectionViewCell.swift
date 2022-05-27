//
//  CalendarCollectionViewCell.swift
//  myWorkout
//
//  Created by Миша on 07.04.2022.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    // MARK: initial elements
    let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .robotoBold16()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let numberOfWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .robotoBold20()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    /// метод отрабатывает когда ячейка выделена
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                backgroundColor = .specialYellow
                dayOfWeekLabel.textColor = .specialBlack
                numberOfWeekLabel.textColor = .specialDarkGreen
            } else {
                backgroundColor = .specialGreen
                dayOfWeekLabel.textColor = .white
                numberOfWeekLabel.textColor = .white
            }
        }
    }
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods-actions
    private func setupView() {
        addSubview(dayOfWeekLabel)
        addSubview(numberOfWeekLabel)
        layer.cornerRadius = 10
    }
    
    private func cellConfigure(numberOfDay: String, dayOfWeek: String){
        numberOfWeekLabel.text = numberOfDay
        dayOfWeekLabel.text = dayOfWeek
    }
    
    func setDaysForCell(numberOfDay: String, dayOfWeek: String){
        cellConfigure(numberOfDay: numberOfDay, dayOfWeek: dayOfWeek)
    }
}

// MARK: - constraints
extension CalendarCollectionViewCell {
    private func setupConstraints(){
        let constraints = [
            dayOfWeekLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            numberOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            numberOfWeekLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
