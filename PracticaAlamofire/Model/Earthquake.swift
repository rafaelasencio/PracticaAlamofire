//
//  Earthquake.swift
//  PracticaAlamofire
//
//  Created by Usuario on 21/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import Foundation

struct Earthquakes: Codable {
    let earthquakes: [Earthquake]
    
    struct Earthquake: Codable {
        let datetime:String
        let depth: Float
        let lng: Float
        let src: String
        let magnitude: Float
        let lat: Float
    }
}
