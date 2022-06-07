//
//  NetworkDataFetch.swift
//  myWorkout
//
//  Created by Миша on 07.06.2022.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchWeather(response: @escaping (WeatherModel?, Error?)->()) {

        NetworkRequest.shared.requestData() { result in

            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    response(weather, nil)
                    print(weather)
                } catch let jsonError{
                    print("Failed to decode JSON WeatherModel", jsonError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil, error)
            }
        }
    }
}
