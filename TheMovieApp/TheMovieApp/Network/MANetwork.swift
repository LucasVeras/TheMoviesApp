//
//  MANetwork.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 15/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import Alamofire


class MANetwork: NSObject {

    static let APIKEY = "45b1956356a74244575ecdc91681edcd"
    
    func sendRequest() {
        Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=\(MANetwork.APIKEY)").responseJSON { (response) in
            print(response)
        }
    }
    
}
