//
//  InfoModel.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 31/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class InfoModel {
    var infoType: String?
    var information: String?
    var url: String?
    var id: String?
    
    init(dict: AnyObject){
        self.infoType = dict["info_type"] as? String
        self.information = dict["information"] as? String
        self.url = dict["url"] as? String
        self.id = dict["id"] as? String

    }
    
}