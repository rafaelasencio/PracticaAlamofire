//
//  ViewController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 21/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit
import Alamofire

class InitialController: UIViewController {

    //MARK: IBOulets
    

    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        executee(URL(string: API_URL)!)
    }
    
    //MARK: Functions

    func executee(_ url: URL){
        let request = AF.request(url)
        request.responseDecodable(of: Earthquake.self) { (response) in
            guard let data = response.data else { return }
            if let earthquake = try? JSONDecoder().decode(Earthquake.self, from: data) {
                print(earthquake.status.message)
                print(earthquake.status.value)
            } else {
                
            }
            
        }
    }


}

