//
//  EditProfileTableViewCell.swift
//  myWorkout
//
//  Created by Миша on 13.05.2022.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    
    let textField = SpecialTextField()
    lazy var outputText = ""
    var outputData: ((String)->())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textField.frame.size = frame.size
    }
    
    private func setupView(){
        backgroundColor = .specialLightBrown
        layer.cornerRadius = 10
        selectionStyle = .none //чтобы ячейка не выделялась когда на нее нажимаешь
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func setupTexField(){
        textField.addTarget(self, action: #selector(enteredText), for: .allEditingEvents)
    }
    
     @objc private func enteredText(){
         guard let text = textField.text else {return}
         outputText = text
         guard let outputData = outputData else {return}
         outputData(text)
    }
}
