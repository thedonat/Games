//
//  GameDetailsViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

struct GameDetailsViewModel {
    let game: GameDetailsData
    
    var name: String {
        return game.name
    }
    
    var description: String {
        return game.description_raw
    }
    
    var redditUrl: String {
        return game.reddit_url
    }
    var website: String {
        return game.website
    }
}
