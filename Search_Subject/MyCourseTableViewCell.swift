//
//  MyCourseTableViewCell.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class MyCourseTableViewCell: UITableViewCell {

    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var professorNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update (with courseInfo: [String:String]) {
        let subject_name = courseInfo["subject_nm"]
        let professor_name = courseInfo["prof_nm"]
        subjectNameLabel.text = subject_name
        professorNameLabel.text = professor_name
        /*if professor_name?.isEmpty ?? <#default value#> {
            //professorNameLabel.text = "교수 미정"
             professorNameLabel.text = "교수 미정"
        } else {
            //professorNameLabel.text = subjectItems[indexPath.row]["prof_nm"]
             professorNameLabel.text = professor_name
        }*/
    }

}
