//
//  WeatherView.swift
//  myWorkout
//
//  Created by Миша on 05.04.2022.
//

import UIKit

class WeatherView: UIView {
    
    // MARK: - initialise elements
    private let sunImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sun")
        return imageView
    }()
    
    private let currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.robotoMedium18()
        label.numberOfLines = 1
        label.textColor = .specialGray
        label.sizeToFit()
        label.text = "It's Sunny"
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private let descriptionMotivationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.robotoMedium14()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .specialBrown
        label.text = "Good weather for workout outside, so take your ass and go out!"
        return label
    }()
    
    // MARK: - live cycle
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
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(sunImageView)
        addSubview(currentWeatherLabel)
        addSubview(descriptionMotivationLabel)
    }
    
    private func updateLabel(model: WeatherModel) {
        currentWeatherLabel.text = "\(model.weather[0].myDescription) \(model.main.temperatureCelsius)°C"
    }
    
    private func updateImage(data: Data) {
        guard let image = UIImage(data: data) else { return }
        sunImageView.contentMode = .scaleAspectFill

        sunImageView.image = image
    }
    
    public func setWeather(model: WeatherModel) {
        updateLabel(model: model)
    }
    
    public func setImage(data: Data) {
        updateImage(data: data)
    }
}


// MARK: - Constraints
extension WeatherView {
    
    private func setupConstraints() {
        let constraints = [
            sunImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            sunImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            sunImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            currentWeatherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            currentWeatherLabel.topAnchor.constraint(equalTo: sunImageView.topAnchor, constant: 0),
            currentWeatherLabel.trailingAnchor.constraint(equalTo: sunImageView.leadingAnchor, constant: -10),
            currentWeatherLabel.heightAnchor.constraint(equalToConstant: currentWeatherLabel.frame.size.height),
            
            descriptionMotivationLabel.leadingAnchor.constraint(equalTo: currentWeatherLabel.leadingAnchor, constant: 0),
            descriptionMotivationLabel.topAnchor.constraint(equalTo: currentWeatherLabel.bottomAnchor, constant: 0),
            descriptionMotivationLabel.trailingAnchor.constraint(equalTo: currentWeatherLabel.trailingAnchor, constant: 0),
            descriptionMotivationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


