//
//  ViewController.swift
//  myWorkout
//
//  Created by Миша on 04.04.2022.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController {

    // MARK: - initialise elements
    private let userNameLabel = UILabel.bigGrayLabel(text: "Amarunseka")
    private let userPhotoImageView = UserPhotoImageView()
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    private let workoutTodayLabel = UILabel.midlGrayLabel(text: "Workout today:")
    private var workoutDate = Date().localDate()
    private var workoutsArray: Results<WorkoutRealmModel>!
    private var userArray: Results<UserRealmModel>!
    
    private lazy var addWorkoutButton = AddWorkoutButton { [weak self] in
        self?.addWorkoutButtonTapped()
    }
    
    
    private let noWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "noTraining")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
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
        getUserInfo()
        getWorkouts(date: workoutDate)
        tableView.reloadData()
    }

    
    // MARK: - methods-actions
    private func setupViews() {
        view.backgroundColor = .specialBackground
        weatherView.addShadowOnView()
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: String(describing: WorkoutTableViewCell.self))
        // add Subviews
        view.addSubview(calendarView)
        view.addSubview(userPhotoImageView)
        view.addSubview(noWorkoutImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
    }
    
    private func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        
        calendarView.selectCollectionViewItem = { [weak self] date in
            guard let self = self else {return}
            self.workoutDate = date
            self.getWorkouts(date: self.workoutDate)
        }
        
        // ЗАМЕНИЛ НА ЗАМЫКАНИЕ!!!!!!!
        //        calendarView.calendarCollectionViewDelegate = self
    }
    
    private func addWorkoutButtonTapped(){
        let vc = NewWorkoutViewController()
        // режим появления перехода
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    private func goToStartWorkoutVC(vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    private func getUserInfo(){
        userArray = RealmManager.shared.localRealm.objects(UserRealmModel.self)

        if !userArray.isEmpty {
            userNameLabel.text = "\(userArray[0].userFirstName) \(userArray[0].userLastName)"
            
            guard let data  = userArray[0].userImage,
                  let image = UIImage(data: data) else {return}
            userPhotoImageView.image = image
        }
        
    }
    
    // получение данных из модели
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekdayNumber()
        let dateStart = date.startEndDate().0
        let dateEnd = date.startEndDate().1
        
        // предикат - что номер дня недели тренировки равен дню недели даты, и повторение включено
        let repeatPredicate = NSPredicate(format: "workoutNumberOfWeekday = \(weekday) AND workoutRepeat = true")
        
        // предикат - что тренировка не повторяется но назначенная попадает в дату начала и конца
        let notRepeatPredicate = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        
        // объединяем наши предикаты, делая сложный предикат
        let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: [repeatPredicate, notRepeatPredicate])
        
        // получаем данные из модели фильтруя их и сортируя по имени
        workoutsArray = RealmManager.shared.localRealm.objects(WorkoutRealmModel.self).filter(compoundPredicate).sorted(byKeyPath: "workoutName")
        
        checkWorkoutToday()
        tableView.reloadData()
    }
    
    private func checkWorkoutToday() {
        if workoutsArray.count == 0 {
            noWorkoutImageView.isHidden = false
            tableView.isHidden = true
        } else {
            noWorkoutImageView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func startButtonTapped(model: WorkoutRealmModel) {
        var vc = UIViewController()
        
        if model.workoutTimer == 0 {
            vc = RepsWorkoutViewController(workoutModel: model)
        } else {
            vc = TimerWorkoutViewController(workoutModel: model)
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// ЗАМЕНИЛ НА ЗАМЫКАНИЕ!!!!!!!
//// MARK: - SelectCalendarCollectionViewItemProtocol
//extension MainViewController: SelectCalendarCollectionViewItemProtocol {
//    func selectItem(date: Date) {
//        print(date)
//    }
//}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (workoutsArray != nil) ? workoutsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutTableViewCell.self),
                                                       for: indexPath) as? WorkoutTableViewCell else { return UITableViewCell()}
        let model = workoutsArray[indexPath.row]
        cell.workoutCellConfigure(model: model)
        
        
        cell.tapStartButton = { [weak self] workoutModel in
            guard let self = self else {return}
            
            self.startButtonTapped(model: workoutModel)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    // метод при свайпе йчейки, в данном случае удаление
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, _ in
            guard let self = self else {return}
            let deleteModel = self.workoutsArray[indexPath.row]
            RealmManager.shared.deleteWorkoutModel(model: deleteModel)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Constraints
extension MainViewController {
    private func setupConstraints() {
        let constraints = [
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),

            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.topAnchor.constraint(equalTo: addWorkoutButton.topAnchor, constant: 0),
            weatherView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: 0),
            weatherView.heightAnchor.constraint(equalTo: addWorkoutButton.heightAnchor, constant: 0),
            
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 15),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: addWorkoutButton.leadingAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            noWorkoutImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            noWorkoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noWorkoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noWorkoutImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}



