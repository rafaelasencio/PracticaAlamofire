//
//  TableViewController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 21/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit
import Alamofire

private let API_URL = "http://api.geonames.org/earthquakesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&username=rafaelb"
private let earthquakeCellIdentifier = "earthquakeCell"

class TableViewController: UITableViewController {

    //MARK: Properties
    var earthquakesArray: [Earthquakes.Earthquake] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    
    //MARK: lifecycle
        override func viewDidLoad() {
        super.viewDidLoad()
            tableView.register(UINib(nibName: "EarthquakeCell", bundle: nil), forCellReuseIdentifier: earthquakeCellIdentifier)
            activityView.isHidden = true
            activityIndicator.isHidden = true
        execute(URL(string: API_URL)!)
    }
    
    //MARK: Functions
    private func execute(_ url: URL){
        activityIndicator.startAnimating()
        activityView.isHidden = false
        activityIndicator.isHidden = false
        DispatchQueue.global().async {
            sleep(2)
            let request = AF.request(url)
            request.responseJSON { response in
                if let error = response.error {
                    print(error)
                }
                guard let data = response.data else { return }
                if let earthquake = try? JSONDecoder().decode(Earthquakes.self, from: data) {
                    for earthquake in earthquake.earthquakes {
                        self.earthquakesArray.append(earthquake)
                    }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                        self.activityView.isHidden = true
                        self.tableView.reloadData()
                        self.navigationController?.navigationBar.topItem?.title = "Total \(self.earthquakesArray.count)"
                    }
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakesArray.count == 0 ? 1 : earthquakesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if earthquakesArray.count <= 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            cell.textLabel?.text = "No data Available"
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: earthquakeCellIdentifier, for: indexPath) as! EarthquakeCell
            let earthquake = earthquakesArray[indexPath.row]
            cell.longitudeLabel.text = "\(earthquake.lng)"
            cell.latitudeLabel.text = "\(earthquake.lat)"
            cell.magnitudeLabel.text = "\(earthquake.magnitude)"
            let date = formatDate(earthquake.datetime)
            cell.datetimeLabel.text = date
            return cell
        }
    }
    
    //MARK: Helpers
    
    func formatDate(_ date: String)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        guard let date = dateFormatterGet.date(from: date) else { return ""}
        return dateFormatterPrint.string(from: date)
    }
    

}
