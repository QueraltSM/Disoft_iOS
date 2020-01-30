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
var selected_enterprises = [String()]
var startTitle = "Fecha de inicio"
var endTitle = "Fecha de finalización"
var eventTitle = ""
var eventDescription = ""

class AddEventVC: UIViewController {
    @IBOutlet weak var allDay: UISwitch!
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
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.isAllDay = self.allDay.isOn
                if !self.allDay.isOn {
                    event.endDate = endDate
                }
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func askAuthorization() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            addEventToCalendar(title: event_title.text!, description: event_description.text!, startDate: Date(), endDate: Date())
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.addEventToCalendar(title: (self?.event_title.text!)!, description: self!.event_description.text!, startDate: Date(), endDate: Date())
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
 
    @IBAction func pressAllDay(_ sender: Any) {
        endDate.isEnabled = !allDay.isOn
        if allDay.isOn {
            setEndDateColors(color: "#D8D8D8")
        } else {
            setEndDateColors(color: "#2E6300")
        }
    }
    
    func setEndDateColors(color: String) {
        endDate.layer.borderColor = UIColor.init(hexString: color).cgColor
        endDate.setTitleColor(UIColor.init(hexString: color), for: .normal)
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
        startDate.setTitleColor(UIColor.init(hexString: "#2E6300"), for: .normal)
        setEndDateColors(color: "#2E6300")
        enterprises.backgroundColor = UIColor.init(hexString: "#2E6300")
        startDate.layer.cornerRadius = startDate.bounds.height / 2
        endDate.layer.cornerRadius = endDate.bounds.height / 2
        enterprises.layer.cornerRadius = enterprises.bounds.height / 2
    }
    
    
    @IBAction func selectEnterprises(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterprisesVC") as! EnterprisesVC
        self.present(nextVC, animated: false, completion: nil)
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        askAuthorization()
    }
    
    func setDatesButtons () {
        startDate.setTitle(startTitle, for: .normal)
        endDate.setTitle(endTitle, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event_description.layer.borderWidth = 2
        event_description.layer.borderColor = UIColor.init(hexString: "#2E6300").cgColor
        askAuthorization()
        customButtons()
        enterprises.setTitle("Empresas (\(selected_enterprises.count-1))", for: .normal)
        event_title.setStyle(color: UIColor.init(hexString: "#2E6300"))
        event_title.textColor = UIColor.init(hexString: "#2E6300")
        startDate.setTitle(startTitle, for: .normal)
        endDate.setTitle(endTitle, for: .normal)
    }
}
