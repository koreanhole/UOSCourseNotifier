//
//  SubjectTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/05.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit
import Firebase

class SubjectTableViewController: UITableViewController, UISearchResultsUpdating {
    var xmlParser = XMLParser()
    var currentElement = ""
    var subjectItem: [String:String] = ["subject_no" : "", "subject_nm" : "", "class_div" : "",
                                        "subject_div" : "", "credit" : "", "dept" : "", "prof_nm" : ""]
    var subjectItems = [[String:String]]()
    var k = String()
    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        //self.navigationItem.titleView?.addSubview(searchController.searchBar)
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            requestSubjectInfo(searchTerm: searchText)
            tableView.reloadData()
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.subjectItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! CourseTableViewCell
        /*
        let subjectName = subjectItems[indexPath.row]["subject_nm"]!
        let classDiv = subjectItems[indexPath.row]["class_div"]!
        let profName = subjectItems[indexPath.row]["prof_nm"]!
        let string = "\(profName) (\(classDiv)분반)"
        //subjectNameLabel.text = string*/
        cell.update(with: subjectItems[indexPath.row])

        /*cell.textLabel?.text = string
        if subjectItems[indexPath.row]["prof_nm"]!.isEmpty {
            //professorNameLabel.text = "교수 미정"
            cell.detailTextLabel?.text = "교수 미정"
        } else {
            //professorNameLabel.text = subjectItems[indexPath.row]["prof_nm"]
            cell.detailTextLabel?.text = subjectItems[indexPath.row]["prof_nm"]
        }*/
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchResult" {
            let indexPath = tableView.indexPathForSelectedRow!
            let navController = segue.destination as! UINavigationController
            let SearchResultTableViewController = navController.topViewController as! SearchResultTableViewController

            
            SearchResultTableViewController.subjectItem = subjectItems[indexPath.row]
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func unwindToSubjectTableView(segue: UIStoryboardSegue) {
    }
}
