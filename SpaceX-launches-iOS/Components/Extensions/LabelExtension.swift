//
//  UILabelExtension.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 08.06.2022.
//

import UIKit

extension UILabel {
    // For add icon inside label to right
    func addTrailing(image: UIImage, text: String, size: CGFloat = 17.0, imageColor: UIColor, imageBounds: CGRect? = nil) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.image = attachment.image?.withTintColor(imageColor)
        attachment.bounds = imageBounds ?? CGRect(x: 0, y: -3, width: size + 2, height: size + 2)

        attachment.image?.withTintColor(imageColor)

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])

        string.append(attachmentString)
        self.attributedText = string
    }
    // For add icon inside label to left
    func addLeading(image: UIImage, text: String, size: CGFloat = 17.0, imageColor: UIColor, imageBounds: CGRect? = nil) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.image = attachment.image?.withTintColor(imageColor)
        attachment.bounds = imageBounds ?? CGRect(x: 0, y: -3, width: size + 2, height: size + 2)

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)

        let string = NSMutableAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])

        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
}
