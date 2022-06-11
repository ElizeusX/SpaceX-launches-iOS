//
//  CALayer.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 10.06.2022.
//

import UIKit

extension CALayer {

    func leftLineForHeader(color: UIColor? = UIColor(named: Constants.Colors.paleOrange), thickness: CGFloat = 4, cornerRadius: CGFloat = 2) {

        let border = CALayer()
        border.cornerRadius = cornerRadius
        border.frame = CGRect(x: -6, y: 0, width: thickness, height: self.frame.height)
        border.backgroundColor = color?.cgColor

        self.addSublayer(border)
    }
}
