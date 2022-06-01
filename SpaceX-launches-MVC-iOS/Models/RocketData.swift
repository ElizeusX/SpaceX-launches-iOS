//
//  RocketData.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 01.06.2022.
//

import Foundation

struct RocketData: Codable {
    let id: String?
    let name: String?
    let description: String?
    let wikipedia: String?
    let height: Height?
    let mass: Mass?
    let engines: Engines?
}

struct Height: Codable {
    let meters: Double?
}

struct Mass: Codable {
    let kg: Double?
}

struct Engines: Codable {
    let number: Int?
    let type: String?
    let version: String?
}
