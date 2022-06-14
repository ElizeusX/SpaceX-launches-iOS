//
//  ViewController.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import UIKit

class LaunchListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var viewModel = LaunchListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData(collectionView: collectionView)
        viewModel.setupSearchTextObserver(collectionView: collectionView)
        registerCollectionView()
        setupSearchBar()
    }

    @IBAction private func sortButtonAction(_ sender: UIBarButtonItem) {
        self.presentActionSheet()
    }

    func registerCollectionView() {
        self.collectionView.register(
            UINib(nibName: "LaunchCell", bundle: nil),
            forCellWithReuseIdentifier: "launchCell"
        )
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    func segueToLaunchDetailView(launchData: LaunchData, rocketData: RocketData?) {
        let launchDetailVC = LaunchDetailViewController(nibName: "LaunchDetailViewController", bundle: nil)
        launchDetailVC.viewModel.launchData = launchData
        launchDetailVC.viewModel.rocketData = rocketData

        present(launchDetailVC, animated: true, completion: nil)
    }

    func presentActionSheet() {
        // TODO: Sort
//        let dictionary = [
//            SortBy.firstDate: "First date",
//            SortBy.lastDate: "Last date",
//            SortBy.success: "Success",
//            SortBy.fail: "Fail",
//            SortBy.name: "Name"
//        ]
//
//        let dictionaryWithIndex = dictionary.enumerated()
//        var alertActions: [Int:UIAlertAction] = [:]
//
//        for (index, action) in dictionaryWithIndex {
//            alertActions[index] = UIAlertAction(title: action.value, style: .default) { _ in
//                self.viewModel.sortedLaunchData(sortBy: action.key)
//                UserDefaultsProvider.set(key: .sort, value: action.key.rawValue)
//                self.collectionView.reloadData()
//            }
//
//            self.viewModel.showCurrentChoiceSort(action: action.key, alertAction: alertActions[index])
//        }
//        arrayTest.append(UIAlertAction(title: "Cancel", style: .cancel))

        let sortAlerActions = [
            UIAlertAction(title: "First date", style: .default) { _ in
                UserDefaultsProvider.set(key: .sort, value: SortBy.firstDate.rawValue)
                self.viewModel.sortedLaunchData(sortBy: SortBy.firstDate)
                self.collectionView.reloadData()
            },
            UIAlertAction(title: "Last date", style: .default) { _ in
                UserDefaultsProvider.set(key: .sort, value: SortBy.lastDate.rawValue)
                self.viewModel.sortedLaunchData(sortBy: SortBy.lastDate)
                self.collectionView.reloadData()
            },
            UIAlertAction(title: "Success", style: .default) { _ in
                UserDefaultsProvider.set(key: .sort, value: SortBy.success.rawValue)
                self.viewModel.sortedLaunchData(sortBy: SortBy.success)
                self.collectionView.reloadData()
            },
            UIAlertAction(title: "Fail", style: .default) { _ in
                UserDefaultsProvider.set(key: .sort, value: SortBy.fail.rawValue)
                self.viewModel.sortedLaunchData(sortBy: SortBy.fail)
                self.collectionView.reloadData()
            },
            UIAlertAction(title: "Name", style: .default) { _ in
                UserDefaultsProvider.set(key: .sort, value: SortBy.name.rawValue)
                self.viewModel.sortedLaunchData(sortBy: SortBy.name)
                self.collectionView.reloadData()
            }
        ]
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = UIAlertController(title: "Sort launches by",
                                      message: "",
                                      preferredStyle: .actionSheet)

        alert.addAction(cancel)

        for action in sortAlerActions {
            alert.addAction(action)
        }

        self.present(alert, animated: true)
    }
}
//MARK: - UITableViewDataSource, UITableViewDelegate

extension LaunchListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.launchCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LaunchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "launchCell", for: indexPath) as! LaunchCell
        let launch = viewModel.cellLaunchItem(for: indexPath.item)
        let rocket = viewModel.cellCurrentRocket(launch: launch)
        cell.setupCell(launchData: launch, rocketData: rocket)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = UIDevice.current.orientation.isLandscape ? 80.0 : 20.0
        return CGSize(width: UIScreen.main.bounds.width - padding, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launch = viewModel.cellLaunchItem(for: indexPath.item)
        let rocket = viewModel.cellCurrentRocket(launch: launch)
        segueToLaunchDetailView(launchData: launch, rocketData: rocket)
    }
}

//MARK: - UISearchResultsUpdating

extension LaunchListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

