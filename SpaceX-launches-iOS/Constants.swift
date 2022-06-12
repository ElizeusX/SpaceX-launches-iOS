//
//  Constants.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import Foundation
import Alamofire

struct Constants{
    struct URLs {
        static let versionApi = "v4"
        static let baseUrl = "https://api.spacexdata.com/\(versionApi)"
        static let launchesUrl = "\(baseUrl)/launches/past"
        static let rocketsUrl = "\(baseUrl)/rockets"
    }

    static let headers: HTTPHeaders = ["Content-Type": "application/json"]

    struct Icons {
        static let success = "checkmark.circle"
        static let fail = "x.circle"
        static let calendar = "calendar"
        static let mass = "scalemass"
        static let check = "checkmark"
        static let height = "arrow.up.and.down"
        static let info = "info.circle"
        static let questionmark = "questionmark.circle"
        static let xmark = "xmark"
    }

    struct Colors {
        static let paleOrange = "PaleOrange"
        static let dirtyWhite = "DirtyWhite"
    }
}
