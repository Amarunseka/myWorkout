//
//  EditProfileViewController.swift
//  myWorkout
//
//  Created by Миша on 13.05.2022.
//

import UIKit
import RealmSwift

class EditProfileViewController: BasicViewController {
    
    // MARK: - initial elements
    private let userPhotoImageView = UserPhotoImageView()
    private let headersForCellsNameArray = ["First name", "Last name", "Height", "Weight", "Target"]
    private lazy var textFromRowsArray = ["", "", "0", "0", "0"]
    private var userArray: Results<UserRealmModel>!
    private var userModel = UserRealmModel()

    private let userPhotoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var saveButton = SaveButton(text: "SAVE") {
        self.saveButtonTapp()
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delaysContentTouches = false
        return tableView
    }()

    
    // MARK: - life cycle
    init(){
        super.init(titleText: "EDITING PROFILE", closeButtonIsHidden: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
        userArray = RealmManager.shared.localRealm.objects(UserRealmModel.self)
        loadUserInfo()
        tapOnUserPhotoGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    
    // MARK: - methods-actions
    private func setupView() {
        view.addSubview(userPhotoBackgroundView)
        view.addSubview(userPhotoImageView)
        view.addSubview(saveButton)
        view.addSubview(tableView)
    }
    
    private func setupTableView(){
        tableView.backgroundColor = .clear
        tableView.register(
            EditProfileTableViewCell.self,
            forCellReuseIdentifier: String(describing: EditProfileTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    private func loadUserInfo(){
        if !userArray.isEmpty {
            textFromRowsArray[0] = userArray[0].userFirstName
            textFromRowsArray[1] = userArray[0].userLastName
            textFromRowsArray[2] = "\(userArray[0].userHeight)"
            textFromRowsArray[3] = "\(userArray[0].userWeight)"
            textFromRowsArray[4] = "\(userArray[0].userTarget)"

            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data) else {return}
            userPhotoImageView.image = image
        }
    }
    
    
    
    private func setUserModel(){
        // здесь нам нужно получить данные из текстфилдов полей
        // можно попробовать реактивщину

        // получаем данные из текстфилдов
        for section in 0..<headersForCellsNameArray.count {
            guard let cell = tableView.cellForRow(at: [section,0]) as? EditProfileTableViewCell,
                  let text = cell.textField.text else {return}
            textFromRowsArray[section] = text
        }

        // преобразуем нужные данные из строки в Int
        guard let height = Int(textFromRowsArray[2]),
              let weight = Int(textFromRowsArray[3]),
              let target = Int(textFromRowsArray[4]) else {return}
        
        // записываем данные во временную модель
        userModel.userFirstName = textFromRowsArray[0]
        userModel.userLastName = textFromRowsArray[1]
        userModel.userHeight = height
        userModel.userWeight = weight
        userModel.userTarget = target
        
        // пробуем получить фотографию
        if userPhotoImageView == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
            guard let data = userPhotoImageView.image?.pngData() else {return}
            userModel.userImage = data
        }
        
        // РАЗБИТЬ ЭТОТ МЕТОД НА БОЛЕЕ МЕЛКИЕ
    }
 
    private func saveButtonTapp(){
        setUserModel()
        // так как у нас всего одни пользователь, то если мы еще не записывали, то массив будет пустой, и мы сохраняем нашу модель
        if userArray.isEmpty {
            RealmManager.shared.saveUserModel(model: userModel)
        } else {
            // а если мы уже сохранили нашего пользователя то тогда обновляем модель
            RealmManager.shared.updateUserModel(model: userModel)
        }
        // перезаписываем, что бы не было ошибки
        userModel = UserRealmModel()
        self.dismiss(animated: true)
    }

    
    private func tapOnUserPhotoGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        userPhotoImageView.isUserInteractionEnabled = true
        userPhotoImageView.addGestureRecognizer(gesture)
    }
    
    @objc private func setUserPhoto(){
        imagePickerAlert { [weak self] source in
            self?.openImagePicker(source: source)
        }
    }
}
// MARK: - UITableViewDataSource
extension EditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        headersForCellsNameArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditProfileTableViewCell.self),
                                                       for: indexPath) as? EditProfileTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textField.text = textFromRowsArray[indexPath.section]

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headersForCellsNameArray[section]
    }
}


// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightOfAllSubjects = titleLabel.frame.height
                                    + userPhotoImageView.frame.height
                                    + userPhotoBackgroundView.frame.height
                                    + saveButton.frame.height
        let countOfAllIndents: CGFloat = 50
        let countOfRowsAndHeaders = CGFloat(headersForCellsNameArray.count * 3)
        
        return ((view.frame.height - (heightOfAllSubjects + countOfAllIndents)) / countOfRowsAndHeaders)
    }
}


// MARK: - Setup ImagePicker
// нужны одновременно два протокола потому что делегат пикера требует их обоих
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // создаем собственные метод открытия ImagePicker
    func openImagePicker(source: UIImagePickerController.SourceType) {
        
        // если ресурс (камера или галерея) существует
        if UIImagePickerController.isSourceTypeAvailable(source) {
            // создаем пикер
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            // разрешаем редактировать фото
            imagePicker.allowsEditing = true
            // показываем пикер
            present(imagePicker, animated: true)
        }
    }
    
    // этот метод срабатывает когда мы нажимаем закрыть пикер
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // получаем изображение из пикера
        let image = info[.editedImage] as? UIImage
        
        // присваиваем нашему пользователю
        userPhotoImageView.image = image
        dismiss(animated: true)
    }
}


// MARK: - Constraints
extension EditProfileViewController {
    private func setupConstraints(){
        let constraints = [
            userPhotoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            userPhotoBackgroundView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor, constant: 0),
            userPhotoBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            userPhotoBackgroundView.heightAnchor.constraint(equalTo: userPhotoImageView.heightAnchor, constant: -30),
            
            tableView.topAnchor.constraint(equalTo: userPhotoBackgroundView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
