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
    
    static let allValues = [english, chinese, german]
}

class SelectLanguageViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: WriteValueBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell")!

        if indexPath.row <= LanguageType.allValues.count {
            cell.textLabel?.text = LanguageType.allValues[indexPath.row].rawValue
        } else {
            NSLog("Oops language selection tableView get index larger than option array length")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageType.allValues.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let choice = self.tableView.cellForRow(at: indexPath)?.textLabel?.text {
            self.delegate?.writeValueBack(languageName: choice)
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
