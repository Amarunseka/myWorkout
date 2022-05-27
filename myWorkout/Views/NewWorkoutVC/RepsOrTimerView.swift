//
//  RepsOrTimer.swift
//  myWorkout
//
//  Created by Миша on 12.04.2022.
//

import UIKit

class RepsOrTimerView: UIView {
    
    // MARK: - initial elements
    private let setsLabel = UILabel.midlGrayLabel(text: "Sets")
    private let numberOfSetsLabel = UILabel.bigGrayLabel(text: "0")
    private let repsLabel = UILabel.midlGrayLabel(text: "Reps")
    private let numberOfRepsLabel = UILabel.bigGrayLabel(text: "0")
    private let timerLabel = UILabel.midlGrayLabel(text: "Timer")
    private let numberOfTimerLabel = UILabel.bigGrayLabel(text: "0 min 00 sec")
    private let chooseRepeatOrTimerLabel = UILabel.smallBrownLabel(text: "Choose repeat or timer")
    
    private lazy var setsStackView = UIStackView(
        arrangedSubviews: [setsLabel, numberOfSetsLabel],
        axis: .horizontal,
        spacing: 10)
    
    private lazy var repsStackView = UIStackView(
        arrangedSubviews: [repsLabel, numberOfRepsLabel],
        axis: .horizontal,
        spacing: 10)
    
    private lazy var timerStackView = UIStackView(
        arrangedSubviews: [timerLabel, numberOfTimerLabel],
        axis: .horizontal,
        spacing: 10)
    
    private lazy var setsSlider = SpecialSlider(maximumValue: 10) { [weak self] in
        self?.changeValueSetsSlider()
    }
    private lazy var repsSlider = SpecialSlider(maximumValue: 20) { [weak self] in
        self?.changeValueRepsSlider()
    }
    private lazy var timerSlider = SpecialSlider(maximumValue: 600) { [weak self] in
        self?.changeValueTimerSlider()
    }
    
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
        
        // методы растягивания по краям stackView
        setsStackView.distribution = .equalSpacing
        repsStackView.distribution = .equalSpacing
        timerStackView.distribution = .equalSpacing
        
        initialTimerSettings()
        
        addSubview(setsStackView)
        addSubview(setsSlider)
        addSubview(chooseRepeatOrTimerLabel)
        addSubview(repsStackView)
        addSubview(repsSlider)
        addSubview(timerStackView)
        addSubview(timerSlider)
    }
    
    private func initialTimerSettings(){
        timerSlider.alpha = 0.5
        timerLabel.alpha = 0.5
        numberOfTimerLabel.alpha = 0.5
    }
    
    private func changeValueSetsSlider(){
        numberOfSetsLabel.text = "\(Int(setsSlider.value))"
    }
    
    private func changeValueRepsSlider(){
        numberOfRepsLabel.text = "\(Int(repsSlider.value))"
        setNegative(label: timerLabel, numberLabel: numberOfTimerLabel, slider: timerSlider, text: "0 min 00 sec")
        setActive(label: repsLabel, numberLabel: numberOfRepsLabel, slider: repsSlider)
    }
    
    private func changeValueTimerSlider(){
        // ПЕРЕВЕСТИ ЛОГИКУ В ОТДЕЛЬНУЮ МОДЕЛЬ

        let (min, sec) = Int(timerSlider.value).convertSeconds()
        let sec00 = sec.setZeroForSecond()
        var text = ""

        if min == 0 && sec == 0{
            text = "0 min 00 sec"
        } else if min == 0 {
            text = ("\(sec00) sec")
        } else if sec == 0 {
            text = ("\(min) min ")
        } else {
            text = ("\(min) min \(sec00) sec")
        }
        numberOfTimerLabel.text = text
        
        setNegative(label: repsLabel, numberLabel: numberOfRepsLabel, slider: repsSlider, text: "0")
        setActive(label: timerLabel, numberLabel: numberOfTimerLabel, slider: timerSlider)
    }
    
    // метод установки неактивным ненужный вариант отслеживания упражнения
    private func setNegative(label: UILabel, numberLabel: UILabel, slider: UISlider, text: String){
        label.alpha = 0.5
        numberLabel.alpha = 0.5
        numberLabel.text = text
        slider.alpha = 0.5
        slider.value = 0
    }
    
    // метод установки активным нужный вариант отслеживания упражнения
    private func setActive(label: UILabel, numberLabel: UILabel, slider: UISlider){
        label.alpha = 1
        numberLabel.alpha = 1
        slider.alpha = 1
    }
    
    // метод получения данных слайдеров для сохранения в модели
    private func getSliderValue() -> (Int, Int, Int) {
        let setsSliderValue = Int(setsSlider.value)
        let repsSliderValue = Int(repsSlider.value)
        let timerSliderValue = Int(timerSlider.value)
        return (setsSliderValue, repsSliderValue, timerSliderValue)
    }
    
    // приватный метод передачи сброса настроек при сохранении
    private func resetToDefaultSettings() {
        setsSlider.value = 0
        repsSlider.value = 0
        timerSlider.value = 0
        changeValueSetsSlider()
        changeValueTimerSlider()
        changeValueRepsSlider()
    }

    
    // публичный метод передачи данных в модель
    func setSliderValue() -> (Int, Int, Int) {
        getSliderValue()
    }
    
    // публичный метод передачи сброса настроек при сохранении
    func setDefaultSettings() {
        resetToDefaultSettings()
    }
}

// MARK: - Constraints
extension RepsOrTimerView {
    private func setupConstraints() {
        let constraints = [
            setsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            setsSlider.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 5),
            setsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            setsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            chooseRepeatOrTimerLabel.topAnchor.constraint(equalTo: setsSlider.bottomAnchor, constant: 25),
            chooseRepeatOrTimerLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            repsStackView.topAnchor.constraint(equalTo: chooseRepeatOrTimerLabel.bottomAnchor, constant: 5),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            repsSlider.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 5),
            repsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            timerStackView.topAnchor.constraint(equalTo: repsSlider.bottomAnchor, constant: 15),
            timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            timerSlider.topAnchor.constraint(equalTo: timerStackView.bottomAnchor, constant: 5),
            timerSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timerSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

/*
private func changeValueTimerSlider(_ sender: UISlider){
    let format = String(format: "%.2f", sender.value)
    let min = Int(sender.value)
    var sec = format.dropFirst(2).description

    sender.value < 10 ? (sec = format.dropFirst(2).description) : (sec = format.dropFirst(3).description)
    
    guard let sec = Double(sec) else {return}
    
    let sixtySec = Int(sec * 0.6)
    var text = ""
    
    if min == 0 {
        text = ("\(sixtySec) sec")
    } else if sixtySec == 0 {
        text = ("\(min) min ")
    } else {
        text = ("\(min) min \(sixtySec) sec")
    }
    timerCounterLabel.text = text
}
 
 
 
 // кортеж вычисления минут секунд
 
 let (min, sec) = { (secs: Int) -> (Int, Int) in
     return (secs / 60, secs % 60)
 }(Int(timerSlider.value)) // после фигурных скобок это мы как бы сразу запускам наше замыкание
 
 */
