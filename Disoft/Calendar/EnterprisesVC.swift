//
//  EnterprisesVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 29/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class EnterprisesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    var enterprises = [String]()
    @IBOutlet weak var myTableView: UITableView!
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        enterprises = ["Alberto Sánchez", "Esther Programación", "Queralt Sosa"]
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = "Encuentra tu empresa"
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            myTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        myTableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (enterprises as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            if filteredTableData.count == 0 {
                self.myTableView.setEmptyMessage("No existe ninguna coincidencia")
            } else {
                self.myTableView.restore()
            }
            return filteredTableData.count
        } else {
            if enterprises.count == 0 {
                self.myTableView.setEmptyMessage("No existe ninguna empresa")
            } else {
                self.myTableView.restore()
            }
        }
        return enterprises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            return cell
        } else {
            cell.textLabel?.text = enterprises[indexPath.row]
        }
        if selected_enterprises.contains(enterprises[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.myTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .none
            if let index = selected_enterprises.firstIndex(of: enterprises[indexPath.row]) {
                selected_enterprises.remove(at: index)
            }
        } else {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selected_enterprises.append(enterprises[indexPath.row])
        }
        self.myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        self.present(nextVC, animated: false, completion: nil)
    }
}
