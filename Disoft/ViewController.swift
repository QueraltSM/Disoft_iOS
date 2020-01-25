//
//  ViewController.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 25/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(nextVC, animated: false, completion: nil)
        }
    }
}
