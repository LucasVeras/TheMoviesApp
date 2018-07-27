//
//  MANetwork.swift
//  TheMovieApp
//
//  Created by Lucas Veras Aguiar Cardoso on 15/07/18.
//  Copyright © 2018 Lucas Veras Aguiar Cardoso. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import SwiftyJSON
import ObjectMapper

class MANetwork: NSObject {
    
    enum JSONRootKey: String {
        case Results = "results"
        case Genres = "genres"
    }
    
    static let API_KEY = "45b1956356a74244575ecdc91681edcd"
    static let UPCOMING_MOVIE_LIST_PAGE = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(API_KEY)&language=pt&page="
    static let GET_MOVIE_IMAGE_POSTER = "https://image.tmdb.org/t/p/original"
    static let GET_GENRES = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(API_KEY)&language=pt-BR"
    
    
    func sendGETRequestResponseJSON <T: Mappable> (url: String, responseType: T.Type, rootJSONKey: JSONRootKey) -> (Observable<[T]>) {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(url).responseJSON { (responseData) in
                switch responseData.result {

                case .success(let value):
                    let responseJSON = JSON(value)
                    if let reponseObject = Mapper<T>().mapArray(JSONObject: responseJSON[rootJSONKey.rawValue].object) {
                        observer.onNext(reponseObject)
                        observer.onCompleted()
                    } else{
                        observer.onError(NSError(domain: NSLocalizedString("WRAPPER_ERROR", comment: ""), code: -1, userInfo: nil))
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func sendGETRequestResponseData (url: String) -> (Observable<Data>) {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(url).responseData { (responseData) in
                switch responseData.result {
                    
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()

                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
}
