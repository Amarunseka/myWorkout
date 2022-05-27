//
//  ProfileInfoViewController.swift
//  myWorkout
//
//  Created by Миша on 07.05.2022.
//

import UIKit
import RealmSwift

class ProfileInfoViewController: UIViewController {
    
    private let profileTitleLabel = UILabel.bigGrayLabel(text: "PROFILE")
    private let userPhotoImageView = UserPhotoImageView()
    private let userNameLabel = UILabel.bigColorLabel(text: "USER", color: .white)
    private var heightAndWeightStackView = UIStackView()
    private let targetWorkoutsLabel = UILabel.midlGrayLabel(text: "TARGET: ...")
    private let completedWorkoutsCounterLabel = UILabel.bigGrayLabel(text: "2")
    private let targetWorkoutsCounterLabel = UILabel.bigGrayLabel(text: "...")
    private var completeAndTargetWorkoutsStackView = UIStackView()
    private var workoutsArray: Results<WorkoutRealmModel>!
    private var userArray: Results<UserRealmModel>!
    private var resultWorkout = [ResultWorkoutModel]()

    
    
    private var progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressTintColor = .specialGreen
        progress.trackTintColor = .specialLightBrown
        progress.layer.cornerRadius = 15
        progress.clipsToBounds = true
        progress.progress = 0.2
        return progress
    }()

    private let userPhotoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Height: ..."
        label.textColor = .specialGray
        label.font = .robotoMedium16()
        return label
    }()

    private let weightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weight: ..."
        label.textColor = .specialGray
        label.font = .robotoMedium16()
        return label
    }()
    
    // эту кнопку можно попробовать тоже вынести в отдельный файл
    private lazy var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialGreen
        button.titleLabel?.font = .robotoMedium16()
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
        
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getWorkoutsResults()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserInfo()
    }

    
    private func setupView(){
        view.backgroundColor = .specialBackground

        heightAndWeightStackView = UIStackView(
            arrangedSubviews: [heightLabel, weightLabel],
            axis: .horizontal,
            spacing: 10)
        
        completeAndTargetWorkoutsStackView = UIStackView(
            arrangedSubviews: [completedWorkoutsCounterLabel, targetWorkoutsCounterLabel],
            axis: .horizontal,
            spacing: 10)
        
        view.addSubview(profileTitleLabel)
        view.addSubview(userPhotoBackgroundView)
        view.addSubview(userPhotoImageView)
        userPhotoBackgroundView.addSubview(userNameLabel)
        view.addSubview(heightAndWeightStackView)
        view.addSubview(editingButton)
        view.addSubview(collectionView)
        view.addSubview(targetWorkoutsLabel)
        view.addSubview(completeAndTargetWorkoutsStackView)
        view.addSubview(progressBar)
    }
    
    private func setupCollectionView(){
        collectionView.register(
            ProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: ProfileCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @objc private func editingButtonTapped() {
        let vc = EditProfileViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    
    private func getUserInfo(){
        userArray = RealmManager.shared.localRealm.objects(UserRealmModel.self)
        
        if !userArray.isEmpty {
            userNameLabel.text = "\(userArray[0].userFirstName) \(userArray[0].userLastName)"
            heightLabel.text = "Height: \(userArray[0].userHeight)"
            weightLabel.text = "Weight: \(userArray[0].userWeight)"
            targetWorkoutsLabel.text = "TARGET: \(userArray[0].userTarget) workouts"
            targetWorkoutsCounterLabel.text = "\(userArray[0].userTarget)"

            guard let data =  userArray[0].userImage,
                  let image = UIImage(data: data) else {return}
            
            userPhotoImageView.image = image
        }
    }
    
    
    // получаем массив уникальных названий тренировок для передачи подсчета на профиль
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
    
    // метод создания массива упражнений для отображения
    private func getWorkoutsResults(){
        let nameArray = getWorkoutsNames()
        
        
        for name in nameArray {
            // создаем предикат, что дальше будем фильтровать только то упражнение которое сейчас name
            let predicateName = NSPredicate(format: "workoutName = '\(name)'")
            
            // фильтруем
            workoutsArray = RealmManager.shared.localRealm.objects(
                WorkoutRealmModel.self).filter(predicateName).sorted(byKeyPath: "workoutName")
            
            var result = 0
            var image: Data?
            
            workoutsArray.forEach { model in
                result += model.workoutReps
                image = model.workoutImage
            }
            let resultModel = ResultWorkoutModel(name: name, result: result, imageData: image)
            resultWorkout.append(resultModel)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension ProfileInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultWorkout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCollectionViewCell.self), for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        
        var color = UIColor()
        (indexPath.row % 4 == 0 || indexPath.row % 4 == 3) ? (color = .specialGreen) : (color = .specialDarkYellow)
        cell.configureProfileCell(color: color, model: resultWorkout[indexPath.row])
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width / 2.07,
            height: 120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item \(indexPath) selected")
    }
}




// MARK: - Constraints
extension ProfileInfoViewController {
    private func setupConstraints() {
        let constraints = [
            profileTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            userPhotoImageView.topAnchor.constraint(equalTo: profileTitleLabel.bottomAnchor, constant: 10),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            userPhotoBackgroundView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor, constant: 0),
            userPhotoBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userPhotoBackgroundView.heightAnchor.constraint(equalTo: userPhotoImageView.heightAnchor, constant: 0),
            
            userNameLabel.bottomAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: -10),
            userNameLabel.centerXAnchor.constraint(equalTo: userPhotoBackgroundView.centerXAnchor, constant: 0),
            
            heightAndWeightStackView.topAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: 5),
            heightAndWeightStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            editingButton.topAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: 2.5),
            editingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: heightAndWeightStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            
            targetWorkoutsLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 25),
            targetWorkoutsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            completeAndTargetWorkoutsStackView.topAnchor.constraint(equalTo: targetWorkoutsLabel.bottomAnchor, constant: 5),
            completeAndTargetWorkoutsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            completeAndTargetWorkoutsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            progressBar.topAnchor.constraint(equalTo: completeAndTargetWorkoutsStackView.bottomAnchor, constant: 0),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressBar.heightAnchor.constraint(equalToConstant: 30)

        ]
        NSLayoutConstraint.activate(constraints)
    }
}
