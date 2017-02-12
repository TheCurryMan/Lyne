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
            var count = value?["count"] as? Int
            if let users = value?["Users"] as? [String] {
                var userFinal = [String]()
                userFinal = users
                userFinal.append(UserDefaults.standard.value(forKey: "number") as! String)
                self.ref.child("lines/\(self.lineCode.text!)/Users").setValue(userFinal)
            } else {
                var users = [UserDefaults.standard.value(forKey: "number") as! String]
                self.ref.child("lines/\(self.lineCode.text!)/Users").setValue(users)
            }
            self.ref.child("lines/\(self.lineCode.text!)/count").setValue(count!+1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("users").child(UserDefaults.standard.value(forKey: "number") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user valuete
            var con = true
            let value = snapshot.value as? NSDictionary
            if let lines = value?["lines"] as? [String] {
                for i in lines {
                    if i == self.lineCode.text! {
                        con = false
                    }
                }
                if con {
                var linesFinal = [String]()
                linesFinal = lines
                linesFinal.append(self.lineCode.text!)
                self.ref.child("users/\(UserDefaults.standard.value(forKey: "number") as! String)/lines").setValue(linesFinal)
                }
            } else {
                var lines = ["\(self.lineCode.text!)"]
                self.ref.child("users/\(UserDefaults.standard.value(forKey: "number") as! String)/lines").setValue(lines)
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"goback"),
                object: nil,
                userInfo: nil)
        
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


class HomeViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    var ref: FIRDatabaseReference!
    
    var lines = [Line]()
    var filteredLines = [Line]()
    var currentLines = [Line]()
    var curLinesString = [String]()
    var isSearching = false
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "LineSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "line")
        tableView.register(UINib(nibName: "CurrentLinesTableViewCell", bundle: nil), forCellReuseIdentifier: "current")
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"goback"),
                       object:nil, queue:nil,
                       using:goBackAndRefresh)
        
        self.ref = FIRDatabase.database().reference().child("lines")
        
        var refHandle = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.lines.removeAll()
            self.currentLines.removeAll()
            for i in postDict{
                var data = i.value as! NSDictionary
                var line = Line()
                print(data)
                line.address = data["location"] as! String
                line.code = data["codename"] as! String
                line.count = data["count"] as! Int
                line.eta = data["eta"] as! Int
                line.users = data["Users"] as? [String]
                line.name = data["name"] as! String
                self.lines.append(line)
                self.getUserData()
            }
            self.tableView.reloadData()
        })
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchResultsUpdater = self
        searchController.dismiss(animated: false, completion: nil)
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.init(red: 41/256, green: 182/256, blue: 245/256, alpha: 1)
        
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
        self.tableView.reloadData()
        //self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.tableView.reloadData()
        //self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.isSearching = false
        self.tableView.reloadData()
        //self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == self.searchController.searchBar {
            print("NAMASTE")
        }
        //self.searchBar.resignFirstResponder()
        self.isSearching = false
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.isSearching = true
        filteredLines = lines.filter{line in
            return (line.code?.lowercased().contains(searchText.lowercased()))!
        }
        if searchText == "" {
            filteredLines = lines
        }
        
        if (searchController.isActive == false) && (searchText == "" ){
            isSearching = false
        }
        
        tableView.reloadData()
    }
    
    func goBackAndRefresh(notification:Notification) -> Void {
        searchController.isActive = false
        isSearching = false
        tableView.reloadData()
    }

    
    func getUserData(){
        self.ref = FIRDatabase.database().reference().child("users").child(UserDefaults.standard.value(forKey: "number") as! String)
        var refHandles = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let curString = postDict["lines"] as? [String] {
                self.curLinesString = curString
                //self.emptyLabel.isHidden = true
                self.getCurrentLines()
            } else {
                //self.emptyLabel.isHidden = false
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
        if currentLines.count > 0 || searchController.isActive{
            emptyLabel.isHidden = true
            
        } else {
            emptyLabel.isHidden = false
        }
        if (isSearching) {
            return filteredLines.count
        } else {
            return currentLines.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isSearching) {
            var cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath) as! LineSearchTableViewCell
            cell.selectionStyle = .none
            let line = filteredLines[indexPath.row]
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
            if let user = line.users as! [String]?{
            for (index, element) in line.users!.enumerated() {
                if UserDefaults.standard.value(forKey: "number") as! String == element {
                    cell.currentLinePosition.text = String(index+1)
                }
            }
            }
            //cell.currentLinePosition.text = String(line.count)
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

