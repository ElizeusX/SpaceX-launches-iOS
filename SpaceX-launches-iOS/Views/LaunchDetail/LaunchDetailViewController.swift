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

        numberLabel.text = viewModel.flightNumber()
        successLabel.addLeading(
            image: viewModel.successIcon(),
            text: "Success",
            imageColor: viewModel.successColor()
        )
        dateLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.calendar) ?? UIImage(),
            text: viewModel.date(),
            imageColor: .white
        )
        if let detail = launchData.details {
            detailLabel.addLeading(
                image: UIImage(systemName: Constants.Icons.info) ?? UIImage(),
                text: detail,
                imageColor: .white
            )
        } else {
            detailLabel.isHidden = true
        }
        imageView.downloaded(from: viewModel.linkPatchPicture())
    }

    private func setupRocketLabels() {
        guard let rocketData = viewModel.rocketData else { return }
        rocketHeaderLabel.text = "Rocket"
        rocketHeaderLabel.layer.leftLineForHeader()

        rocketNameLabel.text = rocketData.name
        rocketHeightLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.height) ?? UIImage(),
            text: viewModel.rocektMeters(),
            imageColor: .white)
        rocketMassLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.mass) ?? UIImage(),
            text: viewModel.rocektWeight(),
            imageColor: .white)
        if let detail = rocketData.description {
            rocketDetailLabel.addLeading(
                image: UIImage(systemName: Constants.Icons.info) ?? UIImage(),
                text: detail,
                imageColor: .white)
        } else {
            rocketDetailLabel.isHidden = true
        }
        engineNumberLabel.text = viewModel.rocketEngineNumber()
        engineType.text = rocketData.engines.type
        engineVersion.text = rocketData.engines.version
    }
}
