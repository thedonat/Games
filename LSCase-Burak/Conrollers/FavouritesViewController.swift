//
//  FavouritesViewController.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    private var favouritesListViewModel: FavouritesListViewModel = FavouritesListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        favouritesListViewModel.delegate = self
        favouritesListViewModel.getFavouritedGames()
    }
}

extension FavouritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesListViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! GamesTableViewCell
        let vm = favouritesListViewModel.cellForRow(at: indexPath.row)
        cell.setView(name: vm?.name, meta: vm?.metacritic, genre: vm?.genreData, imageUrl: vm?.background_image)
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouritesTableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
}

extension FavouritesViewController: FavouritesViewModelProtocol {
    func getFavouritedData() {
        DispatchQueue.main.async {
            self.favouritesTableView.reloadData()
        }
    }
}



