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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.allowsSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if !CourseData.loadFromFile().isEmpty {
            CourseData.sharedCourse.savedData = CourseData.loadFromFile()
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
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.update(with: CourseData.sharedCourse.savedData[indexPath.section])
        cell.showsReorderControl = true
        CourseData.saveToFile(data: CourseData.sharedCourse.savedData)
        //cell.update(with: MyData.sharedCourse.data[indexPath.section][0], professor_name: MyData.sharedCourse.data[indexPath.section][1])
        //cell.textLabel?.text = "확률과통계 (01분반)"
        //cell.detailTextLabel?.text = "유하진"

        // Configure the cell...

        return cell
    }

    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    func displayAlert() {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "강의계획표", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "상세정보", style: .default, handler: {_ in
            self.tableView.deselectRow(at: indexPath, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
