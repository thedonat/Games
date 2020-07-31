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
    private var game: GameDetailsData?
    var getGameID: Int?
    let baseUrl = "https://api.rawg.io/api/games/"
    weak var delegate: GameDetailsViewModelProtocol?
    
    init(game: GameDetailsData? = nil) {
        self.game = game
    }
    
    func getData() {
        if let gameID = getGameID {
          let detailsUrl = "\(baseUrl)\(gameID)"
          
          WebService().performRequest(url: detailsUrl, completion: { (gameDetails: GameDetailsData) in
              self.game = gameDetails
              self.delegate?.setData() //inform listeners that data has came.
          }) { (error) in
              
          }
        }
    }
    
    var name: String? {
        return game?.name
    }
    
    var description: String? {
        return game?.description_raw
    }
    
    var redditUrl: String? {
        return game?.reddit_url
    }
    var website: String? {
        return game?.website
    }
}


