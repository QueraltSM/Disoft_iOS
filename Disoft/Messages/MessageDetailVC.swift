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
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle.title = messageFrom
        self.titleLbl.text = messageTitle
        self.descriptionTxtView.text = messageDescription
        let borderColor : UIColor = UIColor.init(hexString: "#104E01")
        descriptionTxtView.layer.borderWidth = 2
        descriptionTxtView.layer.borderColor = borderColor.cgColor
        descriptionTxtView.layer.cornerRadius = 5.0
        titleLbl.layer.borderWidth = 2
        titleLbl.layer.borderColor = borderColor.cgColor
        titleLbl.layer.cornerRadius = 2
        replyBtn.layer.cornerRadius = replyBtn.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: replyBtn.bounds, cornerRadius: replyBtn.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        replyBtn.layer.mask = maskLayer
        replyBtn.backgroundColor = UIColor.init(hexString: "#B1FF9E")
    }
    
    @IBAction func back(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
        self.present(nextVC, animated: false, completion: nil)
    }
    
}
