//
//  EditingExerciseAlert.swift
//  myWorkout
//
//  Created by Миша on 05.05.2022.
//


// ВСЕ ТУТ ПЕРЕДЕЛАТЬ В БОЖЕСКИЙ ВИД
// СДЕЛАТЬ ТАК, ЧТО ПРИ ЕГО ВЫЗОВЕ В ТЕКСТФИЛДЕ БЫЛО УЖЕ СУЩЕСТВУЮЩЕЕ ЗНАЧЕНИЕ
// ДОБАВИТЬ СКРЫТИЕ КЛАВИАТУРЫ ПРИ ТАПАНЬЕ В ЛЮБОЕ МЕСТО
// ПРИ РЕДАКТИРОВАНИИ МОЖНО ПОСТАВИТЬ МЕНЬШЕ ПОВТОРЕНИЙ ЧЕМ УЖЕ ВЫПОЛНЕНО (ОБРАБОТАТЬ)
import UIKit

class EditingExerciseAlert {
    
    private let backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var buttonAction: ( (String, String) -> Void)?
    
    private let scrollView = UIScrollView()
    
    private var mainView: UIView?
    
    private let setsTextField = SpecialTextField()
    private let repsTextField = SpecialTextField()
    
    func alertCustom(viewController: UIViewController,
                     repsOrTimer: String,
                     completion: @escaping (String, String) -> Void) {
        
        registerForKeyboardNotification()
        setsTextField.becomeFirstResponder()
        
        // получаем view от VC на котором вызываем
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(
            x: 40,
            y: -420,
            width: parentView.frame.width - 80,
            height: 420)
        scrollView.addSubview(alertView)
        
        
        let sportsmanImageView = UIImageView(frame: CGRect(
            x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
            y: 30,
            width: alertView.frame.height * 0.4,
            height: alertView.frame.height * 0.4))
        sportsmanImageView.image = UIImage(named: "sportsmanAlert")
        sportsmanImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmanImageView)
        
        
        let editingLabel = UILabel(frame: CGRect(
            x: 10,
            y: alertView.frame.height * 0.4 + 50,
            width: alertView.frame.width - 20,
            height: 25))
        
        editingLabel.text = "Editing"
        editingLabel.textAlignment = .center
        editingLabel.font = .robotoMedium22()
        alertView.addSubview(editingLabel)
        
        
        let setsLabel = UILabel.smallBrownLabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(
            x: 30,
            y: editingLabel.frame.maxY + 10,
            width: alertView.frame.width - 60,
            height: 20)
        alertView.addSubview(setsLabel)
        
        setsTextField.translatesAutoresizingMaskIntoConstraints = true
        setsTextField.frame = CGRect(
            x: 20,
            y: setsLabel.frame.maxY,
            width: alertView.frame.width - 40,
            height: 30)
        setsTextField.keyboardType = .numberPad
        alertView.addSubview(setsTextField)
        
        let repsOrTimerLabel = UILabel.smallBrownLabel(text: repsOrTimer)
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(
            x: 30,
            y: setsTextField.frame.maxY + 3,
            width: alertView.frame.width - 60,
            height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTextField.translatesAutoresizingMaskIntoConstraints = true
        repsTextField.frame = CGRect(
            x: 20,
            y: repsOrTimerLabel.frame.maxY,
            width: alertView.frame.width - 40,
            height: 30)
        repsTextField.keyboardType = .numberPad
        alertView.addSubview(repsTextField)
        
        
        let okButton = UIButton(frame: CGRect(
            x: 50,
            y: repsTextField.frame.maxY + 15,
            width: alertView.frame.width - 100,
            height: 35))
        okButton.backgroundColor = .specialGreen
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.titleLabel?.font = .robotoMedium18()
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = completion
        
        // MARK: - Анимация появления алерта
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func okButtonTapped() {
        
        guard let setsNumber = setsTextField.text,
              let repsNumber = repsTextField.text else { return }
        buttonAction?(setsNumber, repsNumber)
        
        guard let targetView = mainView else { return }
        
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(
                x: 40,
                y: targetView.frame.height,
                width: targetView.frame.width - 80,
                height: 420)
            
        } completion: { done in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0
            } completion: { done in
                if done {
                    self.alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.scrollView.removeFromSuperview()
                    self.setsTextField.text = ""
                    self.repsTextField.text = ""
                    self.removeForKeyboardNotification()
                }
            }
        }
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func kbWillShow(notification: NSNotification) {
        // указать размер клавиатуры
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height / 3)
        }
    }
    @objc private func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
