//
//  DatePickerVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 29/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController, UITabBarDelegate {

    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var date_picker_title: UILabel!
    var pickerTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        date_picker_title.text = pickerTitle
        date_picker.backgroundColor = UIColor.white
        date_picker.setValue(UIColor.init(hexString: "#2E6300"), forKeyPath: "textColor")
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        if (tabBar.items!.index(of: item) == 0) {
            let components = date_picker.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date_picker.date)
            let day = components.day
            let month = components.month
            let hour = components.hour
            let minutes = components.minute
            let date_time = "\(day!) \(months[month!-1]) a las \(hour!):\(minutes!)"
            if (pickerTitle.contains("inicio")) {
                startTitle = date_time
            } else {
                endTitle = date_time
            }
        }
        self.present(nextVC, animated: false, completion: nil)
    }
}
