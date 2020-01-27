//
//  MessagesVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 26/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

struct Message {
    var date: String!
    var from: String!
    var title: String!
    var description: String!
    // files too
}

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var myTableView: UITableView!
    var messagesDictionary = [String: [Message]]()
    var messageSectionTitles = [String]()
    var messages = [Message]()
    var deletePlanetIndexPath: NSIndexPath? = nil
    var deletedMessage: Message?
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenu()
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        setReceivedMessages()
    }

    func setHeader(allMessages: [Message]) {
        for message in allMessages {
            let messageKey = message.date
            if var messageValues = messagesDictionary[messageKey!] {
                messageValues.append(message)
                messagesDictionary[messageKey!] = messageValues
            } else {
                messagesDictionary[messageKey!] = [message]
            }
        }
        messageSectionTitles = [String](messagesDictionary.keys)
        //messageSectionTitles = messageSectionTitles.sorted(by: { $0 < $1 }) check order while data is received
    }
    
    func setMessagesSent() {
        messages = [Message(date: "25/06/1999", from: "Programación Esther", title: "Prueba 1", description: "Esto es una prueba 1"),
                    Message(date: "03/10/2020", from: "Queralt Practicas", title: "Prueba 2", description: "Esto es una prueba 2")]
        setHeader(allMessages: messages)
    }
    
    func setReceivedMessages() {
        messages = [Message(date: "22/02/1997", from: "Programación Esther", title: "Prueba 1", description: "Esto es una prueba 1"),
                    Message(date: "22/02/1997", from: "Queralt Practicas", title: "Prueba 2", description: "Esto es una prueba 2"),
                    Message(date: "23/02/1997", from: "Programación Esther 2", title: "Prueba 3", description: "Esto es una prueba 3")]
        setHeader(allMessages: messages)
    }
    
    func clearTable() {
        messages.removeAll()
        messagesDictionary.removeAll()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (tabBar.items!.index(of: item) == 0) {
            clearTable()
            setReceivedMessages()
        } else {
            clearTable()
            setMessagesSent()
        }
        self.myTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messageKey = messageSectionTitles[section]
        if let messageValues = messagesDictionary[messageKey] {
            if messageValues.count == 0 {
                self.myTableView.setEmptyMessage("No tienes ningún mensaje")
            } else {
                self.myTableView.restore()
            }
            return messageValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.black
            header.textLabel?.textColor = UIColor.white
            header.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let messageKey = messageSectionTitles[indexPath.section]
        if let messageValues = messagesDictionary[messageKey] {
            cell.textLabel?.text = messageValues[indexPath.row].from
            cell.detailTextLabel?.text = messageValues[indexPath.row].title
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return messageSectionTitles[section]
    }
    
    func setMenu() {
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func openMenu() {
        self.addChild(menu_vc)
        self.view.addSubview(menu_vc.view)
        showMenu()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if AppDelegate.menu_bool {
            openMenu()
        } else {
            closeMenu()
        }
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            showMenu()
        case UISwipeGestureRecognizer.Direction.left:
            close_on_swipe()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Eliminar") { (rowAction, indexPath) in
            self.deletePlanetIndexPath = indexPath as NSIndexPath
            let messageKey = self.messageSectionTitles[indexPath.section]
            if let messageValues = self.messagesDictionary[messageKey] {
                let planetToDelete = messageValues[indexPath.row]
                self.deletedMessage = planetToDelete
                self.confirmDelete(planet: planetToDelete.title)
            }
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
                if let indexPath = deletePlanetIndexPath {
                       myTableView.beginUpdates()
                    /*messagesDictionary = messagesDictionary.mapValues{ $0.filter{
                        $0.date == deletedMessage!.date &&
                            $0.description == deletedMessage!.description &&
                            $0.from == deletedMessage!.from &&
                            $0.title == deletedMessage!.title
                        } }*/
                    myTableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                       deletePlanetIndexPath = nil
                       //myTableView.endUpdates()
                   }
            }
    
        func cancelDeletePlanet(alertAction: UIAlertAction!) {
               deletePlanetIndexPath = nil
           }
    
        func confirmDelete(planet: String) {
            let alert = UIAlertController(title: "Eliminar mensaje", message: "¿Quieres eliminar \(planet)?", preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction(title: "Eliminar", style: .destructive, handler: handleDeletePlanet)
            let CancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: cancelDeletePlanet)
               alert.addAction(DeleteAction)
               alert.addAction(CancelAction)
            self.present(alert, animated: true, completion: nil)
           }

}
