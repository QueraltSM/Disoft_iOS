//
//  EnterprisesVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 29/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class EnterprisesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allEnterprises = [String]()
    @IBOutlet weak var myTableView: UITableView!
    var filteredTableData = [String]()
    var enterpriseDictionary = [String: [String]]()
    var enterpriseSectionTitles = [String]()
    
    func setEnterprises(enterprises: [String]) {
        enterpriseDictionary = [String: [String]]()
        enterpriseSectionTitles = [String]()
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
        if enterprises.count == 0 {
            self.myTableView.setEmptyMessage("No existe ninguna empresa")
        } else {
            self.myTableView.restore()
        }
        self.myTableView.reloadData()
    }
    
    func getEnterprises() -> [String] {
        return ["Alberto Sánchez", "Alba Sosa", "Borja Quintana", "Eva González", "Aura Lacunza" ,"Julián Dominguez", "Felipe Reyes", "Tomás Reyes", "Carla Expósito","Sara Quintela","Esther Programación", "Queralt Sosa"].sorted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.allEnterprises = getEnterprises()
        setEnterprises(enterprises: allEnterprises)
        myTableView.reloadData()
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
        cell.selectionStyle = .none
        if let selectedRows = tableView.indexPathsForSelectedRows,
            selectedRows.contains(indexPath){
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myTableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
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
