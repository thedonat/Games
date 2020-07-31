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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension FavouritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
