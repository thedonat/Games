//
//  GameDetailsViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol GameDetailsViewModelProtocol: class {
    func setData()
}

class GameDetailsViewModel {
    var game: GameDetailsModel?
    var getGameID: Int?
    let baseUrl = "https://api.rawg.io/api/games/"
    weak var delegate: GameDetailsViewModelProtocol?
    private let defaults = UserDefaults.standard
    var favouriteGameIDs: [Int] = [Int]()
    
    init(game: GameDetailsModel? = nil) {
        self.game = game
    }
    
    func addFavourite(id: Int) {
        if var favGames = defaults.value(forKey: "selectedIds") as? [Int] {
            if !favGames.contains(id) {
                favGames.append(id)
                defaults.set(favGames, forKey: "selectedIds")
            } else {
                favGames = favGames.filter { $0 != gameID }
                defaults.set(favGames, forKey: "selectedIds")
            }
        }
    }

    func getData() {
        if let gameID = getGameID {
            let detailsUrl = "\(baseUrl)\(gameID)"
            WebService().performRequest(url: detailsUrl, completion: { (gameDetails: GameDetailsModel) in
                self.game = gameDetails
                self.delegate?.setData() //inform listeners that data has came.
            }) { (error) in
                
            }
        }
    }
    
    var name: String? {
        return game?.name
    }
    
    var gameID: Int? {
        return game?.id
    }
    
    var description: String? {
        return game?.description_raw
    }
    
    var background_image: String? {
        return game?.background_image
    }
    
    var redditUrl: String? {
        return game?.reddit_url
    }
    var website: String? {
        return game?.website
    }
    var metacritic: Int? {
        return game?.metacritic
    }
}


