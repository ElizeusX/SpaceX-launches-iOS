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
    let details: String?
    let rocket: String?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case success
        case dateUtc = "date_utc"
        case flightNumber = "flight_number"
        case details
        case rocket
        case links
    }
}

struct Links: Codable {
    let webcast: String?    // Video
    let patch: Patch?
}

struct Patch: Codable {
    let small: String?  // Picture
}

