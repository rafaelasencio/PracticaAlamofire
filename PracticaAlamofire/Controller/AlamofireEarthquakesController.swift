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
    var earthquakesArray: [Earthquakes.Earthquake] = []
        
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
                        self.earthquakesArray.append(earthquake)
                    }
                    break
                case let .failure(error):
                    print(error)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationController?.navigationBar.topItem?.title = "Total \(self.earthquakesArray.count)"
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
            cell.textLabel?.textAlignment = .left
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.startAnimating()
            cell.accessoryView = activityIndicator
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Save", bundle: nil)
        let saveVC = storyboard.instantiateViewController(withIdentifier: "Save") as! SaveController
        let nv = UINavigationController(rootViewController: saveVC)
        nv.modalPresentationStyle = .fullScreen
        let earthquake = earthquakesArray[indexPath.row]
        saveVC.earthquake = earthquake
        self.present(nv, animated: true)
    }
    
    //MARK: Actions
    
    @IBAction func createNewEarthquake(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Save", bundle: nil)
        let saveVC = storyboard.instantiateViewController(withIdentifier: "Save") as! SaveController
        let nv = UINavigationController(rootViewController: saveVC)
        nv.modalPresentationStyle = .fullScreen
        self.present(nv, animated: true)
    }
    
    

}
