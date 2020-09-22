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
        latitudeTextfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        longitudeTextfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        magnitudeTextfield.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        setUI()
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        formValidation()

    }
    
    // MARK: - Actions
    @objc func dismissController(){
        dismiss(animated: true)
    }
    
    @objc func formValidation(){
        if latitudeTextfield.hasText && longitudeTextfield.hasText &&
            magnitudeTextfield.hasText {
            saveButton?.isUserInteractionEnabled = true
            saveButton?.alpha = 1.0
        }else{
            saveButton?.isUserInteractionEnabled = false
            saveButton?.alpha = 0.5
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let lat = Float(latitudeTextfield.text!) else { return }
        guard let lnt = Float(longitudeTextfield.text!) else { return }
        guard let mag = Float(magnitudeTextfield.text!) else { return }
        let datetime = earthquakeDatepicker.date
        
        let earthquake = Earthquake(lat: lat, lnt: lnt, depth: 0, magnitude: mag, src: "", datetime: datetime)
        service.saveEarthquake(object: earthquake)
        dismiss(animated: true)
    }
    
    //MARK: Helpers
    
    func setUI(){
        saveButton?.isUserInteractionEnabled = false
        saveButton?.alpha = 0.5
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
