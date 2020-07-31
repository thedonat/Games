//
//  GamesTableViewCell.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {
    @IBOutlet weak var gameBackgroundImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameMetacriticLabel: UILabel!
    @IBOutlet weak var gameGenreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setView(name: String?, meta: Int?, genre: String?) {
        gameBackgroundImageView.image = UIImage(named: "kayak")
        gameNameLabel.text = name
        gameGenreLabel.text = genre
        
        if let meta = meta {
            gameMetacriticLabel.text = String(meta)
        } else {
            gameMetacriticLabel.text = ""
        }
    }
}
