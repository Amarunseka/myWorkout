//
//  NewWorkoutViewController.swift
//  myWorkout
//
//  Created by Миша on 12.04.2022.
//

import UIKit

// СДЕЛАТЬ ВОЗМОЖНОСТЬ УВЕЛИЧЕНИЯ КОЛИЧЕСТВА ПОВТОРОВ И ПОВТОРЕНИЙ
class NewWorkoutViewController: UIViewController {

    // MARK: - initialise elements
    private let newWorkoutLabel = UILabel.bigGrayLabel(text: "NEW WORKOUT")
    private let exerciseNameLabel = UILabel.smallBrownLabel(text: "Exercise name")
    private let dateAndRepeatLabel = UILabel.smallBrownLabel(text: "Date and repeat")
    private let repsOrTimerLabel = UILabel.smallBrownLabel(text: "Reps or timer")
    
    private let dateAndRepeatView = DateAndRepeatView()
    private let repsOrTimerView = RepsOrTimerView()
    private var workoutModel = WorkoutRealmModel()
    private let testImage = UIImage(named: "bicepsImage")
    
    private lazy var closeButton = CloseButton(viewController: self)
    private lazy var saveButton = SaveButton(text: "SAVE") { [weak self] in
        self?.saveButtonTapped()
    }
    
    // !!! ВЫНЕСТИ В ОТДЕЛЬНЫЙ ФАЙЛ И ИСПОЛЬЗОВАТЬ В АЛЕРТАХ и в поиске в статитстиике
    private let nameTextField = SpecialTextField()

    // MARK: - live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDelegates()
        addTaps()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - methods-actions
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(newWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(exerciseNameLabel)
        view.addSubview(nameTextField)
        view.addSubview(dateAndRepeatLabel)
        view.addSubview(dateAndRepeatView)
        view.addSubview(repsOrTimerLabel)
        view.addSubview(repsOrTimerView)
        view.addSubview(saveButton)
    }
    
    private func setDelegates(){
        nameTextField.delegate = self
    }
    
    private func saveButtonTapped(){
        setModel()
        saveModel()
    }
    
    // метод создания модели для сохранения
    private func setModel() {
        // проверяем заполнили ли текстфилд с именем
        guard let nameWorkout = nameTextField.text else {return}
        // передаем имя в модель
        workoutModel.workoutName = nameWorkout
        
        // создаем переменную для передачи даты и дня недели в модель
        let dateFromPicker = dateAndRepeatView.setDateAndRepeat().0 // таким образом передаем нужный нам возвращаемый параметр из метода
        // передаем дату в модель
        workoutModel.workoutDate = dateFromPicker.localDate()
        // передаем день недели в модель
        workoutModel.workoutNumberOfWeekday = dateFromPicker.getWeekdayNumber()
        
        // передаем положение переключателя репита в модель
        workoutModel.workoutRepeat = dateAndRepeatView.setDateAndRepeat().1
        
        // передаем остальные данные в модель
        workoutModel.workoutSets = repsOrTimerView.setSliderValue().0
        workoutModel.workoutReps = repsOrTimerView.setSliderValue().1
        workoutModel.workoutTimer = repsOrTimerView.setSliderValue().2

        // пробуем получить изображение
        guard let imageData = testImage?.pngData() else {return}
        // и если получили передаем его в модель
        workoutModel.workoutImage = imageData
    }
    
    private func saveModel(){
        guard let text = nameTextField.text else {return}
        // проверяем сколько у нас цифр и букв в тексте, и присваиваем их колличество
        let count = text.filter { $0.isNumber || $0.isLetter}.count
        
        if count != 0 &&
            workoutModel.workoutSets != 0 &&
            (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            
            RealmManager.shared.saveWorkoutModel(model: workoutModel)
            // создаем нотификацию для данного упражнения
            createNotification()
            // это нам нужно делать, что бы наша модель стразу синхронизировалась, а то будет ошибка
            workoutModel = WorkoutRealmModel()
            
            simpleNoticeAlert(title: "Success", message: nil)
            
            // сбрасываем настройки
            nameTextField.text = ""
            dateAndRepeatView.setDefaultSettings()
            repsOrTimerView.setDefaultSettings()
        } else {
            simpleNoticeAlert(title: "Error", message: "All fields must be filled")
        }
    }
    
    
    // жесты на закрытие клавиатуры
    private func addTaps(){
        
        // прячем клавиатуру при нажатии на любое место экрана
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyboard))
        view.addGestureRecognizer(tapScreen)
        
        // прячем клавиатуру при перемещении слайдеров
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(swipeHideKeyboard))
        // это нужно чтобы отменялись жесты на прикосновения и распознавались свайпы
        swipeScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeScreen)
    }
    
    @objc
    private func tapHideKeyboard(){
        view.endEditing(true)
    }
    
    @objc
    private func swipeHideKeyboard(){
        view.endEditing(true)
    }
    
    private func createNotification(){
        let notifications = Notifications()
        let stringDate = workoutModel.workoutDate.ddMMyyyyFromDate()
        notifications.scheduleDateNotification(date: workoutModel.workoutDate, id: "workout \(stringDate)")
    }
}


// MARK: - UITextFieldDelegate
extension NewWorkoutViewController: UITextFieldDelegate {
    
    
    // убирание клавиатуры при нажатии enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
}

// MARK: - Constraints
extension NewWorkoutViewController {
    private func setupConstraints() {
        let constraints = [
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            closeButton.centerYAnchor.constraint(equalTo: newWorkoutLabel.centerYAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            
            exerciseNameLabel.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 10),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 3),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 38),
            
            dateAndRepeatLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dateAndRepeatLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            dateAndRepeatView.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 0),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 100),
            
            repsOrTimerLabel.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 20),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            repsOrTimerView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 0),
            repsOrTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repsOrTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 300),
            
            saveButton.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

