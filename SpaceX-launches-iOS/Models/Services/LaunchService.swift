//
//  LaunchesService.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 25.05.2022.
//

import Foundation
import Alamofire

final class LaunchService {

    static let shared = LaunchService()

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
        // For remove duplicates ids
        let ids: [String] = Array(Set(launchData.map({ $0.rocket })))
        var isLoopEnd: Bool {
            ids.count == self.rocketData.count
        }

        for id in ids {
            var url: String {"\(Constants.URLs.rocketsUrl)/\(id)"}

            AF.request(url,
                       method: .get,
                       headers: Constants.headers).response { response in
                guard let jsonData = response.data else {
                    print("No data")
                    completion(false)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(RocketData.self, from: jsonData)
                    self.rocketData += [decodedResponse]
                    if isLoopEnd {
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
}
