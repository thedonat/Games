//
//  GameDetailsViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit
import Kingfisher


class GameDetailsViewController: UIViewController {
    //MARK: -Properties
    @IBOutlet weak var gameDetailsTableView: UITableView!
    @IBOutlet weak var gameTopImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gradientView: UIView!
    var gameDetailsViewModel: GameDetailsViewModel = GameDetailsViewModel()
    private let defaults = UserDefaults.standard
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameDetailsTableView.tableFooterView = UIView() //Deleting separators between empty rows
        prepareUI()
        setNavigationBar()
        retrieveData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }
    //MARK: -Helpers
    func prepareUI() {
        gameDetailsTableView.isHidden = true
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.startAnimating()
    }
    
    private func retrieveData() {
        gameDetailsViewModel.delegate = self
        gameDetailsViewModel.getData()
    }
    
    func configureUI() {
        configureGradientView()
        gradientView.isHidden = false
        gameNameLabel.text = gameDetailsViewModel.name
        if let imageUrl = gameDetailsViewModel.background_image {
            let url = URL(string: imageUrl)
            gameTopImageView.kf.setImage(with: url)
        }
    }
    
    func configureGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        
        let startLocation = 1.2
        gradient.startPoint = CGPoint(x: 0.5, y: startLocation)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.layer.mask = gradient
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(addFavouriteTapped))
        self.navigationItem.largeTitleDisplayMode = .never
        if let favouritedGameIDs = defaults.value(forKey: FAVOURITES_KEY) as? [Int] {
            if let favouritedGameID = gameDetailsViewModel.getGameID {
                if favouritedGameIDs.contains(favouritedGameID) {
                    navigationItem.rightBarButtonItem?.title = "Favourited"
                }
            }
        }
    }
    
    @objc func addFavouriteTapped() {
        if let favouritedGameId = gameDetailsViewModel.getGameID {
            gameDetailsViewModel.addFavourite(id: favouritedGameId)
            if navigationItem.rightBarButtonItem?.title == "Favourited"{
                navigationItem.rightBarButtonItem?.title = "Favourite"
            } else {
                navigationItem.rightBarButtonItem?.title = "Favourited"
            }
        }
    }
}
//MARK: -UITableViewDataSource
extension GameDetailsViewController: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = gameDetailsViewModel
        if indexPath.row == 0 {
            let cell = gameDetailsTableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            cell.setView(descriptionTitle: "Game Description",
                         description: vm.description)
            return cell
        } else {
            let cell = gameDetailsTableView.dequeueReusableCell(withIdentifier: "VisitWebsiteTableViewCell", for: indexPath) as! VisitLinksTableViewCell
            if indexPath.row == 1 {
                cell.textLabel?.text = "Visit Reddit"
            } else {
                cell.textLabel?.text = "Visit Website"
            }
            return cell
        }
    }
}
//MARK: -UITableViewDelegate
extension GameDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if self.gameDetailsViewModel.website == ""{
                self.displayAlert()
            }
            else {
                if let websiteUrl = self.gameDetailsViewModel.website,
                    let url = URL(string: websiteUrl) {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        if indexPath.row == 1 {
            if self.gameDetailsViewModel.redditUrl == ""{
                self.displayAlert()
            }
            else {
                if let redditUrl = self.gameDetailsViewModel.redditUrl,
                    let url = URL(string: redditUrl) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
//MARK: -GameDetailsViewModelProtocol
extension GameDetailsViewController: GameDetailsViewModelProtocol {
    func didGetData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.gameDetailsTableView.isHidden = false
            self.gameDetailsTableView.reloadData()
            self.configureUI()
        }
    }
}


