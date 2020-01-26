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

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var messagesDictionary = [String: [Message]]()
    var messageSectionTitles = [String]()
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        messages = [Message(date: "22/02/1997", from: "Programación Esther", title: "Prueba 1", description: "Esto es una prueba 1"),
        Message(date: "22/02/1997", from: "Queralt Practicas", title: "Prueba 2", description: "Esto es una prueba 2"),
        Message(date: "23/02/1997", from: "Programación Esther 2", title: "Prueba 3", description: "Esto es una prueba 3")]
        for message in messages {
            let messageKey = message.date
            if var messageValues = messagesDictionary[messageKey!] {
                messageValues.append(message)
                messagesDictionary[messageKey!] = messageValues
            } else {
                messagesDictionary[messageKey!] = [message]
            }
        }
        messageSectionTitles = [String](messagesDictionary.keys)
        messageSectionTitles = messageSectionTitles.sorted(by: { $0 > $1 })
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let messageKey = messageSectionTitles[indexPath.section]
        if let messageValues = messagesDictionary[messageKey] {
            cell.textLabel?.text = messageValues[indexPath.row].from
            cell.detailTextLabel?.text = messageValues[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return messageSectionTitles[section]
    }
}
