//
//  RealmEarthquakesController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit
import RealmSwift

class RealmEarthquakesController: UITableViewController {

    // MARK: - Properties
    var realmEarthquakes: Results<Earthquake>!
    
    //MARK: - IBOulets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EarthquakeCell", bundle: nil), forCellReuseIdentifier: earthquakeCellIdentifier)
        
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    // MARK: - Functions
    func loadData(){
        realmEarthquakes = realm.objects(Earthquake.self)
        notificationToken = realmEarthquakes.observe({ (changes) in
            switch changes {
            
            case .initial(_): //primera carga
                self.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.tableView.beginUpdates() //inicio cambios
                self.tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    //MARK: Actions
    
    @IBAction func createNewEarthquake(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Save", bundle: nil)
        let saveVC = storyboard.instantiateViewController(withIdentifier: "Save") as! SaveController
        let nv = UINavigationController(rootViewController: saveVC)
        nv.modalPresentationStyle = .overFullScreen
        self.present(nv, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmEarthquakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let earthquake = realmEarthquakes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: earthquakeCellIdentifier, for: indexPath) as! EarthquakeCell
        cell.longitudeLabel.text = "\(earthquake.lnt)"
        cell.latitudeLabel.text = "\(earthquake.lat)"
        cell.magnitudeLabel.text = "\(earthquake.magnitude)"
        cell.datetimeLabel.text = "\(earthquake.datetime)"
        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let earthquake = realmEarthquakes[indexPath.row]
        RealmService.shared.delete(earthquake)
            
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Save", bundle: nil)
        let saveVC = storyboard.instantiateViewController(withIdentifier: "Save") as! SaveController
        let nv = UINavigationController(rootViewController: saveVC)
        nv.modalPresentationStyle = .fullScreen
        let earthquake = realmEarthquakes[indexPath.row]
        saveVC.updateRealmValue = true
        saveVC.earthquake = earthquake
        self.present(nv, animated: true)
    }
    
}


