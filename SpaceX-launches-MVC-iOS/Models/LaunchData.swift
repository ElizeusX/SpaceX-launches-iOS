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
    let date_utc: String?
    let flight_number: Int?
    let webcast: String?    // Video
    let patch: Patch?
    let details: String?
    let rocket: String?
}

struct Patch: Codable {
    let small: String?  // Picture
}

