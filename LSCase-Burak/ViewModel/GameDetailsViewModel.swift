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
    var game: GameDetailsModel? = nil
    private let defaults = UserDefaults.standard
    weak var delegate: GameDetailsViewModelProtocol?
    var getGameID: Int?
    var favouritedGameIDs: [Int] = []

    
    func addFavourite(id: Int) {
        if let favouritedGameIDs = defaults.value(forKey: K.FAVOURITES_KEY) as? [Int] {
            self.favouritedGameIDs = favouritedGameIDs
        }
        if !favouritedGameIDs.contains(id) {
            favouritedGameIDs.append(id)
            defaults.set(favouritedGameIDs, forKey: K.FAVOURITES_KEY)
        } else {
            favouritedGameIDs = favouritedGameIDs.filter { $0 != game?.id }
            defaults.set(favouritedGameIDs, forKey: K.FAVOURITES_KEY)
        }
    }

    func getData() {
        if let gameID = getGameID {
            let detailsUrl = "\(K.DETAILS_BASE_URL)\(gameID)"
            NetworkManager().performRequest(url: detailsUrl) { [weak self] (response: NetworkResponse<GameDetailsModel, NetworkError>) in
                guard let self = self else { return }
                
                switch response {
                case .success(let result):
                    self.game = result
                    self.delegate?.didGetData()
                    break
                case .failure(let error):
                    print(error.errorMessage)
                }
            }
        }
    }
}
