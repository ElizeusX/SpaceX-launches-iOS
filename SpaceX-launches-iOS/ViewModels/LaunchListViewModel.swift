//
//  LaunchListViewModel.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 04.06.2022.
//

import Foundation

final class LaunchListViewModel {

    let service = LaunchService.shared

    @Published var error: String = ""
    @Published var isDataLoaded: Bool = false

    var launchCount: Int? {
        service.launchData.count
    }

    func fetchData() {
        service.fetchLaunchData { [self] success in
            if success {
                isDataLoaded = true
            } else {
                error = "Something went wrong, unable to fetch data. Please, check internet connection and reload the app"
            }
        }
    }

    func cellLaunchItem(for row: Int) -> LaunchData {
        return service.launchData[row]
    }

    // Set rocket for current launch
    func cellCurrentRocket(launch: LaunchData) -> RocketData? {
        return service.rocketData.filter { $0.id == launch.rocket }.first
    }
}
