//
//  NotificationTableViewController.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/22.
//  Copyright © 2020 권순형. All rights reserved.
//  저장된 알림을 보여주는 화면

import UIKit

class NotificationTableViewController: UITableViewController {
    
    var notificationData = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingNotificationData()
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchingNotificationData()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    @objc func refresh(sender:AnyObject){
        fetchingNotificationData()
    }
    func fetchingNotificationData() {
        self.refreshControl?.beginRefreshing()
        let searchClosure = {(result: [[String:String]]) -> Void in
            self.notificationData = result
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        CourseData.getNotifiactionDataFB(completion: searchClosure)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        cell.updateNotificationCell(with: self.notificationData[indexPath.row])

        return cell
    }
}
