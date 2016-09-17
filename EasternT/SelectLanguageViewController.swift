//
//  SelectLanguageViewController.swift
//  EasternT
//
//  Created by Weijie Wang on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import UIKit

enum LanguageType: String {
    case english = "English"
    case chinese = "Chinese"
    case german = "German"
}

class SelectLanguageViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
