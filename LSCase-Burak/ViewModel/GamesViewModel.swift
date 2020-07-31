//
//  GamesViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol GamesListViewModelProtocol: class {
    func setData()
}

class GamesListViewModel {
    var url = "https://api.rawg.io/api/games?page_size=10&page=1"
    private var gamesData: GamesData?
    weak var delegate: GamesListViewModelProtocol?
    
    func getData() {
        WebService().performRequest(url: url, completion: { (games: GamesData) in
            self.gamesData = games
            self.delegate?.setData()
        }) { (error) in
        }
    }
    
    var numberOfRows: Int {
        return gamesData?.results.count ?? 0
    }
    
    func cellForRow(at index: Int) -> GamesViewModel? {
        if let game = self.gamesData?.results[index] {
            return GamesViewModel(game: game)
        }
        return nil
    }
}

class GamesViewModel {
    private let game: Results
    
    init(game: Results) {
        self.game = game
    }
    
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
