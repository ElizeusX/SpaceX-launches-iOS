//
//  LaunchListViewModel.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 04.06.2022.
//

import Combine
import UIKit

final class LaunchListViewModel {

    var service = LaunchService.shared

    private var cancellable: Set<AnyCancellable> = []

    @Published var launchData: [LaunchData] = []
    @Published var error: String = ""
    @Published var isDataLoaded: Bool = false
    @Published var searchText: String = ""

    var launchCount: Int? {
        launchData.count
    }

    func fetchData(collectionView: UICollectionView) {
        service.fetchLaunchData { [self] success in
            if success {
                launchData = service.launchData
                isDataLoaded = true
                collectionView.reloadData()
            } else {
                // TODO: Display error for user
                error = "Something went wrong, unable to fetch data. Please, check internet connection and reload the app"
            }
        }
    }

    func cellLaunchItem(for row: Int) -> LaunchData {
        return launchData[row]
    }

    // Set rocket for current launch
    func cellCurrentRocket(launch: LaunchData) -> RocketData? {
        return service.rocketData.filter { $0.id == launch.rocket }.first
    }

    func setupSearchTextObserver(collectionView: UICollectionView) {
         $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { $0.lowercased() }
            .sink { [weak self] (searchText) in
                guard let self = self else { return }

                if searchText.isEmpty {
                    self.launchData = self.service.launchData
                    collectionView.reloadData()
                } else {
                    self.launchData = self.service.launchData.filter {
                        ($0.name!.lowercased().contains(searchText))
                    }
                    collectionView.reloadData()
                }
            }.store(in: &cancellable)
    }
}
