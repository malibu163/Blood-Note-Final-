//
//  ViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 3/7/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import LocalAuthentication

class ViewController: UIViewController, FIRDatabaseReferenceable {

    @IBAction func Authenticate(_ sender: Any)
    {
        let context:LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need your TouchID", reply: { (wasSuccessful, error) in
                if wasSuccessful
                {
                    self.performSegue(withIdentifier: "ToTab", sender: self)
                    
                }
                else
                {
                    print ("NOT LOGGED IN")
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

