//
//  ThyroidViewController.swift
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

class ThyroidChartViewController: UIViewController, ChartViewDelegate, UIAlertViewDelegate, FIRDatabaseReferenceable {

    var thyroids = [Thyroid]()
    var keys = [String]()
    var val = [Double]()
    var minVal: [Double] = [0.3, 4.5, 0.7, 80.0, 2.3]
    var maxVal: [Double] = [3.0, 12.5, 2.0, 220.0, 4.2]
    var activeAlert : UIAlertController! = nil
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keys = ["TSH", "TotalT4", "FreeT4", "TotalT3", "FreeT3"]
        
        ref.child("Thyroid").queryOrderedByValue().queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: {
            
            self.thyroids.append(Thyroid(snapshot: $0))
            let tsh = self.thyroids[0].TSH
            let tt4 = self.thyroids[0].TotalT4
            let ft4 = self.thyroids[0].FreeT4
            let tt3 = self.thyroids[0].TotalT3
            let ft3 = self.thyroids[0].FreeT3
            self.val += [tsh, tt4, ft4, tt3, ft3]
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

class Thyroid: FIRDataObject{
    var TSH: Double = 0.0
    var TotalT4: Double = 0.0
    var FreeT4: Double = 0.0
    var TotalT3: Double = 0.0
    var FreeT3: Double = 0.0
}
