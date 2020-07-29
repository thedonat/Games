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
    
    var getGameID: Int?
    var gameDetailsViewModel: GameDetailsViewModel!
    let baseUrl = "https://api.rawg.io/api/games/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        if let gameID = getGameID {
            let detailsUrl = "\(baseUrl)\(gameID)"
            WebService().performRequest(url: detailsUrl) { (gameDetails: GameDetailsData) in
                self.gameDetailsViewModel = GameDetailsViewModel(game: gameDetails)
                DispatchQueue.main.async {
                    self.configureUI()
                    self.gameDetailsTableView.reloadData()
                }
            }
        }
    }
    
    func configureUI() {
        let vm = gameDetailsViewModel
        gameNameLabel.text = vm?.name
        gameTopImageView.image = UIImage(named: "kayak")
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
            cell.setView(descriptionTitle: "Game Description", description: vm?.description)
            return cell
        } else if indexPath.row == 1 {
            let cell = gameDetailsTableView.dequeueReusableCell(withIdentifier: "VisitRedditTableViewCell", for: indexPath) as! VisitRedditTableViewCell
            cell.textLabel?.text = "Visit Reddit"
            return cell
        } else {
            let cell = gameDetailsTableView.dequeueReusableCell(withIdentifier: "VisitWebsiteTableViewCell", for: indexPath) as! VisitWebsiteTableViewCell
            cell.textLabel?.text = "Visit Website"
            return cell
        }
    }
}


