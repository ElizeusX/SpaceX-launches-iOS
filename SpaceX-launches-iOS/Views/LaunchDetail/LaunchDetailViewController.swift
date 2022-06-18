//
//  LaunchDetailViewController.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 05.06.2022.
//

import UIKit

class LaunchDetailViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var successLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var rocketHeaderLabel: UILabel!
    @IBOutlet private weak var rocketNameLabel: UILabel!
    @IBOutlet private weak var rocketHeightLabel: UILabel!
    @IBOutlet private weak var rocketMassLabel: UILabel!
    @IBOutlet private weak var rocketDetailLabel: UILabel!
    @IBOutlet private weak var engineNumberLabel: UILabel!
    @IBOutlet private weak var engineType: UILabel!
    @IBOutlet private weak var engineVersion: UILabel!


    let viewModel = LaunchDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchLabelsAndImages()
        setupRocketLabels()
    }

    @IBAction private func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupLaunchLabelsAndImages() {
        guard let launchData = viewModel.launchData else { return }

        nameLabel.text = launchData.name
        nameLabel.layer.leftLineForHeader()

        numberLabel.text = "#\(launchData.flightNumber)"
        successLabel.addLeading(
            image: UIImage(systemName: viewModel.successIcon()) ?? UIImage(),
            text: "Success",
            imageColor: viewModel.successColor()
        )
        dateLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.calendar) ?? UIImage(),
            text: DateService.convertStringToDate(from: launchData.dateUtc ) ?? "",
            imageColor: .white
        )
        detailLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.info) ?? UIImage(),
            text: launchData.details ?? "",
            imageColor: .white
        )
        imageView.downloaded(from: launchData.links.patch?.small ?? "")
    }

    private func setupRocketLabels() {
        guard let rocketData = viewModel.rocketData else { return }
        rocketHeaderLabel.text = "Rocket"
        rocketHeaderLabel.layer.leftLineForHeader()

        rocketNameLabel.text = rocketData.name
        rocketHeightLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.height) ?? UIImage(),
            text: "\(rocketData.height.meters) m",
            imageColor: .white)
        rocketMassLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.mass) ?? UIImage(),
            text: "\(rocketData.mass.kg) Kg",
            imageColor: .white)
        rocketDetailLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.info) ?? UIImage(),
            text: rocketData.description ?? "",
            imageColor: .white)
        engineNumberLabel.text = "#\(rocketData.engines.number)"
        engineType.text = rocketData.engines.type
        engineVersion.text = rocketData.engines.version
    }
}
