//
//  CBCEntryViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 3/23/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CBCEntryViewController: UIViewController, FIRDatabaseReferenceable {

    @IBOutlet weak var WBC: UITextField!
    @IBOutlet weak var RBC: UITextField!
    @IBOutlet weak var Hct: UITextField!
    @IBOutlet weak var Hgb: UITextField!
    @IBOutlet weak var MCV: UITextField!
    @IBOutlet weak var MCH: UITextField!
    @IBOutlet weak var MCHC: UITextField!
    @IBOutlet weak var RCDW: UITextField!
    @IBOutlet weak var Platelet: UITextField!
    @IBOutlet weak var MPV: UITextField!
    
    
    var cb:CB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.cb != nil {
            WBC.text = self.cb?.WBC
            RBC.text = self.cb?.RBC
            Hct.text = self.cb?.Hct
            Hgb.text = self.cb?.Hgb
            MCV.text = self.cb?.MCV
            MCH.text = self.cb?.MCH
            MCHC.text = self.cb?.MCHC
            RCDW.text = self.cb?.RCDW
            Platelet.text = self.cb?.Platelet
            MPV.text = self.cb?.MPV
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func Done(_ sender: UIBarButtonItem) {
    
        if cb == nil {
            cb = CB()
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        cb?.WBC = self.WBC.text
        cb?.RBC = self.RBC.text
        cb?.Hct = self.Hct.text
        cb?.Hgb = self.Hgb.text
        cb?.MCV = self.MCV.text
        cb?.MCH = self.MCH.text
        cb?.MCHC = self.MCHC.text
        cb?.RCDW = self.RCDW.text
        cb?.Platelet = self.Platelet.text
        cb?.MPV = self.MPV.text
        cb?.setDate = dateFormatter.string(from: currentDate)
        
        let key = ref.child("CompleteBloodCount").childByAutoId().key
        
        let dictCB = [ "WBC"       : cb!.WBC! ,
                       "RBC"       : cb!.RBC! ,
                       "Hct"       : cb!.Hct! ,
                       "Hgb"       : cb!.Hgb! ,
                       "MCV"       : cb!.MCV! ,
                       "MCH"       : cb!.MCH! ,
                       "MCHC"      : cb!.MCHC! ,
                       "RCDW"      : cb!.RCDW! ,
                       "Platelet"  : cb!.Platelet! ,
                       "MPV"       : cb!.MPV! ,
                       "setDate"   : cb!.setDate!]
        let childUpdates = ["/CompleteBloodCount/\(key)": dictCB]
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
