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
    var noticeData = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingNotificationData()
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    @objc func refresh(sender:AnyObject){
        fetchingNotificationData()
    }
    func fetchingNotificationData() {
        self.refreshControl?.beginRefreshing()
        let noticeClosure = {(result: [[String:String]]) -> Void in
            self.noticeData = result
        }
        CourseData.getNoticeDataFB(completion: noticeClosure)
        let searchClosure = {(result: [[String:String]]) -> Void in
            self.notificationData = result
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        CourseData.getNotifiactionDataFB(completion: searchClosure)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.noticeData.count
        case 1:
            return self.notificationData.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        switch section {
        case 0:
            label.text = "공지사항"
            label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            headerView.addSubview(label)
        case 1:
            label.text = "빈자리 알림"
            label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            headerView.addSubview(label)
        default:
            break
        }
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 70
        case 1:
            return 70
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        switch indexPath.section {
        case 0:
            cell.updateNoticeCell(with: self.noticeData[indexPath.row])
        case 1:
            cell.updateNotificationCell(with: self.notificationData[indexPath.row])
        default:
            break
        }

        return cell
    }
}
