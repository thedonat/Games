//
//  FavouritesViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var noFavouritesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var favouritesListViewModel: FavouritesListViewModel = FavouritesListViewModel()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //MARK: -Helpers
    private func getData() {
        favouritesListViewModel.delegate = self
        favouritesListViewModel.getFavouritedGames()
    }
    
    func prepareUI() {
        self.favouritesTableView.tableFooterView = UIView() //Deleting separators between empty rows
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        favouritesTableView.isHidden = true
        noFavouritesLabel.isHidden = true
    }
    
    private func configureUI() {
        if favouritesListViewModel.searchResult.count == 0 {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.noFavouritesLabel.isHidden = false
            self.favouritesTableView.isHidden = true
            self.noFavouritesLabel.text = "There is no favourites found"
            self.navigationItem.title = "Favourites"
        } else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.favouritesTableView.isHidden = false
            self.noFavouritesLabel.isHidden = true
            self.navigationItem.title = "Favourites (\(self.favouritesListViewModel.numberOfRows))"
        }
    }
}

//MARK: -UITableViewDataSource
extension FavouritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesListViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! GamesTableViewCell
        let vm = favouritesListViewModel.cellForRow(at: indexPath.row)
        cell.setView(name: vm?.name, matacritic: vm?.metacritic, genre: vm?.genres, imageUrl: vm?.background_image)
        return cell
    }
}

//MARK: -UITableViewDelegate
extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Ops!", message: "Do you want to remove it from favourited games?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction) in
                self.favouritesListViewModel.deleteFavouritedItem(from: indexPath.row)
                self.favouritesTableView.deleteRows(at: [indexPath], with: .fade)
                self.configureUI()
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction) in
                return
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: -FavouritesViewModelProtocol
extension FavouritesViewController: FavouritesViewModelProtocol {
    func didGetFavouritedData() {
        DispatchQueue.main.async {
            self.configureUI()
            self.favouritesTableView.reloadData()
        }
    }
}



