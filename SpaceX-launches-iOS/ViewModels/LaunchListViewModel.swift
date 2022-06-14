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
                self.loadSortedLaunchData()
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

    func sortedLaunchData(sortBy: SortBy) {
        switch sortBy {
        case .firstDate:
            sortByDate(fromFirst: true)
        case .lastDate:
            sortByDate(fromFirst: false)
        case .success:
            sortBySuccess(fromSuccess: true)
        case .fail:
            sortBySuccess(fromSuccess: false)
        case .name:
            sortByName()
        }
    }

    func loadSortedLaunchData() {
        let sortByRawValue = UserDefaultsProvider.string(key: .sort) ?? SortBy.lastDate.rawValue
        let sortBy = SortBy(rawValue: sortByRawValue) ?? SortBy.lastDate
        sortedLaunchData(sortBy: sortBy)
    }

    // MARK: - Private

    private func sortByDate(fromFirst: Bool) {
        if fromFirst {
             launchData.sort { $0.dateUtc < $1.dateUtc }
        } else {
             launchData.sort { $0.dateUtc > $1.dateUtc }
        }
    }

    private func sortBySuccess(fromSuccess: Bool) {
        sortByDate(fromFirst: false) // For sort by last date and success or fail launches
        if fromSuccess {
             launchData.sort { ($0.success ?? false) && !($1.success ?? true) }
        } else {
             launchData.sort { !($0.success ?? true) && ($1.success ?? false) }
        }
    }

    private func sortByName() {
         launchData.sort { $0.name < $1.name }
    }
}

// MARK: - Enum

enum SortBy: String {
    case firstDate = "firstDate"
    case lastDate = "lastDate"
    case success = "success"
    case fail = "fail"
    case name = "name"
}
