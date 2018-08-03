//
//  LessonEvaluationTableViewCell.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 13.06.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation
import UIKit

class LessonEvaluationTableViewCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var markLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func displayCellContent(descriptionText: String, mark: String, date: String) {
        descriptionLabel.text = descriptionText
        markLabel.text = mark
        dateLabel.text = date
    }
    
    func changeFontSize(fontSize: CGFloat) {
        descriptionLabel.font = descriptionLabel.font.withSize(fontSize)
        markLabel.font = markLabel.font.withSize(fontSize)
        dateLabel.font = markLabel.font.withSize(fontSize)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
