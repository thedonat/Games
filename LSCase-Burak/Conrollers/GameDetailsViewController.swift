//
//  GameDetailsViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    @IBOutlet weak var gameDetailsTableView: UITableView!
    @IBOutlet weak var gameTopImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    var gameDetailsViewModel: GameDetailsViewModel = GameDetailsViewModel()
    var gameListViewModel: GamesListViewModel = GamesListViewModel()
    var favouriteGameIDs: [Int?] = []
    var favGames: [GamesData?] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        retrieveData()
    }
    
    
    private func retrieveData() {
        gameDetailsViewModel.delegate = self
        gameDetailsViewModel.getData()
    }
    
    func configureUI() {
        gameNameLabel.text = gameDetailsViewModel.name
        gameTopImageView.image = UIImage(named: "kayak")
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.largeTitleDisplayMode = .never
        if let favouritedGameIDs = defaults.value(forKey: "selectedIds") as? [Int] {
            self.favouriteGameIDs = favouritedGameIDs
            if let favouritedGameID = gameDetailsViewModel.getGameID {
                if favouriteGameIDs.contains(favouritedGameID) {
                    navigationItem.rightBarButtonItem?.title = "Favourited"
                }
            }
        }
    }
     
    @objc func addTapped() {
        if let favouritedGameId = gameDetailsViewModel.getGameID {
            if !favouriteGameIDs.contains(favouritedGameId) {
                favouriteGameIDs.append(favouritedGameId)
                defaults.set(favouriteGameIDs, forKey: "selectedIds")
                navigationItem.rightBarButtonItem?.title = "Favourited"
            } else {
                favouriteGameIDs = favouriteGameIDs.filter { $0 != favouritedGameId }
                defaults.set(favouriteGameIDs, forKey: "selectedIds")
                navigationItem.rightBarButtonItem?.title = "Favourite"
            }
        }
    }
}

extension GameDetailsViewController: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = gameDetailsViewModel
        if indexPath.row == 0 {
            let cell = gameDetailsTableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            cell.setView(descriptionTitle: "Game Description", description: vm.description)
            return cell
        } else {
            let cell = gameDetailsTableView.dequeueReusableCell(withIdentifier: "VisitWebsiteTableViewCell", for: indexPath) as! VisitWebsiteTableViewCell
            if indexPath.row == 1 {
                cell.textLabel?.text = "Visit Reddit"
            } else {
                cell.textLabel?.text = "Visit Website"
            }
            return cell
        }
    }
}

extension GameDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let websiteUrl = self.gameDetailsViewModel.website,
                let url = URL(string: websiteUrl) {
                UIApplication.shared.open(url)
            }
        }
        if indexPath.row == 1 {
                if let redditUrl = self.gameDetailsViewModel.redditUrl,
                    let url = URL(string: redditUrl) {
                    UIApplication.shared.open(url)
            }
        }
    }
}

extension GameDetailsViewController: GameDetailsViewModelProtocol {
    func setData() {
        DispatchQueue.main.async {
            self.gameDetailsTableView.reloadData()
            self.configureUI()
        }
    }
}
