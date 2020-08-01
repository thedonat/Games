//
//  GamesViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController{
    
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var searchText: String = String()
    private var selectedGameIDs : [Int] = []
    private var gameListViewModel: GamesListViewModel = GamesListViewModel()
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        searchBar.delegate = self
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.set(selectedGameIDs, forKey: "selectedGameIDs")
    }
    
    private func configureUI() {
        self.gamesTableView.keyboardDismissMode = .onDrag //Dismissing keyboard when user scroll down or tap on the tableview.
        gamesTableView.isHidden = true
        if let selectedGames = defaults.value(forKey: "selectedGameIDs") as? [Int] {
            selectedGameIDs = selectedGames
        }
    }
    
    private func getData() {
        gameListViewModel.delegate = self
        gameListViewModel.getData()
    }
}

extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameListViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell", for: indexPath) as! GamesTableViewCell
        let vm = self.gameListViewModel.cellForRow(at: indexPath.row)
        cell.setView(name: vm?.name,
                     meta: vm?.metacritic,
                     genre: vm?.genreData,
                     imageUrl: vm?.background_image)
        if let selectedGameID = gameListViewModel.searchResult[indexPath.row]?.id {
            if selectedGameIDs.contains(selectedGameID) {
                cell.contentView.backgroundColor = .systemTeal
            } else {
                cell.contentView.backgroundColor = .clear
            }
        }
        return cell
    }
}

extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "GameDetailsViewController") as! GameDetailsViewController
        detailVC.gameDetailsViewModel.getGameID = self.gameListViewModel.cellForRow(at: indexPath.row)?.id
        navigationController?.pushViewController(detailVC, animated: true)
        
        if let selectedGameID = gameListViewModel.searchResult[indexPath.row]?.id {
            if !selectedGameIDs.contains(selectedGameID) {
                selectedGameIDs.append(selectedGameID)
                let cell = gamesTableView.cellForRow(at: indexPath)
                cell?.contentView.backgroundColor = .systemTeal
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRow = gameListViewModel.searchResult.count
        if indexPath.row == totalRow - 1 {
            if totalRow % gameListViewModel.perPage == 0 {
                gameListViewModel.fetchNextPage()
            }
        }
    }
}

extension GamesViewController: GamesListViewModelProtocol {
    func setData() {
        DispatchQueue.main.async {
            self.gamesTableView.isHidden = false
            self.gamesTableView.reloadData()
        }
    }
}

extension GamesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text  else {return}
        if searchText == "" {
            gameListViewModel.getSearchedText = ""
            gameListViewModel.currentPage = 1
            gameListViewModel.searchResult = []
            gameListViewModel.url = "https://api.rawg.io/api/games?page_size=10"
            self.getData()
            print("There is no text")
        } else {
            gameListViewModel.currentPage = 1
            gameListViewModel.searchResult = []
            let searchedText = searchText.replacingOccurrences(of: " ", with: "+")
            gameListViewModel.getSearchedText = searchedText
            self.getData()
            print(searchText)
        }
    }
}
