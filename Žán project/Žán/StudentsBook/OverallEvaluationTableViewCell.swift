//
//  OverallEvaluationTableViewCell.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 12.07.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation
import UIKit

class OverallEvaluationTableViewCell: UITableViewCell
{
    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var quarter_markLabel: UILabel!
    @IBOutlet var semester_markLabel: UILabel!


var isNotSetUp = true

func displayCellContent(teacher: String, subject: String, quarter_mark: String, semester_mark: String) {
    subjectNameLabel.text = subject
    teacherNameLabel.text = teacher
    quarter_markLabel.text = quarter_mark
    semester_markLabel.text = semester_mark
}
    
func changeFontSize(fontSize: CGFloat) {
    subjectNameLabel.font =
        subjectNameLabel.font.withSize(fontSize)
    teacherNameLabel.font =
        teacherNameLabel.font.withSize(fontSize)
    quarter_markLabel.font =
        quarter_markLabel.font.withSize(fontSize)
    semester_markLabel.font =
        semester_markLabel.font.withSize(fontSize)
}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //Configure the view for the selected state
    }

}
        
        
        
        
        
        
        
        

