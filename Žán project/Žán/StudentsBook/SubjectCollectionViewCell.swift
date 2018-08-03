//
//  SubjectCollectionViewCell.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 09.06.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation
import UIKit

class SubjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var subjectImage: UIImageView!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var subjectButton: UIButton!
    
    func displayCellContent(image: UIImage, title: String) {
        subjectImage.image = image
        subjectLabel.text = title
    }
    
}
