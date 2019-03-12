//
//  weather.swift
//  weather-app
//
//  Created by Selvina Fernandes on 3/4/19.
//  Copyright © 2019 selvina fernandes. All rights reserved.
//

import Foundation

struct WeatherData {
    let description: String
    let date: String
    let temperature: Double
    let cloud: Int
    
    enum WeatherDataError: Error {
        case Unknown
        case FailedRequest
        case InvalidResponse
    }
    
    static func weatherDataForCity(city: String, completion: @escaping ([WeatherData]) -> ()) {
        
        //Create URL
        let request = URLRequest(url: URL(string:"http://api.openweathermap.org/data/2.5/forecast?q=\(city)&APPID=\(API.APIKey)")!);

        //Create data
        URLSession.shared.dataTask(with: request,completionHandler: { (data, response, error) -> Void in
            var array = [WeatherData]()
            if let data = data {
                do {
                    let JSON = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        let name = (JSON["city"] as! [String:Any])["name"]
                        let forecasts = JSON["list"] as! NSArray
                        var array = [WeatherData]()
                    
                        for  (index,dataPoint) in forecasts.enumerated() {
                            let dataIndex = forecasts[index] as! NSDictionary
                            let descArray = dataIndex["weather"] as! [[String:Any]]
                            let descDict = descArray[0]["description"]
                            
                            let tempNum = dataIndex["main"] as! [String:Any]
                            let temp = tempNum["temp"] as? Double
                            let celsius = round(temp! - 273.15)
                            
                            let cloudNum = dataIndex["clouds"] as! [String:Any]
                            let cloud = cloudNum["all"] as? Int
                            
                            let date = dataIndex["dt_txt"]
                            
                            let city = WeatherData(description: descDict as! String, date: date as! String, temperature:celsius, cloud: cloud!)
                            
                            array.append(city)
                    }
                    completion(array)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }
}
