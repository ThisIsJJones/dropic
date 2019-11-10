//
//  PickedUpMediaCell.swift
//  Dropic
//
//  Created by Jordan Jones on 11/9/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import UIKit

class PickedUpMediaCell: UICollectionViewCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: MemeModel) {
        image.image = model.image
        name.text = model.name
    }
}
