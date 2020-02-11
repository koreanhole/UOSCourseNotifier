//
//  CourseTableViewCell.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/07.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit


class CourseTableViewCell: UITableViewCell {

    
    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var professorNameLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    var subjectItems = [String:String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addButton.imageView?.contentMode = .scaleAspectFit
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update (with subjectItems: [String:String]) {
        subjectNameLabel.text = subjectItems["subject_nm"]
        self.subjectItems = subjectItems
        let professor_name = subjectItems["prof_nm"]!
        if professor_name.isEmpty {
            //professorNameLabel.text = "교수 미정"
             professorNameLabel.text = "교수 미정"
        } else {
            //professorNameLabel.text = subjectItems[indexPath.row]["prof_nm"]
             professorNameLabel.text = professor_name
        }
}
    @IBAction func addButtonClicked(_ sender: UIButton) {
        var temp_result = [String:String]()
        let searchClosure = {(result: [String:String]) -> Void in
            temp_result = result
        }
        CourseData.getCourseInfoFB(subject: self.subjectItems, completion: searchClosure)
        let alert = UIAlertController(title: "내 강의에 추가", message: "\(String(describing: self.subjectItems["subject_nm"]!))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
            CourseData.sharedCourse.savedData.append(temp_result)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.present(alert, animated: true, completion: nil)
        /*if addButton.image(for: .normal) == .add {
            addButton.setImage(.checkmark, for: .normal)
            MyData.sharedCourse.data.append(["subj_nm":subjectNameLabel.text!, "prof_nm":professorNameLabel.text!, "saved": true])
        } else if addButton.image(for: .normal) == .checkmark {
            addButton.setImage(.add, for: .normal)
            MyData.sharedCourse.data.removeLast()
        }*/
        
    }
}
