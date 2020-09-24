//
//  TableViewController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 21/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireEarthquakesController: UITableViewController {

    //MARK: Properties
    var alamoEarthquakeArray: [Earthquakes.Earthquake] = []
        
    //MARK: lifecycle
        override func viewDidLoad() {
        super.viewDidLoad()
            tableView.register(UINib(nibName: "EarthquakeCell", bundle: nil), forCellReuseIdentifier: earthquakeCellIdentifier)
        execute(URL(string: API_URL)!)
    }
    
    //MARK: Functions
    private func execute(_ url: URL){
        
        DispatchQueue.global().async {
            sleep(2)
            AF.request(url).responseDecodable(of: Earthquakes.self) { (response) in
                switch(response.result){
                case let .success(earthquake):
                    for earthquake in earthquake.earthquakes {
                        self.alamoEarthquakeArray.append(earthquake)
                    }
                    break
                case let .failure(error):
                    print(error)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationController?.navigationBar.topItem?.title = "Total \(self.alamoEarthquakeArray.count)"
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alamoEarthquakeArray.count == 0 ? 1 : alamoEarthquakeArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if alamoEarthquakeArray.count <= 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            cell.textLabel?.text = "No data Available"
            cell.textLabel?.textAlignment = .left
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.startAnimating()
            cell.accessoryView = activityIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: earthquakeCellIdentifier, for: indexPath) as! EarthquakeCell
            let earthquake = alamoEarthquakeArray[indexPath.row]
            cell.longitudeLabel.text = "\(earthquake.lng)"
            cell.latitudeLabel.text = "\(earthquake.lat)"
            cell.magnitudeLabel.text = "\(earthquake.magnitude)"
            cell.datetimeLabel.text = earthquake.datetime
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Save", bundle: nil)
        let saveVC = storyboard.instantiateViewController(withIdentifier: "Save") as! SaveController
        let nv = UINavigationController(rootViewController: saveVC)
        nv.modalPresentationStyle = .fullScreen
        let earthquake = alamoEarthquakeArray[indexPath.row]
        saveVC.earthquake = earthquake as AnyObject
        self.present(nv, animated: true)
    }
    
    
    
    

}
