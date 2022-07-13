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

    private var service = LaunchService()
    private var cancellables: Set<AnyCancellable> = []

    @Published private var error: String = ""
    @Published private var launchData: [LaunchData] = []
    @Published var searchText: String = ""

    var rocketData: [RocketData] = []
    var launchCount: Int? {
        launchData.count
    }

    func fetchData() {
        service.fetchLaunchData { [self] result in
            switch result {
            case .success((let resultLaunchData, let resultRocketData)):
                self.launchData = self.sortedSourceLaunchData(data: resultLaunchData)
                self.rocketData = resultRocketData
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
                    self.launchData = self.sortedSourceLaunchData(data: self.service.launchData)
                } else {
                    self.launchData = self.service.launchData.filter {
                        $0.name.lowercased().contains(searchText)
                    }
                }
            }.store(in: &cancellables)
    }

    func loadSortedData(sortBy: SortBy) {
        UserDefaultsProvider.set(key: .sort, value: sortBy.rawValue)
        self.launchData = sortedLaunchData(sortBy: sortBy)
    }

    func showErrorAlert(controller: UIViewController) {
        $error.sink { error in
            if !error.isEmpty {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                controller.present(alert, animated: true)
            }
        }.store(in: &cancellables)
    }

    func reloadCollectionView(collectionView: UICollectionView) {
        $launchData.sink { data in
            if !data.isEmpty {
                collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }

    func flightNumber(launchData: LaunchData) -> String {
        return "#\(launchData.flightNumber)"
    }

    func successColor(launchData: LaunchData) -> UIColor {
        guard let success = launchData.success else { return .gray }
        return success ? .green : .red
    }

    func successIcon(launchData: LaunchData) -> UIImage {
        guard let success = launchData.success else { return UIImage(systemName: Constants.Icons.questionmark) ?? UIImage() }
        let icon = success ? Constants.Icons.success : Constants.Icons.fail
        return UIImage(systemName: icon) ?? UIImage()
    }

    func linkPatchPicture(launchData: LaunchData) -> String {
        return launchData.links.patch?.small ?? ""
    }

    func date(launchData: LaunchData) -> String {
        return DateService.convertStringToDate(from: launchData.dateUtc) ?? ""
    }

    // MARK: Private

    private func sortedSourceLaunchData(data: [LaunchData]) -> [LaunchData] {
        let sortByRawValue = UserDefaultsProvider.string(key: .sort) ?? SortBy.lastDate.rawValue
        let sortBy = SortBy(rawValue: sortByRawValue) ?? SortBy.lastDate
        
        return sortedLaunchData(sourceData: data, sortBy: sortBy)
    }

    private func sortedLaunchData(sourceData: [LaunchData] = [], sortBy: SortBy) -> [LaunchData] {
        let dataForSort = sourceData.isEmpty ? launchData : sourceData

        switch sortBy {
        case .firstDate:
            return sortedByDate(data: dataForSort, fromFirst: true)
        case .lastDate:
            return sortedByDate(data: dataForSort, fromFirst: false)
        case .success:
            return sortedBySuccess(data: dataForSort, fromSuccess: true)
        case .fail:
            return sortedBySuccess(data: dataForSort, fromSuccess: false)
        case .name:
            return sortedByName(data: dataForSort)
        }
    }

    private func sortedByDate(data: [LaunchData], fromFirst: Bool) -> [LaunchData] {
        if fromFirst {
            return data.sorted { $0.dateUtc < $1.dateUtc }
        } else {
            return data.sorted { $0.dateUtc > $1.dateUtc }
        }
    }

    private func sortedBySuccess(data: [LaunchData], fromSuccess: Bool) -> [LaunchData] {
        // Sorted by last date for sort by success or fail launches
        let sortedDataByDate = sortedByDate(data: data, fromFirst: false)
        
        if fromSuccess {
            return sortedDataByDate.sorted { ($0.success ?? false) && !($1.success ?? true) }
        } else {
            return sortedDataByDate.sorted { !($0.success ?? true) && ($1.success ?? false) }
        }
    }

    private func sortedByName(data: [LaunchData]) -> [LaunchData] {
        return data.sorted { $0.name < $1.name }
    }
}
