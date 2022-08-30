//
//  CitiesModel.swift
//  city-list
//
//  Created by ahmed osama on 29/08/2022.
//

import Foundation

struct Cities: Codable {
    let country, name, id: String
    let coord: Coord

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}

// MARK: - Coord
 struct Coord: Codable {
    let lat, lon: String
}
