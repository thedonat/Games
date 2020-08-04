//
//  FavouritesViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 1.08.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol FavouritesViewModelProtocol: class {
    func getFavouritedData()
    func didFailWithError()
}

class FavouritesListViewModel {
     private var favouriteGameIDs: [Int] = [Int]()
     private let defaults = UserDefaults.standard
     var searchResult: [GameDetailsModel?] = []
     weak var delegate: FavouritesViewModelProtocol?
     var numberOfRows: Int {
         return searchResult.count
     }

     func getFavouritedGames() {
        self.searchResult = []
        if let favouriteGameIDs = defaults.value(forKey: "selectedIds") as? [Int] {
             for id in favouriteGameIDs {
                print(id)
                 let url = "https://api.rawg.io/api/games/\(id)"
                 WebService().performRequest(url: url, completion: { (gameDetails: GameDetailsModel) in
                    print(gameDetails)
                     self.searchResult.append(gameDetails)
                     self.delegate?.getFavouritedData()
                 }) { (error) in
                 }
             }
            self.delegate?.getFavouritedData()
        }
     }
    
    func cellForRow(at index: Int) -> FavouritesViewModel? {
        if let game = self.searchResult[index] {
            return FavouritesViewModel(game: game)
        }
        return nil
    }
    
    func deleteItem(at index: Int) {
        let id = self.searchResult[index]?.id
        if var favouritedGameIDs = defaults.value(forKey: "selectedIds") as? [Int] {
            favouritedGameIDs = favouritedGameIDs.filter { $0 != id }
            searchResult.remove(at: index)
            defaults.set(favouritedGameIDs, forKey: "selectedIds")
        }
    }
    
}

class FavouritesViewModel {
    private let game: GameDetailsModel
    init(game: GameDetailsModel) {
        self.game = game
    }
    
    var name: String? {
         return game.name
     }
    
    var metacritic: Int? {
        return game.metacritic
    }
    
    var background_image: String? {
        return game.background_image
    }
    
    var genreData: String {
        var genresString: String = ""
        if let genres = game.genres {
            for (index, genre) in genres.enumerated() {
                genresString += genre.name
                
                if index < genres.count - 1 {
                    genresString += ", "
                }
            }
        }
        return genresString
    }
}
