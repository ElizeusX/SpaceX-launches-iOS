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

    enum NetworkError: Error {
        case error(message: String)
    }

    func fetchLaunchData(completion: @escaping(Result<([LaunchData], [RocketData]), NetworkError>) -> Void) {
        AF.request(Constants.URLs.launchesUrl,
                   method: .get,
                   headers: Constants.headers).response { response in
            guard let jsonData = response.data else {
                completion(.failure(NetworkError.error(message: "No data")))
                return
            }
            do {
                self.launchData = try JSONDecoder().decode([LaunchData].self, from: jsonData)
                self.fetchRocketData { [self] result in
                    switch result {
                    case .success(let rocketData):
                        completion(.success((self.launchData, rocketData)))
                    case .failure(let error):
                        switch error {
                        case let .error(message: message):
                            completion(.failure(NetworkError.error(message: message)))
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
                completion(.failure(NetworkError.error(message: error.localizedDescription)))
            }
        }
    }

    func fetchRocketData(completion: @escaping(Result<[RocketData], NetworkError>) -> Void) {
        AF.request(Constants.URLs.rocketsUrl,
                   method: .get,
                   headers: Constants.headers).response { response in
            guard let jsonData = response.data else {
                completion(.failure(NetworkError.error(message: "No data")))
                return
            }
            do {
                let rocketData = try JSONDecoder().decode([RocketData].self, from: jsonData)
                completion(.success(rocketData))
            } catch {
                print(error.localizedDescription)
                completion(.failure(NetworkError.error(message: error.localizedDescription)))
            }
        }
    }
}
