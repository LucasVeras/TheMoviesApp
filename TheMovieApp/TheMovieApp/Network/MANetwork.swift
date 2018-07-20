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
    
    static let UPCOMING_MOVIE_LIST_PAGE = "https://api.themoviedb.org/3/movie/upcoming?api_key=45b1956356a74244575ecdc91681edcd&language=pt&page="
    static let GET_MOVIE_IMAGE_POSTER = "https://image.tmdb.org/t/p/original"
    
    
    func sendGETRequestResponseJSON <T: Mappable> (url: String, responseType: T.Type) -> (Observable<[T]>) {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(url).responseJSON { (responseData) in
                switch responseData.result {

                case .success(let value):
                    let responseJSON = JSON(value)
                    if let reponseObject = Mapper<T>().mapArray(JSONObject: responseJSON["results"].object) {
                        observer.onNext(reponseObject)
                        observer.onCompleted()
                    } else{
                        observer.onError(NSError(domain: "Erro de wrapper", code: -1, userInfo: nil))
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
