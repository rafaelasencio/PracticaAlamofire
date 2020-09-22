//
//  Extensions.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit

extension UIViewController {
        
    func formatDate(_ date: String)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        guard let date = dateFormatterGet.date(from: date) else { return "" }
        return dateFormatterPrint.string(from: date)
    }
    
    func formatDate(_ date: Date)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return "" //dateFormatterPrint.string(from: date)
    }
}
