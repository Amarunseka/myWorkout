//
//  TimerWorkoutViewController.swift
//  myWorkout
//
//  Created by Миша on 05.05.2022.
//

import UIKit

// ПЕРЕДЕЛАТЬ ЛАЙОУТ
// СДЕЛАТЬ TimerVC И RepsVC  ОДНИМ VC С ВЫБОРОМ ВАРИАНТА
// ИЗМЕНИТЬ ВО ВСЕХ ОТОБРАЖЕНИЯХ ТАЙМЕРА ЧТО ЕСЛИ 0 МИНУТ ТО ОТОБРАЖАЮТСЯ ТОЛЬКО СЕКУНДЫ, МОЖНО СДЕЛАТЬ ИЛИ РАСШИРЕНИЕМ ИЛИ ОТДЕЛЬНЫМ ФАЙЛОМ
class TimerWorkoutViewController: UIViewController {
    
    private let newWorkoutLabel: UILabel = {
       let label = UILabel()
        label.text = "START WORKOUT"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var  closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let ellipseImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
       let label = UILabel()
        label.textColor = .specialGray
        label.font = .robotoBold48()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("FINISH", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .robotoBold16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let timerWorkoutParametersView = TimerWorkoutParametersView()

    private let detailsLabel = UILabel.smallBrownLabel(text: "Details")
    
    private var workoutModel: WorkoutRealmModel
    private let customAlert = EditingExerciseAlert()
    
    private var durationTimerForLabel: CGFloat = 0
    private lazy var durationTimerForAnimation: CGFloat = 1
    private lazy var currentStateTimerForAnimation: CGFloat = 1

    private var numberOfSet = 0
    private var timerIsActive = false
    
    // свойство для заполнения кружка таймера
    private var shapeLayer = CAShapeLayer()
    private var timer = Timer()

    init(workoutModel: WorkoutRealmModel) {
        self.workoutModel = workoutModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
        tapStartPauseTimer()
        setWorkoutParameters()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        animationCircular()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    
    private func setDelegates() {
        timerWorkoutParametersView.cellNextSetTimerDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(newWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(ellipseImageView)
        view.addSubview(timerLabel)
        view.addSubview(detailsLabel)
        view.addSubview(timerWorkoutParametersView)
        view.addSubview(finishButton)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            okCancelAlert(title: "Warning", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    // жест для нажатия на таймер
    private func tapStartPauseTimer() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startPauseTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startPauseTimer() {
        if !timerIsActive {
            // если таймер работает кнопки не работают
            timerWorkoutParametersView.editingButton.isEnabled = false
            timerWorkoutParametersView.nextSetsButton.isEnabled = false
            finishButton.isEnabled = false
            
            
            // если количество повтором уже выполнено то показываем уведомление
            if numberOfSet == workoutModel.workoutSets {
                simpleNoticeAlert(title: "Enough", message: "You finished your workout")
            } else {
                // если нет запускаем таймер
                basicAnimation()
                timer = Timer.scheduledTimer(timeInterval: 0.01,
                                             target: self,
                                             selector: #selector(timerAction),
                                             userInfo: nil,
                                             repeats: true)
            }
            timerIsActive = true
        } else {
            shapeLayer.removeAllAnimations()
            timer.invalidate()
            durationTimerForAnimation = currentStateTimerForAnimation
            animationCircular()
            timerIsActive = false
        }
    }
    
    @objc private func timerAction() {

        if durationTimerForLabel > 0.011 {
            durationTimerForLabel -= 0.01
            currentStateTimerForAnimation = durationTimerForLabel / CGFloat(workoutModel.workoutTimer)

            // обновление лейбла таймера
            let (min, sec) = Int(durationTimerForLabel).convertSeconds()
            timerLabel.text = "\(min):\(sec.setZeroForSecond())"

        } else {
            timer.invalidate()
            // !!! ПРИ ЗАВЕРШЕНИИ ТАЙМЕРА НУЖНО ПОМЕНЯТЬ ЕГО ЛЕЙБЛ НА FINISHED
            // !!! СЕТЫ НУЖНО НАЧИНАТЬ НЕ С 0, А С 1
            // !!! ТАЙМЕР НУЖНО ПРИВОДИТЬ В НАЧАЛЬНОЕ СОСТОЯНИЕ КОГДА ПЕРЕКЛЮЧАЕМ ПОВТОРЫ и все что ниже

            durationTimerForLabel = CGFloat(workoutModel.workoutTimer)
            durationTimerForAnimation = 1
            
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"

            timerWorkoutParametersView.editingButton.isEnabled = true
            timerWorkoutParametersView.nextSetsButton.isEnabled = true
            finishButton.isEnabled = true
            timerIsActive = false
        }
    }

    // метод присвоения названий лейблам
    private func setWorkoutParameters() {
        timerWorkoutParametersView.workoutNameLabel.text = workoutModel.workoutName
        timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        
        let(min, sec) = workoutModel.workoutTimer.convertSeconds()
        let sec00 = sec.setZeroForSecond()
        timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec00) sec"
        
        timerLabel.text = "\(min):\(sec00)"
        durationTimerForLabel = CGFloat(workoutModel.workoutTimer)
    }
}

//MARK: - NextSetTimerProtocol

extension TimerWorkoutViewController: NextSetTimerProtocol {
    
    func nextSetTimerTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            simpleNoticeAlert(title: "Error", message: "Finish your workout")
        }
    }
    
    func editingTimerTapped() {
        // ВСТАВИТЬ ЗАЩИТУ ОТ КОПИРОВАНИЯ
        customAlert.alertCustom(viewController: self,
                                repsOrTimer: "Timer of set") { [self] sets, timerOfSet in
            // НАСТРОИТЬ БОЛЕЕ УДОБНОЕ ВВЕДЕНИЕ ВРЕМЕНИ ТАЙМЕРА МИНУТ И СЕКУНД
            if sets != "" && timerOfSet != "" {
                guard let numberOfSets = Int(sets) else { return }
                guard let numberOfTimer = Int(timerOfSet) else { return }
                
                let (min, sec) = numberOfTimer.convertSeconds()
                let sec00 = sec.setZeroForSecond()
                timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(sets)"
                timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec00) sec"
                timerLabel.text = "\(min):\(sec00)"
                durationTimerForLabel = CGFloat(numberOfTimer)
                RealmManager.shared.updateSetsTimerWorkoutModel(
                    model: workoutModel,
                    sets: numberOfSets,
                    timer: numberOfTimer)
            }
        }
    }
}

//MARK: - Circle animation
extension TimerWorkoutViewController {
    // !!! РАЗОБРАТЬСЯ КАК СДЕЛАТЬ ОБРАТНЫЙ ТАЙМЕР
    // это не анимация, а как бы создание как должен выглядеть кружок
    private func animationCircular() {
        let lineWidth: CGFloat = 20
        
        // свойства для высчитывания анимации заполнения
        let center = CGPoint(x: ellipseImageView.frame.width / 2,
                             y: ellipseImageView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: (ellipseImageView.frame.width - lineWidth) / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        
        // путь движения полоски
        shapeLayer.path = circularPath.cgPath
        // ширина линии (адаптировать)
        shapeLayer.lineWidth = lineWidth + 1
        // цвет подложки
        shapeLayer.fillColor = UIColor.clear.cgColor
        // направление от начала к концу и наоборот
        shapeLayer.strokeEnd = durationTimerForAnimation
        // закругление концов полоски заполнения
        shapeLayer.lineCap = .round
        // цвет полоски
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        // добавляем подслой
        ellipseImageView.layer.addSublayer(shapeLayer)
    }
    
    // метод запуска анимации
    private func basicAnimation() {
        // метод анимации от начальной точки до конечной
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        // длительность с которой будет происходить анимация
        basicAnimation.duration = CFTimeInterval(durationTimerForLabel)
        // то что анимация идет вперед
        basicAnimation.fillMode = .forwards
        // после того как анимация завершиться все будет удалено
        basicAnimation.isRemovedOnCompletion = true
        // добавляем на слой
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}


//MARK: - SetConstraints
extension TimerWorkoutViewController {
    
    private func setConstraints() {
  
        NSLayoutConstraint.activate([
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: newWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            ellipseImageView.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 20),
            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            ellipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])

        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: ellipseImageView.leadingAnchor, constant: 40),
            timerLabel.trailingAnchor.constraint(equalTo: ellipseImageView.trailingAnchor, constant: -40),
            timerLabel.centerYAnchor.constraint(equalTo: ellipseImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: ellipseImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            timerWorkoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            timerWorkoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerWorkoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerWorkoutParametersView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: timerWorkoutParametersView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
