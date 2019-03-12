//
//  WeatherTableViewController.swift
//  weather-app
//
//  Created by Selvina Fernandes on 3/4/19.
//  Copyright © 2019 selvina fernandes. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController , UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    var forecastData = [WeatherData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            WeatherData.weatherDataForCity(city: locationString, completion: {(results: [WeatherData]?) in
                if let weatherData = results {
                    self.forecastData = weatherData
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day,value:section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd,yyyy"
        
        return dateFormatter.string(from: date!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let weatherObject = forecastData[indexPath.section]
        cell.textLabel?.text = weatherObject.description
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °C"
        return cell
    }
}
