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
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.downloaded(from: viewModel.launchData?.links.patch?.small ?? "")
        }
    }
    @IBOutlet weak var rocketHeaderLabel: UILabel!
    @IBOutlet weak var rocketNameLabel: UILabel!
    @IBOutlet weak var rocketHeightLabel: UILabel!
    @IBOutlet weak var rocketMassLabel: UILabel!
    @IBOutlet weak var rocketDetailLabel: UILabel!
    @IBOutlet weak var engineNumberLabel: UILabel!
    @IBOutlet weak var engineType: UILabel!
    @IBOutlet weak var engineVersion: UILabel!


    let viewModel = LaunchDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchLabels()
        setupRocketLabels()
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func setupLaunchLabels() {
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
    }

    func setupRocketLabels() {
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
