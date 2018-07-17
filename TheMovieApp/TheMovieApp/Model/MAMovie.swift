//
//  MAMovie.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 16/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import ObjectMapper

class MAMovie: Mappable {
    
    var title: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
    }

}
