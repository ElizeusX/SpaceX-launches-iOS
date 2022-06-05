//
//  LaunchCell.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 29.05.2022.
//

import UIKit

class LaunchCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rocketLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(launchData: LaunchData, rocketData: RocketData?) {
        self.imageView.downloaded(from: launchData.links?.patch?.small ?? "")
        self.nameLabel.text = launchData.name
        self.dateLabel.text = DateService.convertStringToDate(from: launchData.dateUtc ?? "")
        self.rocketLabel.text = rocketData?.name

        if let success = launchData.success {
            self.successLabel.text = success ? "Success" : "Failure"
            self.successLabel.textColor = success ? .green : .red
        } else {
            self.successLabel.text = "Success"
            self.successLabel.textColor = .gray
        }
    }
}
