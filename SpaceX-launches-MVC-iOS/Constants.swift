//
//  Constants.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import Foundation
import Alamofire

struct Constants{
    struct URLs {
        static let versionApi = "v4"
        static let baseUrl = "https://api.spacexdata.com/\(versionApi)"
        static let launchesUrl = "\(baseUrl)/launches"
        static let rocketsUrl = "\(baseUrl)/rockets"
    }

    static let headers: HTTPHeaders = ["Content-Type": "application/json"]
}
