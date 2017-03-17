//
//  DataModel.swift
//  Weather
//
//  Created by Kryg Tomasz on 16.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Alamofire

class DataModel {
    
    private var _date: Double?
    private var _temp: String?
    private var _location: String?
    private var _weather: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Katowice&appid=1e3d7a227d96d9db01d4b5df9c8773d4")!
    
    var date: String {
        guard let dateNumber: Double = _date else { return "Invalid date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: dateNumber)
        return dateFormatter.string(from: date)
    }
    
    var temp: String {
        return _temp ?? "Invalid temperature"
    }
    
    var location: String {
        return _location ?? "Invalid location"
    }
    
    var weather: String {
        return _weather ?? "Invalid weather"
    }
    
    func downloadData(completion: @escaping ()->()) {
        
        Alamofire.request(
            url,
            method: .get)
            .validate()
            .responseJSON(completionHandler: {
                
                response in
                let result = response.result
                print(response.result.value)
                print("Sukces?", response.result.isSuccess)
                if let dict = result.value as? JSONStandard,
                    let main = dict["main"] as? JSONStandard,
                    let temp = main["temp"] as? Double,
                    let weatherArray = dict["weather"] as? [JSONStandard],
                    let weather = weatherArray[0]["main"] as? String,
                    let name = dict["name"] as? String,
                    let dt = dict["dt"] as? Double {
                    
                    self._temp = String(format: "%.0f °C", temp - 273.15)
                    self._weather = weather
                    self._location = name
                    self._date = dt
                }
                
                completion()
            
        })
    }
    
}
