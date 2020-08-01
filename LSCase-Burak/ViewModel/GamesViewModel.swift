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
    var url = "https://api.rawg.io/api/games?page_size=10"
    weak var delegate: GamesListViewModelProtocol?
    var searchResult: [SearchResult?] = []
    var currentPage = 1
    var perPage: Int = 10
    var getSearchedText = String()
    var numberOfRows: Int {
        return searchResult.count
    }
    
    func getData() {
        let searchingUrl = "\(url)&page=\(currentPage)&search=\(getSearchedText)"
        print(searchingUrl)
        WebService().performRequest(url: searchingUrl, completion: { (games: GamesModel) in
            self.searchResult.append(contentsOf: games.results)
            self.delegate?.setData()
        }) { (error) in
        }
    }
    
    func fetchNextPage() {
        currentPage += 1
        getData()
    }
    
    func cellForRow(at index: Int) -> GamesViewModel? {
        if let game = self.searchResult[index] {
            return GamesViewModel(game: game)
        }
        return nil
    }
}

class GamesViewModel {
    private let game: SearchResult
    
    init(game: SearchResult) {
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
