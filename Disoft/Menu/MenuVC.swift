//
//  MenuVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 26/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var companyFld: UILabel!
    @IBOutlet weak var usernameFld: UILabel!
    var data: [String] = []
    var images: [String] = []
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        data = ["Inicio", "Agenda", "Documentos", "Mensajes", "Configuración", "Salir"]
        images = ["home_icon", "calendar_icon", "documents_icon", "messages_icon", "settings_icon", "logout_icon"]
        companyFld.text = UserDefaults.standard.object(forKey: "nickname") as? String
        usernameFld.text = UserDefaults.standard.object(forKey: "fullname") as? String
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func setDetailTextLabel(cell: UITableViewCell, title: String) {
        switch title {
        case "Agenda":
            cell.detailTextLabel?.text = "2" // n of dates
            break
        case "Mensajes":
            cell.detailTextLabel?.text = "4" // n of messages
            break
        default:
            cell.detailTextLabel?.text = ""
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.imageView?.image = UIImage(named: images[indexPath.row])
        cell?.textLabel?.text = data[indexPath.row]
        setDetailTextLabel(cell: cell!, title: data[indexPath.row])
        return cell!
    }
    
    func closeSession() {
        //NewsWorker().stop()
        //ChatWorker().stop()
        //UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        //HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        //UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        //UserDefaults.standard.synchronize()
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(nextVC, animated: false, completion: nil)
    }
    
    func logout() {
        let alert = UIAlertController(title: "¿Cerrar sesión?", message: "Dejarás de recibir notificaciones", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            self.closeSession()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row] {
        case "Salir":
            logout()
        default:
            break
        }
    }
    
    func closeMenu() {
        self.view.removeFromSuperview()
        AppDelegate.menu_bool = true
    }
}
