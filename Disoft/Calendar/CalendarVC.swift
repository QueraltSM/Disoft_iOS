//
//  CalendarVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 28/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

struct DisDate {
    var date: String!
    var title: String!
    var color: UIColor!
}

struct Sorted_DisDate {
    var date: Date!
    var title: String!
    var color: UIColor!
}

class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var dates = [DisDate]()
    var sorted_dates = [Sorted_DisDate]()
    var dates_loaded = [String]()
    var months = ["En.","Feb.","Mar.","Abr.","May.","Jun.","Jul.","Ag.","Sept.","Oct.","Nov.","Dic."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 100
        dates = [DisDate(date: "2020-10-10T12:42:00", title: "Terminar TFG", color: UIColor.blue),
                 DisDate(date: "2020-10-10T11:42:00", title: "Cita con Alberto", color: UIColor.green),
                 DisDate(date: "2020-04-02T12:42:00", title: "Cita con Queralt", color: UIColor.orange),
                 DisDate(date: "2020-04-02T10:00:00", title: "Terminar trabajo", color: UIColor.yellow),
                 DisDate(date: "2020-12-02T12:42:00", title: "Cita con Pepito", color: UIColor.cyan)]
        transformDates()
        sorted_dates.sort(by: { $0.date < $1.date })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dates.count == 0 {
            self.myTableView.setEmptyMessage("No tienes ninguna cita")
        } else {
            self.myTableView.restore()
        }
        return dates.count
    }

    func addTopBorder(cell: CalendarCell) {
        let border = UIView()
        border.backgroundColor = UIColor.init(hexString: "#EDEDED")
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: cell.date_background.frame.size.width, height: 2)
        cell.date_background.addSubview(border)
    }
    
    func addBottomBorder(cell: CalendarCell) {
        let border = UIView()
        border.backgroundColor = UIColor.init(hexString: "#EDEDED")
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: cell.date_background.frame.size.height - 2, width: cell.date_background.frame.size.width, height: 2)
        cell.date_background.addSubview(border)
    }
    
    func addLeftBorder(cell: CalendarCell, color: UIColor) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: 10, height: cell.date_background.frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        cell.date_background.addSubview(border)
    }
    
    func addRightBorder(cell: CalendarCell) {
        let border = UIView()
        border.backgroundColor = UIColor.init(hexString: "#EDEDED")
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: cell.date_background.frame.size.width - 2, y: 0, width: 2, height: cell.date_background.frame.size.height)
        cell.date_background.addSubview(border)
    }
    
    func transformDates() {
        for disDate in dates {
            let disDate_date = disDate.date
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM yyyy h:mm a"
            let date = dateFormatterGet.date(from: disDate_date!)
            sorted_dates.append(Sorted_DisDate(date:date!,title: disDate.title, color: disDate.color))
        }
    }
    
    func getDate(date: Date) -> [String] {
        let calendar = Calendar.current
        let day = "\(calendar.component(.day, from: date))"
        let month = months[calendar.component(.month, from: date)-1]
        let time = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        return [day, month, time]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarCell
        let final_date = getDate(date: sorted_dates[indexPath.row].date)
        if dates_loaded.contains("\(final_date[0])-\(final_date[1])") {
            cell.date_day.text = ""
            cell.date_month.text = ""
        } else {
            cell.date_day.text = final_date[0]
            cell.date_month.text = final_date[1]
            dates_loaded.append("\(final_date[0])-\(final_date[1])")
        }
        cell.date_time.text = final_date[2]
        cell.date_time.textColor = sorted_dates[indexPath.row].color
        cell.date_title.text = sorted_dates[indexPath.row].title
        cell.date_background.layer.cornerRadius = 20.0
        cell.date_background.clipsToBounds = true
        addRightBorder(cell: cell)
        addLeftBorder(cell: cell, color: sorted_dates[indexPath.row].color)
        addTopBorder(cell: cell)
        addBottomBorder(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageDetailVC") as! MessageDetailVC
        nextVC.messageFrom = messages[indexPath.row].from
        nextVC.messageDate = messages[indexPath.row].date
        nextVC.messageTitle = messages[indexPath.row].title
        nextVC.messageDescription = messages[indexPath.row].description
        self.present(nextVC, animated: false, completion: nil)
    }*/
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            self.showDeleteWarning(indexPath: indexPath)
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    func showDeleteWarning(indexPath: IndexPath) {
        let alert = UIAlertController(title: "¿Quieres eliminar este mensaje?", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Eliminar", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.messages.remove(at: indexPath.row)
                self.myTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }*/
}
