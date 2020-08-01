//
//  GameDetailsData.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

struct GameDetailsModel: Decodable {
    let id: Int?
    let name: String?
    let description_raw: String?
    let background_image: String?
    let reddit_url: String?
    let website: String?
    let metacritic: Int?
    let genres: [Genres]?
}
