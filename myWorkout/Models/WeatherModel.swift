//
//  WeatherModel.swift
//  myWorkout
//
//  Created by Миша on 06.06.2022.
//

import Foundation

struct WeatherModel: Codable {
    let main: Main
    let name: String
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    var temperatureCelsius: Int {
        Int(temp - 273.15)
    }
}

struct Weather: Codable {

    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
    
    var myDescription: String {
        switch weatherDescription {
        case "clear sky": return "Ясно"
        case "few clouds": return "Облачно"
        case "scattered clouds": return "Облачно"
        case "broken clouds": return "Облачно"
        case "shower rain": return "Сильный дождь"
        case "rain": return "Дождь"
        case "thunderstorm": return "Гроза"
        case "snow": return "Снег"
        case "mist": return "Туман"
        default: return "No data"
        }
    }
}















//// MARK: - Weather
//struct Weather: Codable {
//    let coord: Coord
//    let weather: [WeatherElement]
//    let base: String
//    let main: Main
//    let visibility: Int
//    let wind: Wind
//    let clouds: Clouds
//    let dt: Int
//    let sys: Sys
//    let timezone, id: Int
//    let name: String
//    let cod: Int
//}
//
//// MARK: - Coord
//struct Coord: Codable {
//    let lon, lat: Double
//}
//
//// MARK: - WeatherElement
//struct WeatherElement: Codable {
//    let id: Int
//    let main, weatherDescription, icon: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription = "description"
//        case icon
//    }
//}
//
//// MARK: - Main
//struct Main: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let pressure, humidity: Int
//
//    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure, humidity
//    }
//}
//
//// MARK: - Wind
//struct Wind: Codable {
//    let speed: Double
//    let deg: Int
//}
//
//// MARK: - Clouds
//struct Clouds: Codable {
//    let all: Int
//}
//
//// MARK: - Sys
//struct Sys: Codable {
//    let type, id: Int
//    let message: Double
//    let country: String
//    let sunrise, sunset: Int
//}
//
//
//
//
