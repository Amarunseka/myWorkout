//
//  DateAndRepeat.swift
//  myWorkout
//
//  Created by Миша on 12.04.2022.
//

import UIKit

class DateAndRepeatView: UIView {
    
    // MARK: - initial elements
    private let dateLabel = UILabel.midlGrayLabel(text: "Date")
    private let repeat7DaysLabel = UILabel.midlGrayLabel(text: "Repeat every 7 days")

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US")
        datePicker.tintColor = .specialGreen
        datePicker.setValue(UIColor.red, forKey: "textColor")
        return datePicker
    }()
    
    private let repeat7DaysSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        repeatSwitch.onTintColor = .specialGreen
        repeatSwitch.thumbTintColor = .specialYellow
        repeatSwitch.isOn = true
        return repeatSwitch
    }()
    
    private lazy var dateStackView = UIStackView(
        arrangedSubviews: [dateLabel, datePicker],
        axis: .horizontal,
        spacing: 10)
    
    private lazy var repeatStackView = UIStackView(
        arrangedSubviews: [repeat7DaysLabel, repeat7DaysSwitch],
        axis: .horizontal,
        spacing: 10)

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
        
        // поменять у дэйтпикера фон можно только так
        datePicker.subviews[0].subviews[0].subviews[0].alpha = 0
        
        // методы растягивания по краям stackView
        dateStackView.distribution = .equalSpacing
        repeatStackView.distribution = .equalSpacing

        addSubview(dateStackView)
        addSubview(repeatStackView)
    }
    
    // приватный метод для получения даты и положения свитча для последующей передачи в модель
    private func getDateAndRepeat() -> (Date, Bool) {
        (datePicker.date, repeat7DaysSwitch.isOn)
    }
    
    // приватный метод передачи сброса настроек при сохранении
    private func resetToDefaultSettings(){
        //сбрасываем DatePIcker на текущую дату
        datePicker.setDate(Date(), animated: true)
        repeat7DaysSwitch.isOn = true
    }
    
    // метод запуска приватного метода выше на NewWorkoutVC
    func setDateAndRepeat() -> (Date, Bool) {
        getDateAndRepeat()
    }
    
    // метод передачи сброса настроек при сохранении
    func setDefaultSettings() {
        resetToDefaultSettings()
    }
}

// MARK: - Constraints
extension DateAndRepeatView {
    private func setupConstraints() {
        let constraints = [
            dateStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            repeatStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10),
            repeatStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repeatStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
