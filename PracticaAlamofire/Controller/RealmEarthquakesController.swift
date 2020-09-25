//
//  RealmEarthquakesController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit
import RealmSwift

class RealmEarthquakesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var realmEarthquakes: Results<Earthquake>!
    
    //MARK: - IBOulets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var orderButtonPressed = false
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EarthquakeCell", bundle: nil), forCellReuseIdentifier: earthquakeCellIdentifier)
        searchBar.delegate = self
//        loadData()
        orderButton.addTarget(self, action: #selector(filterObjectsResult), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(sortBySegmentValue), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    // MARK: - Functions
    private func loadData(){
        realmEarthquakes = realm.objects(Earthquake.self)
        notificationToken = realmEarthquakes.observe({ [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial(_): //primera carga
                tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.beginUpdates() //inicio cambios
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func sortRealmObjects() {
        let keypath = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)!
        if searchBar.text!.isEmpty {
            realmEarthquakes = RealmService.shared.sortObjectsBy(keypath.lowercased(), ascending: !orderButtonPressed)
        } else {
            
            realmEarthquakes = RealmService.shared.sortObjectsBy(keypath.lowercased(), ascending: !orderButtonPressed)?.filter("magnitude >= \(searchBar.text!)")
        }
        tableView.reloadData()
    }
    
    @objc func filterObjectsResult(){
        orderButtonPressed = !orderButtonPressed
        let image = orderButtonPressed ? "arrow.down" : "arrow.up"
        orderButton.setImage(UIImage(systemName: image), for: .normal)
        sortRealmObjects()
    }
    
    @objc func sortBySegmentValue(value: Int){
        sortRealmObjects()
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmEarthquakes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let earthquake = realmEarthquakes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: earthquakeCellIdentifier, for: indexPath) as! EarthquakeCell
        cell.longitudeLabel.text = "\(earthquake.lnt)"
        cell.latitudeLabel.text = "\(earthquake.lat)"
        cell.magnitudeLabel.text = "\(earthquake.magnitude)"
        cell.datetimeLabel.text = "\(earthquake.datetime)"
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let earthquake = realmEarthquakes[indexPath.row]
        RealmService.shared.delete(earthquake)
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension RealmEarthquakesController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text!
        if !text.isEmpty {
            guard let magnitude = Float(text) else { return }
            realmEarthquakes = RealmService.shared.getObjects(with: magnitude)
        } else {
            realmEarthquakes = realm.objects(Earthquake.self)
        }
        tableView.reloadData()
    }
}


