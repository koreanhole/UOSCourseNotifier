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
    let courseOptions = ["내 강의", "교양", "전공"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        if !CourseData.loadFromFile().isEmpty {
            CourseData.sharedCourse.savedData = CourseData.loadFromFile()
        }
        fetchingCourseData()
        self.tableView.allowsSelection = true

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return CourseData.sharedCourse.savedData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCourse", for: indexPath) as! MyCourseTableViewCell
        //course data 새로고침
        CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        cell.update(with: CourseData.sharedCourse.savedData[indexPath.section])
        
        //cell.update(with: MyData.sharedCourse.data[indexPath.section][0], professor_name: MyData.sharedCourse.data[indexPath.section][1])
        //cell.textLabel?.text = "확률과통계 (01분반)"
        //cell.detailTextLabel?.text = "유하진"

        // Configure the cell...

        return cell
    }
    

    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        fetchingCourseData()
        CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
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
        return .delete
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
        let courseType = courseOptions[filterSegmentedControl.selectedSegmentIndex]
        if courseType == "내 강의" {
            print("내 강의")
            fetchingCourseData()
            CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        } else if courseType == "교양" {
            print("교양")
        } else if courseType == "전공" {
            print("전공")
        }
        self.tableView.reloadData()

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

