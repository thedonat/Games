//
//  GamesViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {

    @IBOutlet weak var gamesTableView: UITableView!
    let url = "https://api.rawg.io/api/games?page=2&page_size=10&search=gtav"
    var gameListViewModel: GamesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        WebService().performRequest(url: url) { (games: GamesData) in
            self.gameListViewModel = GamesListViewModel(gameList: games.results)
            DispatchQueue.main.async {
                self.gamesTableView.reloadData()
            }
        }
    }
}


extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameListViewModel == nil ? 0 : self.gameListViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTableView.dequeueReusableCell(withIdentifier: "GamesTableViewCell", for: indexPath) as! GamesTableViewCell
        let vm = self.gameListViewModel.cellForRowAt(indexPath.row)
        if let name = vm.name, let metacritic = vm.metacritic, let genre = vm.genres {
            cell.gameNameLabel.text = name
            cell.gameMetacriticLabel.text = "metacritic: \(metacritic)"
            cell.gameGenreLabel.text = genre[0].name
            cell.gameBackgroundImageView.image = UIImage(named: "kayak")
        }
        return cell
    }
}

extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}
