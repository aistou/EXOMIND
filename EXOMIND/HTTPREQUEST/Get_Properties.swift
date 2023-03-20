//
//  Get_Properties.swift
//  EXOMIND
//
//  Created by aistou 💕 on 20/03/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodeError
    case apiError
    case unknownError
}

struct Sys: Decodable {
    let sunrise: Double?
    let sunset: Double?
    let icon: String?
}

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct WeatherData: Decodable, Identifiable {
    var _id: Int { id }
    let id: Int
    let name: String
    let weather: [Weather]
    let main: Main
    let sys: Sys
}

func Get_Properties(city: String, apiKey: String, completion: @escaping (WeatherData?, String?, Error?) -> Void) {
    
    let serviceURL = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
    
    guard let url = URL(string: serviceURL) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard error == nil else {
            completion(nil, nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, nil, NetworkError.invalidResponse)
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(nil, nil, NetworkError.invalidResponse)
            return
        }
        
        print("Status Code: \(response.statusCode)")
        print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
        
        switch response.statusCode {
        case 200:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData, weatherData.sys.icon, nil)
            } catch {
                print("Decode Error: \(error)")
                completion(nil, nil, NetworkError.decodeError)
            }
        case 400...499:
            print("API Error")
            completion(nil, nil, NetworkError.apiError)
        default:
            print("Unknown Error")
            completion(nil, nil, NetworkError.unknownError)
        }
        
    }
    
    task.resume()
    
}

