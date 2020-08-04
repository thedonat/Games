//
//  GamesTableViewCell.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit
import Kingfisher

class GamesTableViewCell: UITableViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameMetacriticLabel: UILabel!
    @IBOutlet weak var gameGenreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setView(name: String?, matacritic: Int?, genre: String?, imageUrl: String? ) {
        gameNameLabel.text = name
        gameGenreLabel.text = genre
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)
            gameImageView.kf.setImage(with: url)
        }
        if let meta = matacritic {
            let metacritic = "metacritic: \(meta)"
            setAttributedString(text: metacritic, range: "\(meta)")
            
        } else {
            gameMetacriticLabel.text = ""
        }
    }
    
    func setAttributedString(text: String, range: String) {
        let range = (text as NSString).range(of: range)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        self.gameMetacriticLabel.attributedText = attributedString
    }
}
