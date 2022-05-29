//
//  Launch.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 22.05.2022.
//

import Foundation

struct LaunchData: Codable {
    let id: String?
    let name: String?
    let success: Bool?
    let dateUtc: String?
    let flightNumber: Int?
    let webcast: String?    // Video
    let patch: Patch?
    let details: String?
    let rocket: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case success
        case dateUtc = "date_utc"
        case flightNumber = "flight_number"
        case webcast
        case patch
        case details
        case rocket
    }
}

struct Patch: Codable {
    let small: String?  // Picture
}

