//
//  ViewController.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import UIKit

class LaunchListViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    private var viewModel = LaunchListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinner(spin: true)
        viewModel.fetchData()
        viewModel.setupSearchTextObserver()
        setupSearchBar()
        setupCollectionView()
        setupRefreshControl()
        viewModel.reloadCollectionView(collectionView: collectionView)
        viewModel.showErrorAlert(controller: self)
    }

    @IBAction private func sortButtonAction(_ sender: UIBarButtonItem) {
        self.presentActionSheet()
    }

    private func setupCollectionView() {
        let cellName = Constants.Cells.launchCell
        let nibName = (cellName.prefix(1).capitalized + cellName.dropFirst())
        self.collectionView.register(
            UINib(nibName: nibName, bundle: nil),
            forCellWithReuseIdentifier: cellName
        )
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh...")
        self.collectionView.refreshControl = refreshControl
    }

    @objc private func didPullToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.viewModel.fetchData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func segueToLaunchDetailView(launchData: LaunchData, rocketData: RocketData?) {
        let launchDetailVC = LaunchDetailViewController(nibName: "LaunchDetailViewController", bundle: nil)
        launchDetailVC.viewModel.launchData = launchData
        launchDetailVC.viewModel.rocketData = rocketData
        launchDetailVC.viewModel.picture = viewModel.pictures[launchData.links.patch?.small ?? ""]

        present(launchDetailVC, animated: true, completion: nil)
    }

    private func presentActionSheet() {
        let sortAlerActions = [
            UIAlertAction(title: "First date", style: .default) { _ in
                self.viewModel.loadSortedData(sortBy: SortBy.firstDate)
            },
            UIAlertAction(title: "Last date", style: .default) { _ in
                self.viewModel.loadSortedData(sortBy: SortBy.lastDate)
            },
            UIAlertAction(title: "Success", style: .default) { _ in
                self.viewModel.loadSortedData(sortBy: SortBy.success)
            },
            UIAlertAction(title: "Fail", style: .default) { _ in
                self.viewModel.loadSortedData(sortBy: SortBy.fail)
            },
            UIAlertAction(title: "Name", style: .default) { _ in
                self.viewModel.loadSortedData(sortBy: SortBy.name)
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

    private func startSpinner(spin: Bool) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !spin
            if (spin) {
                self.activityIndicator.startAnimating()
            }
            else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
//MARK: - UITableViewDataSource, UITableViewDelegate

extension LaunchListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.launchCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LaunchCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.launchCell, for: indexPath) as! LaunchCell
        let launch = viewModel.cellLaunchItem(for: indexPath.item)
        let rocket = viewModel.cellCurrentRocket(launch: launch)
        cell.setupCell(launchData: launch, rocketData: rocket)
        viewModel.setPictureByUrl(from: launch.links.patch?.small ?? "", imageView: cell.imageView)
        self.startSpinner(spin: false)

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

