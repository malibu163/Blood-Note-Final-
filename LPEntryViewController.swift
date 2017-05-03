//
//  LPEntryViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 3/23/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LPEntryViewController: UIViewController, UINavigationBarDelegate, FIRDatabaseReferenceable {

    @IBOutlet weak var TC: UITextField!
    @IBOutlet weak var Triglycerides: UITextField!
    @IBOutlet weak var HDL: UITextField!
    @IBOutlet weak var LDL: UITextField!
    
    var lp:LP?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if lp != nil {
            TC.text = lp?.TC!
            Triglycerides.text = lp?.Triglycerides!
            HDL.text = lp?.HDL!
            LDL.text = lp?.LDL!
        }
    }
    
    @IBAction func Done(_ sender: UIBarButtonItem) {
        
        if lp == nil {
            lp = LP()
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        lp?.TC = self.TC.text
        lp?.Triglycerides = self.Triglycerides.text
        lp?.HDL = self.HDL.text
        lp?.LDL = self.LDL.text
        lp?.setDate = dateFormatter.string(from: currentDate)
        
        
        let key = ref.child("LipidProfile").childByAutoId().key
        
        let dictLP = [ "TC"     : lp!.TC! ,
                       "Triglycerides"      : lp!.Triglycerides! ,
                       "HDL"        : lp!.HDL! ,
                       "LDL"        : lp!.LDL! ,
                       "setDate"    : lp!.setDate!]
        
        let childUpdates = ["/LipidProfile/\(key)": dictLP]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
