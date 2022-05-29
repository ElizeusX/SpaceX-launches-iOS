//
//  LaunchCell.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 29.05.2022.
//

import UIKit

class LaunchCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(launchData: LaunchData) {
        self.imageView.downloaded(from: launchData.links?.patch?.small ?? "")
        self.nameLabel.text = launchData.name
        
    }

}
