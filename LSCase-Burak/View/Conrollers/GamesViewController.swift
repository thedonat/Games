//
//  GamesViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController{
    //MARK: -Properties
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    private var selectedGameIDs : [Int] = []
    private var gameListViewModel: GamesViewModel = GamesViewModel()
    private let defaults = UserDefaults.standard
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        prepareUI()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.set(selectedGameIDs, forKey: K.SELECTEDS_KEY)
    }
    //MARK: -Helpers
    private func prepareUI() {
        self.gamesTableView.tableFooterView = UIView() //Deleting separators between empty rows
        self.gamesTableView.keyboardDismissMode = .onDrag //Dismissing keyboard when user scroll down or tap on the tableview.
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        gamesTableView.isHidden = true
        if let selectedGames = defaults.value(forKey: K.SELECTEDS_KEY) as? [Int] {
            selectedGameIDs = selectedGames
        }
    }
    
    private func getData() {
        gameListViewModel.delegate = self
        gameListViewModel.getData()
    }
    
    private func configureUI() {
        if gameListViewModel.searchResult.count == 0 {
            self.gamesTableView.isHidden = true
            self.noDataLabel.isHidden = false
            self.noDataLabel.text = "No game has been searched."
            
        } else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.noDataLabel.isHidden = true
            self.gamesTableView.isHidden = false
        }
    }
}
//MARK: -UITableViewDataSource
extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameListViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell", for: indexPath) as! GamesTableViewCell
        let vm = self.gameListViewModel.cellForRow(at: indexPath.row)
        cell.setView(name: vm?.name,
                     matacritic: vm?.metacritic,
                     genre: vm?.genres,
                     imageUrl: vm?.background_image)
        if let selectedGameID = gameListViewModel.searchResult[indexPath.row]?.id {
            if selectedGameIDs.contains(selectedGameID) {
                cell.contentView.backgroundColor = UIColor(named: "selectedBackgroundColor")
            } else {
                cell.contentView.backgroundColor = .clear
            }
        }
        return cell
    }
}
//MARK: -UITableViewDelegate
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
                cell?.contentView.backgroundColor = UIColor(named: "selectedBackgroundColor")
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRow = gameListViewModel.numberOfRows
        if indexPath.row == totalRow - 1 {
            if totalRow % gameListViewModel.perPage == 0 {
                gameListViewModel.fetchNextPage()
            }
        }
    }
}

//MARK: -GamesListViewModelProtocol
extension GamesViewController: GamesViewModelProtocol {
    func didUpdateData() {
        DispatchQueue.main.async {
            self.configureUI()
            self.gamesTableView.reloadData()
        }
    }
}

//MARK: -UISearchBarDelegate
extension GamesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text  else {return}
        if searchText == "" {
            gameListViewModel.getSearchedText = ""
            gameListViewModel.currentPage = 1
            gameListViewModel.searchResult = []
            self.getData()
        } else if searchText.count > 3{
            gameListViewModel.currentPage = 1
            gameListViewModel.searchResult = []
            let searchedText = searchText.replacingOccurrences(of: " ", with: "+")
            gameListViewModel.getSearchedText = searchedText
            self.getData()
        }
    }
}
