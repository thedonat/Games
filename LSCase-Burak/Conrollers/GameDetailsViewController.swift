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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    
                    print(url)
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
