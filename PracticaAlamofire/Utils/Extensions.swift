//
//  Extensions.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(in vc: UIViewController, style: UIAlertController.Style, with title: String,
                      dflt: String, cancel: String? = nil, destructive: String? = nil){
        
        let controller = UIAlertController(title: title, message: "", preferredStyle: style)
        controller.addAction(UIAlertAction(title: dflt, style: .default))

        if let cancel = cancel { controller.addAction(UIAlertAction(title: cancel, style: .cancel))}
        if let destructive = destructive {controller.addAction(UIAlertAction(title: destructive, style: .destructive))}
        
        present(controller, animated: true)
    }
}
