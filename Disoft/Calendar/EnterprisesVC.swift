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
    var enterpriseDictionary = [String: [String]]()
    var enterpriseSectionTitles = [String]()
    
    func setEnterprises() {
        enterprises = ["Alberto Sánchez", "Alba Sosa", "Borja Quintana", "Eva González", "Aura Lacunza" ,"Julián Dominguez", "Felipe Reyes", "Tomás Reyes", "Carla Expósito","Sara Quintela","Esther Programación", "Queralt Sosa"]
        for enterprise in enterprises {
            let enterpriseKey = String(enterprise.prefix(1))
            if var enterpriseValues = enterpriseDictionary[enterpriseKey] {
                enterpriseValues.append(enterprise)
                enterpriseDictionary[enterpriseKey] = enterpriseValues
            } else {
                enterpriseDictionary[enterpriseKey] = [enterprise]
            }
        }
        enterpriseSectionTitles = [String](enterpriseDictionary.keys)
        enterpriseSectionTitles = enterpriseSectionTitles.sorted(by: { $0 < $1 })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        setEnterprises()
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
            let enterpriseKey = enterpriseSectionTitles[section]
            if let enterpriseValues = enterpriseDictionary[enterpriseKey] {
                if enterpriseValues.count == 0 {
                    self.myTableView.setEmptyMessage("No existe ninguna empresa")
                } else {
                    self.myTableView.restore()
                }
                return enterpriseValues.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            return cell
        } else {
            let enterpriseKey = enterpriseSectionTitles[indexPath.section]
            if let enterpriseValues = enterpriseDictionary[enterpriseKey] {
                cell.textLabel?.text = enterpriseValues[indexPath.row]
            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return enterpriseSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return enterpriseSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return enterpriseSectionTitles
    }
    
}
