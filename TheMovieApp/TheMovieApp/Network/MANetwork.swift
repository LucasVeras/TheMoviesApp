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
    
    enum ApiUrl: String {
        case UPCOMING_MOVIE_LIST = "https://api.themoviedb.org/3/movie/upcoming?api_key=45b1956356a74244575ecdc91681edcd&language=pt"
    }
    
    func sendRequest <T: Mappable> (url: ApiUrl, responseType: T.Type) -> (Observable<[T]>) {
        return Observable.create({ (observer) -> Disposable in
            let request = Alamofire.request(url.rawValue).responseJSON { (responseData) in
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
    
}
