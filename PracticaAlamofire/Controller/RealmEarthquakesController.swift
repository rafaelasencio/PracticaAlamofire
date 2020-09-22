//
//  RealmEarthquakesController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit

class RealmEarthquakesController: UITableViewController {

    // MARK: - Properties
    var earthquakeArray: [Earthquake] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EarthquakeCell", bundle: nil), forCellReuseIdentifier: earthquakeCellIdentifier)
        loadData()
    }
    
    // MARK: - Functions
    func loadData(){
        for earthquake in service.getEarthquakes() {
            earthquakeArray.append(earthquake)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return earthquakeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let earthquake = earthquakeArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: earthquakeCellIdentifier, for: indexPath) as! EarthquakeCell
        cell.longitudeLabel.text = "\(earthquake.lnt)"
        cell.latitudeLabel.text = "\(earthquake.lat)"
        cell.magnitudeLabel.text = "\(earthquake.magnitude)"
        cell.datetimeLabel.text = "\(earthquake.datetime)"
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let earthquake = earthquakeArray[indexPath.row]
            service.delete(object: earthquake)
            earthquakeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
