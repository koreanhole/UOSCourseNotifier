//
//  SearchDeptTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/16.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class SearchDeptTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResult = CourseData.sharedCourse.dept_list
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "검색"
        //self.navigationItem.titleView?.addSubview(searchController.searchBar)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedDept", for: indexPath)
        cell.textLabel?.text = searchResult[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //이미 즐겨찾기에 추가되어있을때
        if CourseData.sharedCourse.myDept_list.contains(searchResult[indexPath.row]) {
            alert.title = "이미 즐겨찾기에 추가되어 있습니다."
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        }
        //즐겨찾기에 없을때
        else {
            alert.title = "즐겨찾기에 추가하였습니다."
            alert.message = searchResult[indexPath.row]
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {_ in
                CourseData.sharedCourse.myDept_list.append(self.searchResult[indexPath.row])
                self.performSegue(withIdentifier: "searchCompleted", sender: self)
            }))
        }
        present(alert, animated: true, completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = CourseData.sharedCourse.dept_list.filter({$0.prefix(searchText.count) == searchText})
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResult = CourseData.sharedCourse.dept_list
        self.tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
