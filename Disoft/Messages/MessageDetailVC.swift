//
//  MessageDetailVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 27/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class MessageDetailVC: UIViewController {
    
    var messageDate: String = ""
    var messageFrom : String = ""
    var messageTitle : String = ""
    var messageDescription : String = ""
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle.title = messageFrom
    }
    
    @IBAction func back(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
        self.present(nextVC, animated: false, completion: nil)
    }
    
}
