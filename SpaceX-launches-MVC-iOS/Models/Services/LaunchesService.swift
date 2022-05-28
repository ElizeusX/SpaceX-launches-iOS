//
//  LaunchesService.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 25.05.2022.
//

import Foundation
import Alamofire

class LaunchesService {

    func fetchData() {
        AF.request(Constants.URLs.launchesUrl,
                   method: .get,
                   headers: Constants.headers).response { response in
            debugPrint(response)
        }
    }
}
