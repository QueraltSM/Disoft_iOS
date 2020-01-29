//
//  CalendarCell.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 28/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var date_month: UILabel!
    @IBOutlet weak var date_day: UILabel!
    @IBOutlet weak var date_time: UILabel!
    @IBOutlet weak var date_background: UIView!
    @IBOutlet weak var date_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
