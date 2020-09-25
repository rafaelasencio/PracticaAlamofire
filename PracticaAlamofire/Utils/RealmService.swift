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
}

class RealmService {
    
    static let shared = RealmService()
    
    let realm = try! Realm()
    
    func create<T: Object>(_ object: T){
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getObjects() -> Results<Earthquake> {
        return realm.objects(Earthquake.self)
    }
    
    
}



