//
//  MPChartViewController.swift
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

class MPChartViewController: UIViewController, ChartViewDelegate, UIAlertViewDelegate, FIRDatabaseReferenceable {

    var metabolicpanels = [MetabolicPanel]()
    var keys = [String]()
    var val = [Double]()
    var minVal: [Double] = [8.0, 3.9, 1.7, 44.0, 10.0, 0.1, 10.0, 10.0, 9.0, 98.0, 0.5, 70.0, 2.4, 3.7, 135.0]
    var maxVal: [Double] = [37.0, 5.0, 3.5, 147.0, 34.0, 1.9, 20.0, 20.0, 10.5, 106.0, 1.1, 99.0, 4.1, 5.2, 145.0]
    var activeAlert : UIAlertController! = nil
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keys = ["ALT", "Albumin", "AG", "AP", "AST", "Bilirubin", "BUN", "Calcium", "BC", "Chloride", "Fg", "Phosphorus", "Potassium", "Sodium"]
        
        ref.child("MetabolicPanel").queryOrderedByValue().queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: {
            
            self.metabolicpanels.append(MetabolicPanel(snapshot: $0))
            let alt = (self.metabolicpanels[0].ALT)
            let alb = (self.metabolicpanels[0].Albumin)
            let ag = (self.metabolicpanels[0].AG)
            let ap = (self.metabolicpanels[0].AP)
            let ast = (self.metabolicpanels[0].AST)
            let bili = (self.metabolicpanels[0].Bilirubin)
            let bun = (self.metabolicpanels[0].BUN)
            let cal = (self.metabolicpanels[0].Calcium)
            let bc = (self.metabolicpanels[0].BC)
            let chl = (self.metabolicpanels[0].Chloride)
            let fg = (self.metabolicpanels[0].Fg)
            let pho = (self.metabolicpanels[0].Phosphorus)
            let pot = (self.metabolicpanels[0].Potassium)
            let sod = (self.metabolicpanels[0].Sodium)

            self.val += [alt, alb, ag, ap, ast, bili, bun, cal, bc, chl, fg, pho, pot, sod]
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

        
        for i in 0..<dataPoints.count{
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "mg/dl")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.labelCount = 14
        barChartView.xAxis.labelRotationAngle = -45
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
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

class MetabolicPanel: FIRDataObject {
    var ALT: Double = 0.0
    var Albumin: Double = 0.0
    var AG: Double = 0.0
    var AP: Double = 0.0
    var AST: Double = 0.0
    var Bilirubin: Double = 0.0
    var BUN: Double = 0.0
    var Calcium: Double = 0.0
    var BC: Double = 0.0
    var Chloride: Double = 0.0
    var Fg: Double = 0.0
    var Phosphorus: Double = 0.0
    var Potassium: Double = 0.0
    var Sodium: Double = 0.0
}




