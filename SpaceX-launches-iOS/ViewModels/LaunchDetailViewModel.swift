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

    func successIcon() -> UIImage {
        guard let success = launchData?.success else { return UIImage(systemName: Constants.Icons.questionmark) ?? UIImage() }
        let icon = success ? Constants.Icons.success : Constants.Icons.fail
        return UIImage(systemName: icon) ?? UIImage()
    }

    func linkPatchPicture() -> String {
        return launchData?.links.patch?.small ?? ""
    }

    func flightNumber() -> String {
        guard let flightNumber = launchData?.flightNumber else { return String() }
        return "#\(flightNumber)"
    }

    func date() -> String {
        guard let date = launchData?.dateUtc else { return String() }
        return DateService.convertStringToDate(from: date) ?? ""
    }

    func rocektMeters() -> String {
        guard let meters = rocketData?.height.meters else { return String() }
        return "\(meters) m"
    }

    func rocektWeight() -> String {
        guard let weight = rocketData?.mass.kg else { return String() }
        return "\(weight) Kg"
    }

    func rocketEngineNumber() -> String {
        guard let enginesNumber = rocketData?.engines.number else { return String() }
        return "#\(enginesNumber)"
    }

}
