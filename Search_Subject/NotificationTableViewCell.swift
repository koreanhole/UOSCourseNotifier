//
//  NotificationTableViewCell.swift
//  Search_Subject
//
//  Created by koreanhole on 2020/02/24.
//  Copyright © 2020 권순형. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateNotificationCell (with notificationData: [String:String]) {
        titleLabel.text = notificationData["message"]
        timeLabel.text = notificationData["time"]
        
    }

}
