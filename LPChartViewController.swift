//
//  LPChartViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 3/27/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import Charts
import FirebaseDatabase
import FirebaseAnalytics


class LPChartViewController: UIViewController, ChartViewDelegate, UIAlertViewDelegate, FIRDatabaseReferenceable {
    
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    var lipidprofiles = [LipidProfile]()
    var keys = [String]()
    var val = [Double]()
    var minVal: [Double] = [150.0, 40.0, 50.0, 50.0]
    var maxVal: [Double] = [240.0, 160.0, 100.0, 160.0]
    var activeAlert : UIAlertController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keys = ["TC", "Triglycerides", "HDL", "LDL"]
        
        ref.child("LipidProfile").queryOrderedByValue().queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: {
            
            self.lipidprofiles.append(LipidProfile(snapshot: $0))
            let tc = (self.lipidprofiles[0].TC)
            let tri = (self.lipidprofiles[0].Triglycerides)
            let hdl = (self.lipidprofiles[0].HDL)
            let ldl = (self.lipidprofiles[0].LDL)
            
            self.val = [tc, tri, hdl, ldl]
            self.setChart(dataPoints: self.keys, values: self.val)
            for i in 0..<self.keys.count{
                if (self.val[i] < self.minVal[i]) {
                    self.displayAlert(title: "Attention Required", message: "Your \(self.keys[i]): \(self.val[i]), fell BELOW the optimal range. Please consider consulting your physician")
                }
                if (self.val[i] > self.maxVal[i]) {
                    self.displayAlert(title: "Attention Required", message: "Your \(self.keys[i]): \(self.val[i]), fell ABOVE the optimal range. Please consider consulting your physician")
                }
                
            }
        })
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "mg/dl")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.xAxis.granularity = 1
        barChartView.extraTopOffset = 40.0
        barChartView.extraBottomOffset = 10.0
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        barChartView.data = chartData
        
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
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

class LipidProfile: FIRDataObject {
    
    var TC: Double = 0.0
    var Triglycerides: Double = 0.0
    var HDL: Double = 0.0
    var LDL: Double = 0.0
    
}


