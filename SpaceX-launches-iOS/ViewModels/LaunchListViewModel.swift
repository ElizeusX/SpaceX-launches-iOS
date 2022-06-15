//
//  LaunchListViewModel.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 04.06.2022.
//

import Combine
import UIKit

enum SortBy: String {
    case firstDate = "firstDate"
    case lastDate = "lastDate"
    case success = "success"
    case fail = "fail"
    case name = "name"
}

final class LaunchListViewModel {

    var service = LaunchService()

    private var cancellable: Set<AnyCancellable> = []

    @Published var error: String = ""
    @Published var isDataLoaded: Bool = false
    @Published var searchText: String = ""
    @Published var launchData: [LaunchData] = []
    var rocketData: [RocketData] = []
    var launchCount: Int? {
        launchData.count
    }

    func fetchData() {
        service.fetchLaunchData { [self] result in
            switch result {
            case .success((let launchData, let rocketData)):
                self.launchData = launchData
                self.rocketData = rocketData
                self.sortLaunchData()
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

    func setupSearchTextObserver() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { $0.lowercased() }
            .sink { [weak self] (searchText) in
                guard let self = self else { return }

                if searchText.isEmpty {
                    self.launchData = self.service.launchData
                    self.sortLaunchData()
                } else {
                    self.launchData = self.service.launchData.filter {
                        ($0.name.lowercased().contains(searchText))
                    }
                }
            }.store(in: &cancellable)
    }

    func sortForLaunchData(sortBy: SortBy) {
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

    func sortLaunchData() {
        let sortByRawValue = UserDefaultsProvider.string(key: .sort) ?? SortBy.lastDate.rawValue
        let sortBy = SortBy(rawValue: sortByRawValue) ?? SortBy.lastDate
        sortForLaunchData(sortBy: sortBy)
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
