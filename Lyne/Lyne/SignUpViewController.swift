//
//  SignUpViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 2/11/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    
    var ref: FIRDatabaseReference!
    
    @IBAction func tappedScreen(_ sender: Any) {
        email.resignFirstResponder()
        number.resignFirstResponder()
        name.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.performSegue(withIdentifier: "signin", sender: self)
            }
        }        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUp(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: number.text!, completion: {(user, error) in
            self.ref = FIRDatabase.database().reference().child("users").child("\(self.number.text!)")
            self.ref.setValue(["email": self.email.text!, "name": self.name.text!, "number":self.number.text!])
            UserDefaults.standard.set(self.number.text!, forKey: "number")
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "signin", sender: self)
        
        })
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
