//
//  CultRemainingSeatTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/17.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class CultRemainingSeatTableViewController: UITableViewController {
    var cultClassification = String()
    var cultRemainedSeat = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "교양"
        self.title = cultClassification

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cultRemainedSeat.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath)  as! MyCourseTableViewCell
           cell.updateMajorCultCell(with: self.cultRemainedSeat[indexPath.row])
           return cell
       }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "강의계획표", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "상세정보", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "showDetail", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "내 강의에 추가", style: .default, handler: {_ in
            CourseData.sharedCourse.savedData.append(self.cultRemainedSeat[indexPath.row])
            let addAlert = UIAlertController(title: "내 강의에 추가하였습니다.", message: self.cultRemainedSeat[indexPath.row]["subject_nm"], preferredStyle: .alert)
            addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.present(addAlert, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow!
        let navController = segue.destination as! UINavigationController
        
        if segue.identifier == "showDetail" {
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController
            SearchResultTableViewController.subjectItem = self.cultRemainedSeat[indexPath.row]
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToSubjectTableView(segue: UIStoryboardSegue) {
    }
}
