//
//  Ns.swift
//  NS API test
//
//  Created by Mike Hendriks on 28/03/2019.
//  Copyright © 2019 Mike Hendriks. All rights reserved.
//

import Foundation

struct Ns {
    //    let plannedDurationInMinutes:String
    let status:String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(status:String) {
        self.status = status
    }
    
    static let basePath = "https://ns-api.nl/reisinfo/api/v3/trips?";
    
    
    static func route (parameters:String, completion:@escaping ([Ns]) -> ()) {
        let url = basePath + parameters
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.addValue("K4aIkq4ovu92GDZYJoi9s02NYbGO34o7Tz3Kdo70", forHTTPHeaderField: "x-api-key")


        let task = URLSession.shared.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            var tripArray:[Ns] = []

            if let data = data {

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{

                        if let trips = json["trips"] as? [[String:Any]] {

                            for dataPoint in trips {

                                let tripObject = Ns(status: dataPoint["status"] as! String)

                                tripArray.append(tripObject)

                            }

                        }


                    }
                } catch {
                    print(error.localizedDescription)
                }

                completion(tripArray)

            }
        }

        task.resume()
    }
}

