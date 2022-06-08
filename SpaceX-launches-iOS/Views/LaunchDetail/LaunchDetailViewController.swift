//
//  LaunchDetailViewController.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 05.06.2022.
//

import UIKit

class LaunchDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    let viewModel = LaunchDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }

    func setupLabels() {
        guard let launchData = viewModel.launchData else { return }

        nameLabel.text = launchData.name
        numberLabel.text = "#\(launchData.flightNumber ?? 0)"
        successLabel.addLeading(
            image: UIImage(systemName: viewModel.successIcon()) ?? UIImage(),
            text: "Success",
            imageColor: viewModel.successColor()
        )
        dateLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.calendar) ?? UIImage(),
            text: DateService.convertStringToDate(from: launchData.dateUtc ?? "") ?? "",
            imageColor: .white
        )
        detailLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.info) ?? UIImage(),
            text: launchData.details ?? "",
            imageColor: .white
        )
        imageView.downloaded(from: launchData.links?.patch?.small ?? "")
    }
}
