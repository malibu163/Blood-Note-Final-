//
//  MPEntryViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 3/20/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MPEntryViewController: UIViewController, FIRDatabaseReferenceable {

    @IBOutlet weak var ALT: UITextField!
    
    @IBOutlet weak var Albumin: UITextField!
    
    @IBOutlet weak var AG: UITextField!
    
    @IBOutlet weak var AP: UITextField!
    
    @IBOutlet weak var AST: UITextField!
    
    @IBOutlet weak var Bilirubin: UITextField!
    
    @IBOutlet weak var BUN: UITextField!
    
    @IBOutlet weak var Calcium: UITextField!
    
    @IBOutlet weak var BC: UITextField!
    
    @IBOutlet weak var Chloride: UITextField!
    
    @IBOutlet weak var Creatinine: UITextField!
    
    @IBOutlet weak var Fg: UITextField!
    
    @IBOutlet weak var Phosphorus: UITextField!
    
    @IBOutlet weak var Potassium: UITextField!
    
    @IBOutlet weak var Sodium: UITextField!
    
    
    var mp:MP?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.mp != nil {
            ALT.text = self.mp?.ALT
            Albumin.text = self.mp?.Albumin
            AG.text = self.mp?.AG
            AP.text = self.mp?.AP
            AST.text = self.mp?.AST
            Bilirubin.text = self.mp?.Bilirubin
            BUN.text = self.mp?.BUN
            Calcium.text = self.mp?.Calcium
            BC.text = self.mp?.BC
            Chloride.text = self.mp?.Chloride
            Fg.text = self.mp?.Fg
            Phosphorus.text = self.mp?.Phosphorus
            Potassium.text = self.mp?.Potassium
            Sodium.text = self.mp?.Sodium
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func Done(_ sender: UIBarButtonItem) {
        
        if mp == nil {
            mp = MP()
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        mp?.ALT = self.ALT.text
        mp?.Albumin = self.Albumin.text
        mp?.AG = self.AG.text
        mp?.AP = self.AP.text
        mp?.AST = self.AST.text
        mp?.Bilirubin = self.Bilirubin.text
        mp?.BUN = self.BUN.text
        mp?.Calcium = self.Calcium.text
        mp?.BC = self.BC.text
        mp?.Chloride = self.Chloride.text
        mp?.Fg = self.Fg.text
        mp?.Phosphorus = self.Phosphorus.text
        mp?.Potassium = self.Potassium.text
        mp?.Sodium = self.Sodium.text
        mp?.setDate = dateFormatter.string(from: currentDate)
        
        let key = ref.child("MetabolicPanel").childByAutoId().key
        
        let dictMP = [  "ALT"         : mp!.ALT! ,
                        "Albumin"     : mp!.Albumin! ,
                        "AG"          : mp!.AG! ,
                        "AP"          : mp!.AP! ,
                        "AST"         : mp!.AST! ,
                        "Bilirubin"   : mp!.Bilirubin! ,
                        "BUN"         : mp!.BUN! ,
                        "Calcium"     : mp!.Calcium! ,
                        "BC"          : mp!.BC! ,
                        "Chloride"    : mp!.Chloride! ,
                        "Fg"          : mp!.Fg! ,
                        "Phosphorus"  : mp!.Phosphorus! ,
                        "Potassium"   : mp!.Potassium! ,
                        "Sodium"      : mp!.Sodium! ,
                        "setDate"     : mp!.setDate!]
        
        let childUpdates = ["/MetabolicPanel/\(key)": dictMP]
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

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
