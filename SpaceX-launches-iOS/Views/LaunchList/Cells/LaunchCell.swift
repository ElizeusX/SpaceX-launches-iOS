//
//  LaunchCell.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 29.05.2022.
//

import UIKit

class LaunchCell: UICollectionViewCell {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var successIcon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var rocketLabel: UILabel!

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

    func setupCell(viewModel: LaunchListViewModel, indexPath: IndexPath) {
        let launch = viewModel.cellLaunchItem(for: indexPath.item)
        let rocket = viewModel.cellCurrentRocket(launch: launch)

        nameLabel.text = launch.name
        nameLabel.layer.leftLineForHeader()

        successIcon.image = viewModel.successIcon(launchData: launch)
        successIcon.tintColor = viewModel.successColor(launchData: launch)

        numberLabel.text = viewModel.flightNumber(launchData: launch)
        dateLabel.addLeading(
            image: UIImage(systemName: Constants.Icons.calendar) ?? UIImage(),
            text: viewModel.date(launchData: launch),
            size: 15,
            imageColor: .white
        )
        rocketLabel.text = rocket?.name.uppercased()
        imageView.downloaded(from: viewModel.linkPatchPicture(launchData: launch))
    }
}
