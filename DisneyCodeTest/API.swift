//
//  API.swift
//  DisneyCodeTest
//
//  Created by Jonathan Duty on 8/8/17.
//  Copyright © 2017 Class Extension. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

public enum ResultSimple {
    case success
    case failure(NSError)
    
    public var error: NSError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}


class API: NSObject {
    
    static let instance = API()
    
    
    func getImageURLs(handler: @escaping (_ result: Result<[URL]>) -> Void) {

        guard let url = URL(string:"https://pugme.herokuapp.com/bomb?count=50") else {
            handler(Result<[URL]>.failure(NSError(domain: "disney.error", code: 2, userInfo: [:])))
            return
        }
        
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.error {
                handler(Result<[URL]>.failure(error))
                return
            }
            
            if let json = response.data {
                let data = JSON(data: json)
                let pugs = data["pugs"].array
                
                let urls = pugs?.flatMap({ (json) -> URL? in
                    
                    let string = json.stringValue
                    if string.hasPrefix("http://media") {
                        return URL(string: string)
                    }
                    else {
                        let components = string.components(separatedBy: ".")
                        let fixedString = string.replacingOccurrences(of: "\(components.first!).", with: "http://")
                        return URL(string: fixedString)
                    }
                })
                guard let strongURLs = urls else {
                    handler(Result<[URL]>.failure(NSError(domain: "disney.error", code: 2, userInfo: [:])))
                    return
                }
                handler(Result.success(strongURLs))
                
            }
            
        }
    }

    
    
}
