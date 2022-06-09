//
//  RocketData.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 01.06.2022.
//

import Foundation

struct RocketData: Codable {
    let id: String
    let name: String
    let description: String?
    let height: Diameter
    let mass: Mass
    let engines: Engines
}

struct Diameter: Codable {
    let meters: Double
}

struct Mass: Codable {
    let kg: Int
}

struct Engines: Codable {
    let number: Int
    let type: String
    let version: String
}
