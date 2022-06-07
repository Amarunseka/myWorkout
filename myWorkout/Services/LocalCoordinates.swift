//
//  LocalCoordinates.swift
//  myWorkout
//
//  Created by Миша on 06.06.2022.
//

import Foundation
import CoreLocation


class LocalCoordinates: NSObject {
    
    // 1 Добавить в infoplist:
    // строку - Privacy - Location When In Use Usage Description
    // туда добавить описание которое будет появляться при запросе использования геолокации
    // в edit Scheme выбрать локацию Moscow
    
    private let locationManager = CLLocationManager()
    static var coordinates = CLLocationCoordinate2D()
    
    override init() {
        super.init()
        startLocationManager()
    }
    
    
    private func startLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocalCoordinates: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            LocalCoordinates.coordinates = lastLocation.coordinate
//            print("dddddddd", lastLocation.coordinate)
        }
    }
}

