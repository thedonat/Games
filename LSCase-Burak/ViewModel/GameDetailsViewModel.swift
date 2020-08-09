//
//  GameDetailsViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol GameDetailsViewModelProtocol: class {
    func didGetData()
}

class GameDetailsViewModel {
    private var game: GameDetailsModel?
    private let defaults = UserDefaults.standard
    weak var delegate: GameDetailsViewModelProtocol?
    var getGameID: Int?
    var favouritedGameIDs: [Int] = []
    
    init(game: GameDetailsModel? = nil) {
        self.game = game
    }
    
    func addFavourite(id: Int) {
        if let favouritedGameIDs = defaults.value(forKey: FAVOURITES_KEY) as? [Int] {
            self.favouritedGameIDs = favouritedGameIDs
        }
        if !favouritedGameIDs.contains(id) {
            favouritedGameIDs.append(id)
            defaults.set(favouritedGameIDs, forKey: FAVOURITES_KEY)
        } else {
            favouritedGameIDs = favouritedGameIDs.filter { $0 != gameID }
            defaults.set(favouritedGameIDs, forKey: FAVOURITES_KEY)
        }
    }

    func getData() {
        if let gameID = getGameID {
            let detailsUrl = "\(DETAILS_BASE_URL)\(gameID)"
            print(detailsUrl)
            WebService().performRequest(url: detailsUrl, completion: { (gameDetails: GameDetailsModel) in
                self.game = gameDetails
                self.delegate?.didGetData() //inform listeners that data has came.
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


