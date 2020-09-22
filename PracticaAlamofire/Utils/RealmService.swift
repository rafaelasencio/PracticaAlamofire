//
//  RealmService.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import UIKit
import RealmSwift

class Earthquake: Object {
    @objc dynamic var lat: Float = 0
    @objc dynamic var lnt: Float = 0
    @objc dynamic var depth: Float = 0
    @objc dynamic var magnitude: Float = 00
    @objc dynamic var src: String = ""
    @objc dynamic var datetime: Date = Date()
    
    convenience init(lat: Float, lnt: Float, depth: Float, magnitude: Float, src: String, datetime: Date) {
        self.init()
        self.lat = lat
        self.lnt = lnt
        self.depth = depth
        self.magnitude = magnitude
        self.src = src
        self.datetime = datetime
    }
    
//    required init() {
//        fatalError("init() has not been implemented")
//    }
}

class RealmService {
    
    let realm = try! Realm()
    
    func saveEarthquake(object: Earthquake){
        print(Realm.Configuration.defaultConfiguration.fileURL)
        realm.beginWrite()
        realm.add(object)
        try? realm.commitWrite()
    }
    
    func getEarthquakes() -> Results<Earthquake> {
        let earthquakes = realm.objects(Earthquake.self)
        return earthquakes
    }
    
    func delete(object: Earthquake){
        realm.beginWrite()
        realm.delete(object)
        try? realm.commitWrite()
    }
    
    
}



