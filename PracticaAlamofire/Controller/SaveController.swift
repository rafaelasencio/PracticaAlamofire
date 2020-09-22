//
//  SaveController.swift
//  PracticaAlamofire
//
//  Created by Usuario on 21/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit

class SaveController: UIViewController {

    // MARK: - Properties
    var earthquake: Earthquakes.Earthquake?
    
    // MARK: - IBOulets
    @IBOutlet weak var latitudeTextfield: UITextField!
    @IBOutlet weak var longitudeTextfield: UITextField!
    @IBOutlet weak var magnitudeTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var earthquakeDatepicker: UIDatePicker!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Save Data"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissController))
        loadData()
    }
    
    // MARK: - Actions
    @objc func dismissController(){
        dismiss(animated: true)
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
    
    func loadData(){
        guard let earthquake = earthquake else { return }
        latitudeTextfield.text = "\(earthquake.lat)"
        longitudeTextfield.text = "\(earthquake.lng)"
        magnitudeTextfield.text = "\(earthquake.magnitude)"
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datetime = formater.date(from: earthquake.datetime)
        earthquakeDatepicker.setDate(datetime ?? Date(), animated: true)
    }
    


}
