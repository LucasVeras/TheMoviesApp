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
    var imagePoster: String?
    var releaseDate: String?
    var overview: String?
    var genresId: [Int]? // campo que desce do endpoint, depois é convertido para o array de generos
    
    var genres: [MAMovieGenre] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        releaseDate <- map["release_date"]
        imagePoster <- map["poster_path"]
        overview <- map["overview"]
        genresId <- map["genre_ids"]
    }

}
