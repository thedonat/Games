//
//  GamesData.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

struct GamesData: Codable {
    let results: [Results]
}

struct Results: Codable {
    let name: String?
    let id: Int?
    let metacritic: Int?
    let background_image: String?
    let genres: [Genres]?
}

struct Genres: Codable {
    let name: String
}
