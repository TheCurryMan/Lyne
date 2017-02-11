//
//  ViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 2/11/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LineSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var lineCode: UILabel!
    @IBOutlet weak var lineName: UILabel!
    @IBOutlet weak var lineAddress: UILabel!
    @IBOutlet weak var lineETA: UILabel!
    @IBOutlet weak var lineCount: UILabel!
    @IBOutlet weak var lineBGView: UILabel!
    var ref: FIRDatabaseReference!
    @IBAction func addLine(_ sender: Any) {
        
        self.ref = FIRDatabase.database().reference()
        ref.child("lines").child(lineCode.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let users = value?["Users"] as? [String] {
                var userFinal = [String]()
                userFinal = users
                userFinal.append(UserDefaults.standard.value(forKey: "number") as! String)
                self.ref.child("lines/\(self.lineCode.text!)/Users").setValue(userFinal)
            } else {
                var users = [UserDefaults.standard.value(forKey: "number") as! String]
                self.ref.child("lines/\(self.lineCode.text!)/Users").setValue(users)
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("users").child(UserDefaults.standard.value(forKey: "number") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user valuete
            let value = snapshot.value as? NSDictionary
            if let lines = value?["lines"] as? [String] {
                var linesFinal = [String]()
                linesFinal = lines
                linesFinal.append(self.lineCode.text!)
                self.ref.child("users/\(UserDefaults.standard.value(forKey: "number") as! String)/lines").setValue(linesFinal)
            } else {
                var lines = ["\(self.lineCode.text!)"]
                self.ref.child("users/\(UserDefaults.standard.value(forKey: "number") as! String)/lines").setValue(lines)
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

class CurrentLinesTableViewCell:UITableViewCell {

    @IBOutlet weak var currentLineCode: UILabel!
    @IBOutlet weak var currentLineName: UILabel!
    @IBOutlet weak var currentLineAddress: UILabel!
    @IBOutlet weak var currentLinePosition: UILabel!
    @IBOutlet weak var currentLineETA: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    
}


class HomeViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    var ref: FIRDatabaseReference!
    
    var lines = [Line]()
    var currentLines = [Line]()
    var curLinesString = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "LineSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "line")
        tableView.register(UINib(nibName: "CurrentLinesTableViewCell", bundle: nil), forCellReuseIdentifier: "current")
        self.ref = FIRDatabase.database().reference().child("lines")
        
        var refHandle = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.lines.removeAll()
            for i in postDict{
                var data = i.value as! NSDictionary
                var line = Line()
                print(data)
                line.address = data["location"] as! String
                line.code = data["codename"] as! String
                line.count = data["count"] as! Int
                line.eta = data["eta"] as! Int
                line.name = data["name"] as! String
                self.lines.append(line)
                self.getUserData()
            }
            self.tableView.reloadData()
        })
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.tableView.reloadData()
    }
    
    func getUserData(){
        self.ref = FIRDatabase.database().reference().child("users").child(UserDefaults.standard.value(forKey: "number") as! String)
        var refHandles = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let curString = postDict["lines"] as? [String] {
                self.curLinesString = curString
                self.emptyLabel.isHidden = true
                self.getCurrentLines()
            } else {
                self.emptyLabel.isHidden = false
            }
            
        })
    }
    
    func getCurrentLines(){
        currentLines.removeAll()
        for i in curLinesString {
            for j in lines {
                if i == j.code {
                    currentLines.append(j)
                    
                }
            }
        }
        self.tableView.reloadData()
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lines.count > 0 {
            emptyLabel.isHidden = true
            
        } else {
            emptyLabel.isHidden = false
        }
        if (isSearching) {
            return lines.count
        } else {
            return currentLines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isSearching) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath) as! LineSearchTableViewCell
            cell.selectionStyle = .none
            let line = lines[indexPath.row]
            cell.lineCode.text = line.code
            if line.count > 3
            {
                cell.lineETA.text = "ETA: " + String(line.eta * (line.count - 3)) + " min."
            } else
            {
                cell.lineETA.text = "ETA: 0 min."
            }
        
            cell.lineName.text = line.name
            cell.lineCount.text = String(line.count)
            cell.lineBGView.layer.cornerRadius = 10
            cell.lineAddress.text = line.address
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "current", for: indexPath) as! CurrentLinesTableViewCell
            cell.selectionStyle = .none
            let line = currentLines[indexPath.row]
            cell.currentLineCode.text = line.code
            if line.count > 3
            {
                cell.currentLineETA.text = "ETA: " + String(line.eta * (line.count - 3)) + " min."
            } else
            {
                cell.currentLineETA.text = "ETA: 0 min."
            }
            
            cell.currentLineName.text = line.name
            cell.currentLinePosition.text = String(line.count)
            cell.backgroundLabel.layer.cornerRadius = 10
            cell.currentLineAddress.text = line.address
            return cell
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

