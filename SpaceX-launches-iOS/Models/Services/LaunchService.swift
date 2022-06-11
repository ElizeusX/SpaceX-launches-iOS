//
//  LaunchesService.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 25.05.2022.
//

import Foundation
import Alamofire

final class LaunchService {

    var launchData: [LaunchData] = []
    var rocketData: [RocketData] = []

    func fetchLaunchData(completion: @escaping(Bool) -> Void) {
        AF.request(Constants.URLs.launchesUrl,
                   method: .get,
                   headers: Constants.headers).response { response in
            guard let jsonData = response.data else {
                print("No data")
                completion(false)
                return
            }
            do {
                self.launchData = try JSONDecoder().decode([LaunchData].self, from: jsonData)
                self.fetchRocketData { success in
                    completion(success)
                }
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    func fetchRocketData(completion: @escaping(Bool) -> Void) {
        // Delete old data when reload list/collection view
        self.rocketData.removeAll()

        AF.request(Constants.URLs.rocketsUrl,
                   method: .get,
                   headers: Constants.headers).response { response in
            guard let jsonData = response.data else {
                print("No data")
                completion(false)
                return
            }
            do {
                self.rocketData = try JSONDecoder().decode([RocketData].self, from: jsonData)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
