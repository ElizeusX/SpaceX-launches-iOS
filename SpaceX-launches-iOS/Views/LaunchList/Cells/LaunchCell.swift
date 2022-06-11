//
//  LaunchCell.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 29.05.2022.
//

import UIKit

class LaunchCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var successIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rocketLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }

    func setupCell(launchData: LaunchData, rocketData: RocketData?) {
        nameLabel.text = launchData.name
        nameLabel.layer.leftLineForHeader()

        successIcon.image = UIImage(systemName: setSuccessIcon(launchData: launchData))
        successIcon.tintColor = setSuccessColor(launchData: launchData)

        numberLabel.text = "#\(launchData.flightNumber)"
        dateLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.calendar) ?? UIImage(),
            text: DateService.convertStringToDate(from: launchData.dateUtc ) ?? "",
            size: 15,
            imageColor: .white
        )
        rocketLabel.text = rocketData?.name.uppercased()
        imageView.downloaded(from: launchData.links.patch?.small ?? "")
    }

    func setSuccessColor(launchData: LaunchData) -> UIColor {
        guard let success = launchData.success else { return .gray }
        return success ? .green : .red
    }

    func setSuccessIcon(launchData: LaunchData) -> String {
        guard let success = launchData.success else { return Constants.Icons.questionmark}
        return success ? Constants.Icons.success : Constants.Icons.fail
    }
}
