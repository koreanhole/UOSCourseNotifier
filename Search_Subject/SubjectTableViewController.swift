//
//  SubjectTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/05.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController, XMLParserDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    var xmlParser = XMLParser()
    var currentElement = ""
    
    var subjectItem: [String:String] = ["subject_no" : "", "subject_nm" : "", "class_div" : "",
                                        "subject_div" : "", "credit" : "", "dept" : "", "prof_nm" : ""]
    var subjectItems = [[String:String]]()
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            requestSubjectInfo(searchTerm: searchText)
            tableView.reloadData()
        }
    }
    
    func requestSubjectInfo(searchTerm: String){
        self.tableView.reloadData()
        subjectItems = [[String:String]]()
        let query: [String: String] = [
            "apiKey": "202001610WYX35223",
            "year": "2020",
            "term": "A10",
            "subjectNm": searchTerm
        ]
        let baseURL = URL(string: "https://wise.uos.ac.kr/uosdoc/api.ApiApiSubjectList.oapi?")!
        
        guard let url = baseURL.withQueries(query) else {
            
            print("Unable to build URL with supplied queries.")
            return
        }
        guard let xmlParser = XMLParser(contentsOf: url) else { return }
        xmlParser.delegate = self;
        xmlParser.parse()
        self.tableView.reloadData()
    }
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "list" {
            for (keys, _) in subjectItem {
                subjectItem.updateValue("", forKey: keys)
            }
        }
    }
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if subjectItem.keys.contains(currentElement) {
            subjectItem.updateValue(string, forKey: currentElement)
        }
    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        if elementName == "list" {
            subjectItems.append(subjectItem)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
        let subjectName = subjectItems[indexPath.row]["subject_nm"]!
        let classDiv = subjectItems[indexPath.row]["class_div"]!
        let string = "\(subjectName) (\(classDiv)분반)"
        cell.textLabel?.text = string
        if subjectItems[indexPath.row]["prof_nm"]!.isEmpty {
            cell.detailTextLabel?.text = "교수 미정"
        } else {
            cell.detailTextLabel?.text = subjectItems[indexPath.row]["prof_nm"]
        }
        
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
