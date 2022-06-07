//
//  NetworkRequest.swift
//  myWorkout
//
//  Created by Миша on 06.06.2022.
//

import Foundation
import CoreLocation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init(){}
    
    func requestData(completion: @escaping (Result<Data, Error>)->()) {

        let key = "df1783331e623eacf23b7bd5645dd8c5"
        let latitude = LocalCoordinates.coordinates.latitude
        let longitude = LocalCoordinates.coordinates.longitude
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                completion(.success(data))
            }
        }.resume()
    }
}
