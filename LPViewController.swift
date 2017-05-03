//
//  LPViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 4/20/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class LPViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, FIRDatabaseReferenceable {

    @IBOutlet weak var tableView: UITableView!
    
    
    var lpList = [LP]()
    var _currentIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //loadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        loadData()
    }
    
    func loadData() {
        self.lpList.removeAll()
        ref.child("LipidProfile").observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
            if (snapshot.value as? [String:AnyObject]) != nil {
                let lpDict = snapshot.value as? [String:AnyObject]
                let child = LP()
                child.setValuesForKeys(lpDict!)
                self.lpList.append(child)
            }
            self.tableView.reloadData()
            DispatchQueue.main.async() {
                self.tableView.performSelector(onMainThread: #selector(self.tableView.reloadData), with: nil, waitUntilDone: true)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfSections: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return lpList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LPCell")
        let date = self.lpList[(indexPath as NSIndexPath).row]
        if (indexPath.row % 2) == 0 {
            cell?.backgroundColor = UIColor(red: 0.80, green: 0.36, blue: 0.36, alpha: 1.0)
            cell?.textLabel?.textColor = UIColor(red: 0.98, green: 0.92, blue: 0.84, alpha: 1.0)
        }
        else {
            cell?.backgroundColor = UIColor(red: 1.0, green: 0.97, blue: 0.86, alpha: 1.0)
            cell?.textLabel?.textColor = UIColor(red: 0.69, green: 0.13, blue: 0.13, alpha: 1.0)
        }
        cell?.textLabel?.text = date.setDate
        return cell!
    }
    
    func tableView(_tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lpVC = storyboard.instantiateViewController(withIdentifier: "LPVC") as! LPEntryViewController
        self.navigationController?.pushViewController(lpVC, animated: true)
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
