//
//  GameDetailsData.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

struct GameDetailsData: Decodable {
    let id: Int
    let name: String
    let description_raw: String
    let reddit_url: String
    let website: String
}
