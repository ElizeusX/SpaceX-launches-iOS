//
//  LaunchDetailViewModel.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 05.06.2022.
//

import Foundation
import UIKit

class LaunchDetailViewModel {

    var launchData: LaunchData?
    var rocketData: RocketData?
    var picture: UIImageView?

    func successColor() -> UIColor {
        guard let success = launchData?.success else { return .gray }
        return success ? .green : .red
    }

    func successIcon() -> String {
        guard let success = launchData?.success else { return Constants.Icons.questionmark}
        return success ? Constants.Icons.success : Constants.Icons.fail
    }

    func linkPatchPicture() -> String {
        return launchData?.links.patch?.small ?? ""
    }
}
