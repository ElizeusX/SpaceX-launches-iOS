//
//  LaunchesService.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 25.05.2022.
//

import Foundation
import Combine
import Alamofire

class LaunchService {

    var launchData: [LaunchData] = []
    @Published var rocketData: [RocketData] = []

    var launchCount: Int? { launchData.count }

    func cellLaunchItem(for row: Int) -> LaunchData{
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
                self.fetchRocketData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func fetchRocketData() {
        // For remove duplicates ids
        let ids: [String] = Array(Set(launchData.map({ $0.rocket ?? String() })))
        // Delete old data when reload list/collection view
        self.rocketData.removeAll()

        for id in ids {
            var url: String {"\(Constants.URLs.rocketsUrl)/\(id)"}

            AF.request(url,
                       method: .get,
                       headers: Constants.headers).response { response in
                guard let jsonData = response.data else {
                    print("No data")
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(RocketData.self, from: jsonData)
                    self.rocketData += [decodedResponse]
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
