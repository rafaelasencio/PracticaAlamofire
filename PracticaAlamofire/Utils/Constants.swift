//
//  Constants.swift
//  PracticaAlamofire
//
//  Created by Usuario on 22/09/2020.
//  Copyright © 2020 RafaelAB. All rights reserved.
//

import Foundation
import RealmSwift

let API_URL = "http://api.geonames.org/earthquakesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&username=rafaelb"

let earthquakeCellIdentifier = "earthquakeCell"

let realm = RealmService.shared.realm

var notificationToken: NotificationToken?
