//
//  AddEventVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 29/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import EventKit

var datePickerVC : DatePickerVC!

class AddEventVC: UIViewController {
    
    @IBOutlet weak var enterprises: UIButton!
    @IBOutlet weak var event_title: UITextField!
    @IBOutlet weak var event_description: UITextView!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    
    func showPopOver(pickerTitle: String){
        datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerVC") as? DatePickerVC
        datePickerVC.pickerTitle = pickerTitle
        datePickerVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(datePickerVC)
        self.view.addSubview(datePickerVC.view)
    }
    
    @IBAction func back(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        self.present(nextVC, animated: false, completion: nil)
    }
    
    
    func insertEvent(store: EKEventStore) {
        let calendars = store.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == "ioscreator" {
                let startDate = Date()
                let endDate = startDate.addingTimeInterval(2 * 60 * 60)
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                do {
                    try store.save(event, span: .thisEvent)
                    print("Event saved")
                }
                catch {
                    print("Error saving event in calendar")             }
            }
        }
    }
    
    func askAuthorization() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
 
    @IBAction func showEndDate(_ sender: Any) {
        showPopOver(pickerTitle: "Fecha de finalización")
    }
    
    @IBAction func showStartDate(_ sender: Any) {
        showPopOver(pickerTitle: "Fecha de inicio")
    }
    
    func customButtons() {
        startDate.layer.borderWidth = 2
        endDate.layer.borderWidth = 2
        startDate.layer.borderColor = UIColor.init(hexString: "#2E6300").cgColor
        endDate.layer.borderColor = UIColor.init(hexString: "#2E6300").cgColor
        enterprises.backgroundColor = UIColor.init(hexString: "#2E6300")
        startDate.layer.cornerRadius = startDate.bounds.height / 2
        endDate.layer.cornerRadius = endDate.bounds.height / 2
        enterprises.layer.cornerRadius = enterprises.bounds.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askAuthorization()
        customButtons()
        event_title.setStyle(color: UIColor.init(hexString: "#2E6300"))
        var startTitle = UserDefaults.standard.object(forKey: "startDate_picker_selection") as? String
        var endTitle = UserDefaults.standard.object(forKey: "endDate_picker_selection") as? String
        if startTitle == nil {
            startTitle = "Fecha de inicio"
        }
        if endTitle == nil {
            endTitle = "Fecha de finalización"
        }
        startDate.setTitle(startTitle, for: .normal)
        endDate.setTitle(endTitle, for: .normal)
    }
}
