//
//  EnterprisesVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 29/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class EnterprisesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var allEnterprises = [String]()
    @IBOutlet weak var myTableView: UITableView!
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var enterpriseDictionary = [String: [String]]()
    var enterpriseSectionTitles = [String]()
    var cancel = false
    
    func setEnterprises(enterprises: [String]) {
        enterpriseDictionary = [String: [String]]()
        enterpriseSectionTitles = [String]()

        var enterprises_aux = enterprises
        if cancel {
            enterprises_aux = getEnterprises()
            cancel = false
        }
        
        for enterprise in enterprises_aux {
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

        if !resultSearchController.isActive && enterprises_aux.count == 0 {
            self.myTableView.setEmptyMessage("No existe ninguna empresa")
        } else if resultSearchController.isActive && !resultSearchController.isEditing && enterprises_aux.count == 0 {
            self.myTableView.setEmptyMessage("No existe ninguna coincidencia")
        } else {
            self.myTableView.restore()
            self.myTableView.reloadData()
        }
        self.myTableView.reloadData()
    }
    
    func getEnterprises() -> [String] {
        return ["Alberto Sánchez", "Alba Sosa", "Borja Quintana", "Eva González", "Aura Lacunza" ,"Julián Dominguez", "Felipe Reyes", "Tomás Reyes", "Carla Expósito","Sara Quintela","Esther Programación", "Queralt Sosa"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.allEnterprises = getEnterprises()
        setEnterprises(enterprises: allEnterprises)
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = "Encuentra tu empresa"
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.searchBarStyle = .minimal
            myTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        resultSearchController.searchBar.delegate = self
        myTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancel = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (allEnterprises as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        enterpriseDictionary = [String: [String]]()
        enterpriseSectionTitles = [String]()
        setEnterprises(enterprises: filteredTableData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let enterpriseKey = enterpriseSectionTitles[section]
        if let enterpriseValues = enterpriseDictionary[enterpriseKey] {
            return enterpriseValues.count
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let enterpriseKey = enterpriseSectionTitles[indexPath.section]
        if let enterpriseValues = enterpriseDictionary[enterpriseKey] {
            cell.textLabel?.text = enterpriseValues[indexPath.row]
        }
        if selected_enterprises.contains(allEnterprises[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.myTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .none
            if let index = selected_enterprises.firstIndex(of: allEnterprises[indexPath.row]) {
                selected_enterprises.remove(at: index)
            }
        } else {
            self.myTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selected_enterprises.append(allEnterprises[indexPath.row])
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
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return enterpriseSectionTitles[section]
        }
        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return enterpriseSectionTitles
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

}
