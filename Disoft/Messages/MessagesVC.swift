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
    var messages = [Message]()
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
    
    func setMessagesSent() {
        messages = [Message(date: "25 May 2020", from: "Programación Esther", title: "Prueba 1", description: "Esto es una prueba 1"),
                    Message(date: "03 Oct 2020", from: "Queralt Practicas", title: "Prueba 2", description: "Esto es una prueba 2")]
    }
    
    func setReceivedMessages() {
        messages = [Message(date: "1 Feb 2018", from: "Programación Esther", title: "Prueba 1", description: "Esto es una prueba 1"),
                    Message(date: "22 Abr 2020", from: "Queralt Practicas", title: "Prueba 2", description: "Esto es una prueba 2"),
                    Message(date: "23 Jun 2019", from: "Programación Esther 2", title: "Prueba 3", description: "Esto es una prueba 3")]
    }
    

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        messages.removeAll()
        if (tabBar.items!.index(of: item) == 0) {
            setReceivedMessages()
        } else {
            setMessagesSent()
        }
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0 {
            self.myTableView.setEmptyMessage("No tienes ningún mensaje")
        } else {
            self.myTableView.restore()
        }
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].from
        cell.detailTextLabel?.text = messages[indexPath.row].title

        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:15))
        label.font = label.font.withSize(13)
        label.textColor = UIColor.gray
        label.text = messages[indexPath.row].date
        cell.accessoryView = label
        
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MessageDetailVC") as! MessageDetailVC
        nextVC.messageFrom = messages[indexPath.row].from
        nextVC.messageDate = messages[indexPath.row].date
        nextVC.messageTitle = messages[indexPath.row].title
        nextVC.messageDescription = messages[indexPath.row].description
        self.present(nextVC, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
    }
}
