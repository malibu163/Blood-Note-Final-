//
//  FIRDataObject.swift
//  BloodNoteFinal
//
//  Created by Steve David on 4/7/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import Foundation
import Firebase

class FIRDataObject: NSObject {
    
    let snapshot: FIRDataSnapshot
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    
    required init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                if ((child.value) as? String) != nil{
                    let Value = (child.value) as! String
                    let myvalue = Double(Value)
                    setValue(myvalue, forKey: child.key)
                }
            }
        }
    }
}

protocol FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference { get }
}

extension FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference {
        return FIRDatabase.database().reference()
        
    }
}

