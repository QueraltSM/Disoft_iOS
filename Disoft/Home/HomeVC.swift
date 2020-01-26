//
//  HomeVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 26/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

var menu_vc : MenuVC!

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenu()
    }
    
    func openMenu() {
        self.addChild(menu_vc)
        self.view.addSubview(menu_vc.view)
        showMenu()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if AppDelegate.menu_bool {
            openMenu()
        } else {
            closeMenu()
        }
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            showMenu()
        case UISwipeGestureRecognizer.Direction.left:
            close_on_swipe()
        default:
            break
        }
    }
    
    func setMenu() {
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
}

func showMenu() {
    AppDelegate.menu_bool = false
    menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
}

func closeMenu() {
    AppDelegate.menu_bool = true
    menu_vc.closeMenu()
}

func close_on_swipe() {
    if AppDelegate.menu_bool {
        showMenu()
    } else {
        closeMenu()
    }
}
