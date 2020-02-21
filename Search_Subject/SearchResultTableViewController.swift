//
//  SearchResultTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/06.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    @IBOutlet weak var prof_nm: UILabel!
    @IBOutlet weak var subject_div: UILabel!
    @IBOutlet weak var class_div: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet var shyr: UILabel!
    @IBOutlet var tlsn_count: UILabel!
    @IBOutlet var tlsn_limit_count: UILabel!
    @IBOutlet var remainingSeat: UILabel!
    @IBOutlet var sec_permit_yn: UILabel!
    @IBOutlet var etc_permit_yn: UILabel!
    @IBOutlet var class_nm: UILabel!
    
    var subjectItem = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = subjectItem["subject_nm"]
        self.prof_nm.text = subjectItem["prof_nm"]
        self.subject_div.text = subjectItem["subject_div"]
        self.class_div.text = subjectItem["class_div"] ?? String()+"분반"
        self.credit.text = subjectItem["credit"] ?? String()+"학점"
        self.dept.text = subjectItem["sub_dept"]
        self.shyr.text = subjectItem["shyr"] ?? String()+"학년"
        if subjectItem["tlsn_count"]?.isEmpty ?? true {
            self.tlsn_count.text = "0명"
        } else {
            self.tlsn_count.text = subjectItem["tlsn_count"]!+"명"
        }
        if subjectItem["tlsn_limit_count"]?.isEmpty ?? true  {
            self.tlsn_limit_count.text = "0명"
        } else {
            self.tlsn_limit_count.text = subjectItem["tlsn_limit_count"]!+"명"
        }
        if subjectItem["remaining_seat"]?.isEmpty ?? true {
            self.remainingSeat.text = "0명"
        } else {
            self.remainingSeat.text = subjectItem["remaining_seat"]!+"명"
        }
        self.sec_permit_yn.text = subjectItem["sec_permit_yn"]
        self.etc_permit_yn.text = subjectItem["etc_permit_yn"]
        self.class_nm.text = subjectItem["class_nm"]

        
        /*
        self.title = subjectItem["subject_nm"]
        prof_nm.text = subjectItem["prof_nm"]
        subject_div.text = subjectItem["subject_div"]
        class_div.text = subjectItem["class_div"]!+"분반"
        credit.text = subjectItem["credit"]!+"학점"
        dept.text = subjectItem["dept"]
         */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
