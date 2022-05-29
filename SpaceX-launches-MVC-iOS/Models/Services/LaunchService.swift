//
//  LaunchesService.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 25.05.2022.
//

import Foundation
import Combine
import Alamofire

class LaunchService {

    @Published var launchData: [LaunchData] = []
    var launchCount: Int? { launchData.count }

    func cellItem(for row: Int) -> LaunchData{
        return launchData[row]
    }

    func fetchData() {
        AF.request(Constants.URLs.launchesUrl,
                   method: .get,
                   headers: Constants.headers).response { response in
            guard let jsonData = response.data else {
                print("No data")
                return
            }
            do {
                self.launchData = try JSONDecoder().decode([LaunchData].self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
