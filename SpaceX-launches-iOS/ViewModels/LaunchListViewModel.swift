//
//  LaunchListViewModel.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 04.06.2022.
//

import Combine
import UIKit

final class LaunchListViewModel {

    var service = LaunchService()

    private var cancellable: Set<AnyCancellable> = []

     var launchData: [LaunchData] = []
     var rocketData: [RocketData] = []

    @Published var error: String = ""
    @Published var isDataLoaded: Bool = false
    @Published var searchText: String = ""

    var launchCount: Int? {
        launchData.count
    }

    func fetchData(collectionView: UICollectionView) {
        service.fetchLaunchData { [self] result in
            switch result {
            case .success((let launchData, let rocketData)):
                self.launchData = launchData
                self.rocketData = rocketData
                collectionView.reloadData()
            case .failure(let error):
                switch error {
                case let .error(message: message):
                    self.error = message
                }
            }
        }
    }

    func cellLaunchItem(for row: Int) -> LaunchData {
        return launchData[row]
    }

    // Set rocket for current launch
    func cellCurrentRocket(launch: LaunchData) -> RocketData? {
        return self.rocketData.filter { $0.id == launch.rocket }.first
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
                        ($0.name.lowercased().contains(searchText))
                    }
                    collectionView.reloadData()
                }
            }.store(in: &cancellable)
    }
}
