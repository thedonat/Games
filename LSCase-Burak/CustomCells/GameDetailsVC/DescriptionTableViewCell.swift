//
//  DescriptionTableViewCell.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 29.07.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setView(descriptionTitle: String, description: String?) {
        descriptionTitleLabel.text = descriptionTitle
        descriptionLabel.text = description
    }
    @IBAction func readMoreTapped(_ sender: UIButton) {
        descriptionLabel.numberOfLines = 0
    }
}
