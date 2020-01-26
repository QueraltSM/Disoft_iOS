//
//  LoginVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 25/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var companyFld: UITextField!
    @IBOutlet weak var usernameFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyFld.setStyle(color: UIColor.white)
        usernameFld.setStyle(color: UIColor.white)
        passwordFld.setStyle(color: UIColor.white)
        loginBtn.layer.cornerRadius = loginBtn.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: loginBtn.bounds, cornerRadius: loginBtn.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        loginBtn.layer.mask = maskLayer
    }
    
    @IBAction func setNicknameBorderColor(_ sender: Any) {
        companyFld.setStyle(color: UIColor.white)
    }
    
    @IBAction func setUsernameBorderColor(_ sender: Any) {
        usernameFld.setStyle(color: UIColor.white)
    }
    
    @IBAction func setPasswordBorderColor(_ sender: Any) {
        passwordFld.setStyle(color: UIColor.white)
    }
    
    func everyFldIsFull() -> Bool {
        var result = true
        if ((companyFld.text?.isEmpty)!) {
            result = false
            companyFld.setStyle(color: UIColor.red)
        }
        if ((usernameFld.text?.isEmpty)!) {
            result = false
            usernameFld.setStyle(color: UIColor.red)
        }
        if ((passwordFld.text?.isEmpty)!) {
            result = false
            passwordFld.setStyle(color: UIColor.red)
        }
        if (!result) {
            showAlert(title: "Error al iniciar sesión",message: "Todos los campos son obligatorios")
        }
        return result
    }
    
    func makeLoginRequest() {
        var loginParams : Dictionary = [String: String]()
        loginParams["password"] = passwordFld.text!
        loginParams["aliasDb"] = companyFld.text!
        loginParams["appSource"] = "Disoft"
        loginParams["user"] = usernameFld.text!
        Alamofire.request("https://app.dicloud.es/login.asp", method: .post, parameters: loginParams,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    self.decodeJSON(json: JSON)
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if (everyFldIsFull()) {
            makeLoginRequest()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func decodeJSON(json: NSDictionary) {
        let errorCode = json["error_code"] as! Int
        var errorMsg = ""
        switch errorCode {
        case 0: // success
            let fullname = json["fullName"]! as! String
            let token = json["token"]! as! String
            UserDefaults.standard.set(companyFld.text, forKey: "nickname")
            UserDefaults.standard.set(usernameFld.text, forKey: "username")
            UserDefaults.standard.set(fullname, forKey: "fullname")
            UserDefaults.standard.set(passwordFld.text, forKey: "password")
            UserDefaults.standard.set(token, forKey: "token")
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.present(nextVC, animated: false, completion: nil)
            break
        case 1: // company error
            errorMsg = "Alias incorrecto"
            companyFld.setStyle(color: UIColor.red)
            companyFld.text = ""
            break
        case 2:  // user or password error
            errorMsg = "Usuario o contraseña incorrectas"
            usernameFld.setStyle(color: UIColor.red)
            passwordFld.setStyle(color: UIColor.red)
            usernameFld.text = ""
            passwordFld.text = ""
            break
        case 3:// inactive user error
            errorMsg = "Este usuario se encuentra desactivado"
            break
        case 4: // json error
            errorMsg = "Ha habido algún problema en la comunicación"
            break
        case 5: // internet error
            errorMsg = "No hay conexión a internet"
            break
        default: // unknown error
            errorMsg = "Error desconocido"
        }
        if (errorMsg != "") {
             showAlert(title: "Error al iniciar sesión", message: errorMsg)
        }
    }
    
}

extension UITextField {
    func setStyle(color: UIColor) {
        self.layer.cornerRadius = self.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        self.layer.mask = maskLayer
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
