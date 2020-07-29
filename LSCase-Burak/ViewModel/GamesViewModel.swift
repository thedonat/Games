//
//  GamesViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

struct GamesListViewModel {
    let gameList: [Results]
    
    func numberOfRowsInSection() -> Int {
        return gameList.count
    }
    
    func cellForRowAt(_ index: Int) -> GamesViewModel {
        let game = self.gameList[index]
        return GamesViewModel(game: game)
    }
}

struct GamesViewModel {
    let game: Results
    
    var name: String? {
        return game.name
    }
    
    var id: Int? {
        return game.id
    }
    
    var metacritic: Int? {
        return game.metacritic
    }
    
    var background_image: String? {
        return game.background_image
    }
    
    var genres: [Genres]? {
        return game.genres
    }
}
