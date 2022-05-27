//
//  StatisticViewController.swift
//  myWorkout
//
//  Created by Миша on 07.04.2022.
//

import UIKit
import RealmSwift

// !!!! СДЕЛАТЬ КОРРЕКТНОЕ ОТОБРАЖЕНИЕ ДЛЯ ТАЙМЕРА
class StatisticViewController: UIViewController {

    // MARK: - initialise elements
    private let statisticTitleLabel = UILabel.bigGrayLabel(text: "STATISTICS")
    private let exercisesNameTableViewLabel = UILabel.smallBrownLabel(text: "Exercises:")
    private var workoutsArray: Results<WorkoutRealmModel>!
    private var differenceWorkoutsArray = [DifferenceWorkout]()
    private var filteredArray = [DifferenceWorkout]()
    private let finderTextField = SpecialTextField()

    private var isFiltered = false

    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Weak", "Month"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        segmentedControl.setTitleTextAttributes([.font: UIFont.robotoMedium16() as Any,
                                                 .foregroundColor: UIColor.specialBackground],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([.font: UIFont.robotoMedium16() as Any,
                                                 .foregroundColor: UIColor.specialDarkGreen],
                                                for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        return segmentedControl
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .none
        tableView.separatorStyle = .singleLine
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    
    // MARK: - live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        differenceWorkoutsArray = [DifferenceWorkout]()
        setStartScreen()
    }
    
    // MARK: - methods-actions
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        tableView.register(
            StatisticsTableViewCell.self,
            forCellReuseIdentifier: String(describing: StatisticsTableViewCell.self))
        // add Subviews
        view.addSubview(statisticTitleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(exercisesNameTableViewLabel)
        view.addSubview(tableView)
        view.addSubview(finderTextField)
        
        finderTextField.becomeFirstResponder()
    }
    
    private func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        finderTextField.delegate = self
    }
    
    @objc
    private func segmentedChange(){
        var dateStart = Date()
        differenceWorkoutsArray = [DifferenceWorkout]()

        if segmentedControl.selectedSegmentIndex == 0 {
            dateStart = Date().localDate().offsetDays(days: 7)
//            let dateStart = dateToday.offsetDays(days: 7)
//            getDifferenceWorkoutModel(dateStart: dateStart)
        } else {
            dateStart = Date().localDate().offsetMonths(month: 1)
//            let dateStart = dateToday.offsetMonths(month: 1)
//            getDifferenceWorkoutModel(dateStart: dateStart)
        }
        getDifferenceWorkoutModel(dateStart: dateStart)
        tableView.reloadData()
    }
    
    // получаем массив уникальных названий тренировок
    private func getWorkoutsNames() -> [String] {
        var nameArray = [String]()
        workoutsArray = RealmManager.shared.localRealm.objects(WorkoutRealmModel.self)
        
        for workoutModel in workoutsArray {
            // если массив еще не содержит имя тренировки то добавляем
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceWorkoutModel(dateStart: Date) {
        let dateEnd = Date().localDate()
        
        // получаем массив уникальных названий
        let workoutNamesArray = getWorkoutsNames()
        // далее с каждым именем производим действия
        for name in workoutNamesArray {
            // создаем предикат что наша тренировка между двумя датами
            let differencePredicate = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])


            // фильтруем сортируем
            workoutsArray = RealmManager.shared.localRealm.objects(WorkoutRealmModel.self).filter(differencePredicate).sorted(byKeyPath: "workoutDate")
            // получаем первый и последний результат
            guard let previousReps = workoutsArray.first?.workoutReps,
                  let currentReps = workoutsArray.last?.workoutReps,
                  let previousTimer = workoutsArray.first?.workoutTimer,
                  let currentTimer = workoutsArray.last?.workoutTimer else {return}
            // добавляем результат в модель
            let differenceWorkout = DifferenceWorkout(name: name,
                                                      previousReps: previousReps,
                                                      currentReps: currentReps,
                                                      previousTimer: previousTimer,
                                                      currentTimer: currentTimer)
            differenceWorkoutsArray.append(differenceWorkout)
        }
    }
    
    // метод первоначально загрузки данных при открытии экрана
    private func setStartScreen() {
        let dateToday = Date().localDate()
        getDifferenceWorkoutModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? filteredArray.count : differenceWorkoutsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatisticsTableViewCell.self),
                                                       for: indexPath) as? StatisticsTableViewCell else { return UITableViewCell()}
        cell.separatorInset.left = 0
        let differenceModel = isFiltered ? filteredArray[indexPath.row] : differenceWorkoutsArray[indexPath.row]
        cell.statisticCellConfigure(differenceWorkout: differenceModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}

//MARK: - UITextFieldDelegate & finder setup

extension StatisticViewController: UITextFieldDelegate {
    
    // метод фильтрации для поиска
    private func filteringWorkouts(text: String) {
        for workout in differenceWorkoutsArray {
            if workout.name.lowercased().contains(text.lowercased()) {
                filteredArray.append(workout)
            }
        }
    }
    
    // метод отрабатывает когда вводим данные в текстфилд
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // тк метод не учитывает текущий введенный символ нам нужно создать диапазон вручную
        // печатать просто textField.text, то один символ будет пропадать
        if let text = textField.text,
           // поэтому мы получаем диапазон из textField.text
           let textRange = Range(range, in: text) {
            // а дальше наоборот из диапазона получаем текст
            // ПРОСТОЙ ВАРИАНТ ЭТО: textField.text + string (ну только textField.text нужно сначала разанрапить), но не совсем тогда при удалении будет проблемы при первом удалении, и последнем
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            // обнуляем наш массив, чтобы не добавлялось лишнего
            filteredArray = [DifferenceWorkout]()
            
            isFiltered = updatedText.count > 0
            filteringWorkouts(text: updatedText)
            tableView.reloadData()
        }
        return true
    }

    // метод когда нажимаем на крестик удаления
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isFiltered = false
        filteredArray = [DifferenceWorkout]()
        segmentedChange()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


// MARK: - Constraints
extension StatisticViewController {
    private func setupConstraints() {
        let constraints = [
            statisticTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            statisticTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            segmentedControl.topAnchor.constraint(equalTo: statisticTitleLabel.bottomAnchor, constant: 30),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            finderTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            finderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finderTextField.heightAnchor.constraint(equalToConstant: 34),

            
            exercisesNameTableViewLabel.topAnchor.constraint(equalTo: finderTextField.bottomAnchor, constant: 15),
            exercisesNameTableViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesNameTableViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: exercisesNameTableViewLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
