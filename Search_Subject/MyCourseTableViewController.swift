//
//  MyCourseTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/06.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import QuartzCore

class MyCourseTableViewController: UITableViewController {
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    //segment = 0 -> 내 강의, segment = 1 -> 교양, segment = 2 -> 전공
    //참고: https://stackoverflow.com/questions/26148921/switch-between-cells-when-segmentedcontrol-has-changed
    var segment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        if !CourseData.loadFromFile().isEmpty {
            CourseData.sharedCourse.savedData = CourseData.loadFromFile()
        }
        fetchingCourseData()
        //self.tableView.allowsSelection = true

    }
    func fetchingCourseData() {
        for index in 0..<CourseData.sharedCourse.savedData.count {
            let searchClosure = {(result: [String:String]) -> Void in
                CourseData.sharedCourse.savedData[index] = result
                self.tableView.reloadData()
            }
            CourseData.getCourseInfoFB(subject: CourseData.sharedCourse.savedData[index], completion: searchClosure)
        }
    }
    
    func fetchingCultData() {
        let searchClosure = {(result: [[String:String]]) -> Void in
            CourseData.sharedCourse.cultData = result
        }
        CourseData.getCultInfoFB(completion: searchClosure)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch segment {
        //내강의
        case 0:
            return CourseData.sharedCourse.savedData.count
        //교양
        case 1:
            return 1
        //전공
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch segment {
        //내강의
        case 0:
            return 1
        //교양
        case 1:
            return CourseData.sharedCourse.cultData.count
        //전공
        case 2:
            return CourseData.sharedCourse.savedData.count
        default:
            return 0
        }
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MyCourseTableViewCell()
        switch segment {
        //내강의
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath) as! MyCourseTableViewCell
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
            cell.updateMyCourseCell(with: CourseData.sharedCourse.savedData[indexPath.section])
            return cell
        //교양
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath) as! MyCourseTableViewCell
            cell.updateMajorCultCell(with: CourseData.sharedCourse.cultData[indexPath.row])
            return cell
        //전공
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "majorCult", for: indexPath) as! MyCourseTableViewCell
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
            cell.updateMajorCultCell(with: CourseData.sharedCourse.savedData[indexPath.row])
            return cell
        default:
            return cell
        }
    }
    

    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        switch segment {
        case 0:
            fetchingCourseData()
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        case 1:
            fetchingCultData()
        case 2:
            print("not decided")
        default:
            break
        }
        self.refreshControl?.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "수강신청 어플로 가기", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "강의계획표", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "상세정보", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "showDetail", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        if segment == 0 {
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                let deleteAlert = UIAlertController(title: "정말 삭제하시겠습니까?", message: CourseData.sharedCourse.savedData[indexPath.section]["subject_nm"], preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
                    CourseData.sharedCourse.savedData.remove(at: indexPath.section)
                    //tableView.deleteRows(at: [indexPath], with: .automatic)
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    tableView.deleteSections(indexSet, with: .automatic)
                    CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
                }))
                deleteAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(deleteAlert, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CourseData.sharedCourse.savedData.remove(at: indexPath.section)
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .automatic)
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch segment {
        //내강의
        case 0:
            return .delete
        //교양
        case 1:
            return .none
        //전공
        case 2:
            return .none
        default:
            return .none
        }
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedCourse = CourseData.sharedCourse.savedData.remove(at: fromIndexPath.section)
        CourseData.sharedCourse.savedData.insert(movedCourse, at: to.section)
        CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        tableView.reloadData()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.navigationItem.leftBarButtonItem = self.editButtonItem
            segment = 0
        case 1:
            segment = 1
            self.navigationItem.leftBarButtonItem = nil
        case 2:
            segment = 2
            self.navigationItem.leftBarButtonItem = nil
        default:
            break
        }
        tableView.reloadData()

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let navController = segue.destination as! UINavigationController
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController

            
            SearchResultTableViewController.subjectItem = CourseData.sharedCourse.savedData[indexPath.section] 
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToSubjectTableView(segue: UIStoryboardSegue) {
        fetchingCourseData()
    }
}

