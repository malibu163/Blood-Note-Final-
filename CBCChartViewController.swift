//
//  CBCChartViewController.swift
//  BloodNoteFinal
//
//  Created by Steve David on 4/7/17.
//  Copyright © 2017 Steve David. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAnalytics
import Charts

class CBCChartViewController: UIViewController, ChartViewDelegate, UIAlertViewDelegate, FIRDatabaseReferenceable {
    
    var cbcs = [CBC]()
    var keys = [String]()
    var val = [Double]()
    var minVal: [Double] = [4.3, 4.2, 37.0, 12.0, 80.0, 27.0, 28.0, 11.0, 150.0, 7.5]
    var maxVal: [Double] = [10.8, 5.9, 48.0, 18.0, 100.0, 32.0, 36.0, 15.0, 400.0, 11.5]
    var activeAlert : UIAlertController! = nil
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keys = ["WBC", "RBC", "Hct", "Hgb", "MCV", "MCH", "MCHC", "RCDW", "Platelet", "MPV"]
        
        ref.child("CompleteBloodCount").queryOrderedByValue().queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: {
            
            self.cbcs.append(CBC(snapshot: $0))
            let wbc = (self.cbcs[0].WBC)
            let rbc = (self.cbcs[0].RBC)
            let hct = (self.cbcs[0].Hct)
            let hgb = (self.cbcs[0].Hgb)
            let mcv = (self.cbcs[0].MCV)
            let mch = (self.cbcs[0].MCH)
            let mchc = (self.cbcs[0].MCHC)
            let rcdw = (self.cbcs[0].RCDW)
            let plat = (self.cbcs[0].Platelet)
            let mpv = (self.cbcs[0].MPV)
            
            self.val += [wbc, rbc, hct, hgb, mcv, mch, mchc, rcdw, plat, mpv]
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
        
        // Do any additional setup after loading the view.
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

class CBC: FIRDataObject{
    
    var WBC: Double = 0.0
    var RBC: Double = 0.0
    var Hct: Double = 0.0
    var Hgb: Double = 0.0
    var MCV: Double = 0.0
    var MCH: Double = 0.0
    var MCHC: Double = 0.0
    var RCDW: Double = 0.0
    var Platelet: Double = 0.0
    var MPV: Double = 0.0
    
}
    



