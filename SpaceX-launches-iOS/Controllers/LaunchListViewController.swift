//
//  ViewController.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import UIKit
import Combine

class LaunchListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var launchService = LaunchService()
    private var cancellable: Set<AnyCancellable> = []


    override func viewDidLoad() {
        super.viewDidLoad()
        launchService.fetchData()
        reloadCollectionView()
        registerCollectionView()
    }

    func registerCollectionView() {
        self.collectionView.register(
            UINib(nibName: "LaunchCell", bundle: nil),
            forCellWithReuseIdentifier: "launchCell"
        )
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    func reloadCollectionView(){
        launchService.$rocketData.sink { [weak self] data in
            if !data.isEmpty {
                self?.collectionView.reloadData()
            }
        }.store(in: &cancellable)
    }
}

extension LaunchListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.launchService.launchCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LaunchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "launchCell", for: indexPath) as! LaunchCell
        let launches = launchService.cellLaunchItem(for: indexPath.item)
        cell.setupCell(launchData: launches, rocketData: launchService.rocketData)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 50, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

