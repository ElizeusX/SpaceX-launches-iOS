//
//  ViewController.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import UIKit
import Combine

class LaunchListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    private var launchService = LaunchService()
    private var launchDataSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        launchService.fetchData()
        reloadCollectionView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.launchDataSubscriber?.cancel()
    }

    func reloadCollectionView(){
        self.launchDataSubscriber = launchService.$launchData.sink { data in
            if !data.isEmpty {
                self.collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.launchService.launchCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LaunchCellView = collectionView.dequeueReusableCell(withReuseIdentifier: "launchCell", for: indexPath) as! LaunchCellView
        // (For test) TODO: correctly display cell
        cell.NameLabel?.text = launchService.cellItem(for: indexPath.row).name

        return cell
    }
}

