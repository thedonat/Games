//
//  FavouritesViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 1.08.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol FavouritesViewModelProtocol: class {
    func didGetFavouritedData()
}

class FavouritesViewModel {
    weak var delegate: FavouritesViewModelProtocol?
    private let defaults = UserDefaults.standard
    var searchResult: [GameDetailsModel?] = []
    
    var numberOfRows: Int {
        return searchResult.count
    }
    
    func getFavouritedGames() {
        self.searchResult = []
        if let favouritedGameIDs = defaults.value(forKey: K.FAVOURITES_KEY) as? [Int] {
            for id in favouritedGameIDs {
                let url = "\(K.DETAILS_BASE_URL)\(id)"
                NetworkManager().performRequest(url: url) { [weak self] (response: NetworkResponse<GameDetailsModel, NetworkError>) in
                    guard let self = self else { return }
                    
                    switch response {
                    case .success(let result):
                        self.searchResult.append(result)
                        self.delegate?.didGetFavouritedData()
                        break
                    case .failure(let error):
                        print(error.errorMessage)
                        self.delegate?.didGetFavouritedData()
                    }
                }
            }
            self.delegate?.didGetFavouritedData()
        } else {
            self.delegate?.didGetFavouritedData()
        }
    }
    
    func cellForRow(at index: Int) -> GameDetailsModel? {
        return searchResult[index]
    }
    
    func deleteFavouritedItem(from index: Int) {
        let gameID = self.searchResult[index]?.id
        if var favouritedGameIDs = defaults.value(forKey: K.FAVOURITES_KEY) as? [Int] {
            favouritedGameIDs = favouritedGameIDs.filter { $0 != gameID }
            searchResult.remove(at: index)
            defaults.set(favouritedGameIDs, forKey: K.FAVOURITES_KEY)
        }
    }
}
