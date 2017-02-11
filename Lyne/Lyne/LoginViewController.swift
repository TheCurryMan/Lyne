//
//  LoginViewController.swift
//  Lyne
//
//  Created by Avinash Jain on 2/11/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    
    @IBAction func tappedScreen(_ sender: Any) {
        name.resignFirstResponder()
        number.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: name.text!, password: number.text!, completion: {(user,error) in
        
            self.performSegue(withIdentifier: "login", sender: self)
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
