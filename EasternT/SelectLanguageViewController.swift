//
//  SelectLanguageViewController.swift
//  EasternT
//
//  Created by Weijie Wang on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import UIKit

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! SelectLanguageTableViewCell

        if indexPath.row <= LanguageType.allValues.count {
            cell.languageType = LanguageType.allValues[indexPath.row]
            cell.textLabel?.text = cell.languageType.rawValue
        } else {
            cell.textLabel?.text = "Oops..."
            cell.languageType = nil
            NSLog("Oops language selection tableView get index larger than option array length")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageType.allValues.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let choice = (self.tableView.cellForRow(at: indexPath) as? SelectLanguageTableViewCell)?.languageType {
            self.delegate?.writeValueBack(languageType: choice)
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
