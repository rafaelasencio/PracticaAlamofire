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
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    func getObjects() -> Results<Earthquake> {
        return realm.objects(Earthquake.self)
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion:@escaping(Error?)->()){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
    
}



