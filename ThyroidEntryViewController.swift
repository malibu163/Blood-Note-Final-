//
//  ThyroidEntryViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 3/27/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ThyroidEntryViewController: UIViewController, UINavigationBarDelegate, FIRDatabaseReferenceable {
    
    
    @IBOutlet weak var TSH: UITextField!
    @IBOutlet weak var TotalT4: UITextField!
    @IBOutlet weak var FreeT4: UITextField!
    @IBOutlet weak var TotalT3: UITextField!
    @IBOutlet weak var FreeT3: UITextField!
    
    var tp:TP?

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tp != nil {
            TSH.text = self.tp?.TSH
            TotalT4.text = self.tp?.TotalT4
            FreeT4.text = self.tp?.FreeT4
            TotalT3.text = self.tp?.TotalT3
            FreeT3.text = self.tp?.FreeT3
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Done(_ sender: UIBarButtonItem) {
        
        if tp == nil {
            tp = TP()
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        tp?.TSH = self.TSH.text
        tp?.TotalT4 = self.TotalT4.text
        tp?.FreeT4 = self.FreeT4.text
        tp?.TotalT3 = self.TotalT3.text
        tp?.FreeT3 = self.FreeT3.text
        tp?.setDate = dateFormatter.string(from: currentDate)
        
        let key = ref.child("Thyroid").childByAutoId().key
        
        let dictTP = [ "TSH"    : tp!.TSH! ,
                       "TotalT4"    : tp!.TotalT4! ,
                       "FreeT4"     : tp!.FreeT4! ,
                       "TotalT3"    : tp!.TotalT3! ,
                       "FreeT3"     : tp!.FreeT3! ,
                       "setDate"    : tp!.setDate!]
        
        let childUpdates = ["/Thyroid/\(key)": dictTP]
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
