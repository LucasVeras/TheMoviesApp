//
//  MAMovieGenre.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 26/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import ObjectMapper

class MAMovieGenre: Mappable {

    var id: Int?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }

}
