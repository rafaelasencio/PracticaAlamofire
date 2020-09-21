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

class TableViewController: UITableViewController {

    //MARK: Properties
    var earthquakesArray: [Earthquakes] = []
    
    //MARK: lifecycle
        override func viewDidLoad() {
        super.viewDidLoad()
        
        execute(URL(string: API_URL)!)
    }
    
    //MARK: Functions
    private func execute(_ url: URL){
        let request = AF.request(url)
        
        request.responseJSON { response in
            guard let data = response.data else { return }
            if let earthquake = try? JSONDecoder().decode(Earthquakes.self, from: data) {
                for earthquake in earthquake.earthquakes {
                    print(earthquake.lat)
                    print(earthquake.lng)
                    print(earthquake.magnitude)
                    print(earthquake.datetime)
                    print(earthquake.depth)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        return cell
    }
    

}
