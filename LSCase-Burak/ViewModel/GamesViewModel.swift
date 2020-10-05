//
//  GamesViewModel.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol GamesListViewModelProtocol: class {
    func didUpdateData()
}

class GamesListViewModel {
    weak var delegate: GamesListViewModelProtocol?
    var searchResult: [SearchResult?] = []
    var currentPage = 1
    var perPage: Int = 10
    var getSearchedText = String()
    
    var numberOfRows: Int {
        return searchResult.count
    }
    
    func getData() {
        let searchingUrl = "\(SEARCH_BASE_URL)&page=\(currentPage)&search=\(getSearchedText)"
        NetworkManager().performRequest(url: searchingUrl) {  [weak self] (response: NetworkResponse<GamesModel, NetworkError>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let result):
                self.searchResult = result.results
                self.delegate?.didUpdateData()
                break
            case .failure(let error):
                print(error.errorMessage)
            }
        }
    }
    
    func fetchNextPage() {
        currentPage += 1
        getData()
    }
    
    func cellForRow(at index: Int) -> SearchResult? {
        return searchResult[index]
    }
}
