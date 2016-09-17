//
//  ViewController.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import UIKit

protocol WriteValueBackDelegate : class {
    func writeValueBack(languageName: String)
}

class ViewController: UIViewController, WriteValueBackDelegate {
    
    var indexToggle : Int = 0
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectLanguageViewController {
            if segue.identifier == "LanguageSelectionSegue2" {
                self.indexToggle = 1
            } else {
                self.indexToggle = 0
            }
            controller.delegate = self
        }
    }

    func writeValueBack(languageName: String) {
        if 1 == self.indexToggle {
            self.button1.setTitle(languageName, for: .normal)
        } else {
            self.button2.setTitle(languageName, for: .normal)
        }
    }
}

