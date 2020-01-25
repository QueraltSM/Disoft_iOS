//
//  LoginVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 25/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var companyFld: UITextField!
    @IBOutlet weak var usernameFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyFld.setStyle()
        usernameFld.setStyle()
        passwordFld.setStyle()
        loginBtn.layer.cornerRadius = loginBtn.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: loginBtn.bounds, cornerRadius: loginBtn.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        loginBtn.layer.mask = maskLayer
    }

}

extension UITextField {
    func setStyle() {
        self.layer.cornerRadius = self.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        self.layer.mask = maskLayer
        self.layer.borderWidth = 2.0
        let white = UIColor.white
        self.layer.borderColor = white.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : white])
    }
}
