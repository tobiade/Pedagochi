//
//  HomeViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 15/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import Charts
import AFDateHelper
import XCGLogger
class HomeViewController: UIViewController {
    let log = XCGLogger.defaultInstance()
    var last7Days = [String]()
    let bgValuesLast7Days = [Double]()

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var calendarView: CLWeeklyCalendarView!
    
    //var calendarView: CLWeeklyCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calendarView = CLWeeklyCalendarView(frame: CGRectMake(0, 277, self.view.bounds.size.width, 92))
        
        //self.view.addSubview(calendarView)

        // Do any additional setup after loading the view.
        
        let days = ["Sunday", "Monday", "Tuesday"]
        let bgLevel = [20.0, 4.0, 6.0]
        setupChart(days, yValues: bgLevel)
        
        log.debug("viewdidload called")
    
        getLast7DaysPedagochiEntries()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButton(sender: AnyObject) {
       
        
       FirebaseDataService.dataService.currentUserPedagochiEntryReference.childByAppendingPath("2016-03-24").removeAllObservers()
        log.debug("logout called")

        FirebaseDataService.dataService.rootReference.unauth()
    }
    
    func setupChart(xValues: [String], yValues:[Double]){
        lineChartView.descriptionText = "Daily average blood glucose"
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        lineChartView.dragEnabled = true
        lineChartView.opaque = false
        lineChartView.backgroundColor = UIColor.clearColor()
        lineChartView.gridBackgroundColor = UIColor.whiteColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.xAxis.setLabelsToSkip(0)
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<xValues.count {
            let dataEntry = ChartDataEntry(value: yValues[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Blood Glucose Level")
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.cubicIntensity = 0.2
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.lineWidth = 1.8
        lineChartDataSet.circleRadius = 4.0
        lineChartDataSet.setCircleColor(UIColor.blackColor())
        lineChartDataSet.highlightColor = UIColor(red:244/255.0, green:117/255.0 ,blue:117/255.0, alpha:1)
        lineChartDataSet.setColor(UIColor.greenColor())
        lineChartDataSet.fillColor = UIColor.blueColor()
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        //lineChartDataSet.fillFormatter = CubicLineSampleFillFormatter()
        
        let lineChartData = LineChartData(xVals: xValues, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
    func getLast7DaysPedagochiEntries(){
        let ref = FirebaseDataService.dataService.currentUserPedagochiEntryReference
        //outer event is for each date node in firebase
        ref.queryOrderedByKey().queryLimitedToLast(7).observeEventType(.ChildAdded, withBlock: {snapshot in
            let date = self.convertToRepresentableDate(snapshot.key)
            self.last7Days.append(date)
            var cumulativeAverage: Double = 0
            var count: Int = 0
            self.log.debug("date - \(snapshot.key)")
            //event fired on each child node added to date node
         
      
        })
        
        ref.childByAppendingPath("2016-03-24").observeEventType(.Value, withBlock: { pedagochiSnapshot in
            
           print("called")
            
//            for entry in pedagochiSnaphot.children.allObjects as! [FDataSnapshot]{
//                if let bloodGlucose = entry.value["bloodGlucoseLevel"] as? Double{
//                    self.calculateCumulativeAverage(bloodGlucose, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
//                    //self.log.debug("blood glucose "+String(bloodGlucose))
//                    count += 1
//                }
//            }
            
            // self.log.debug(snapshot.key + " " + String(cumulativeAverage))
            
        })
        
    }
    
    func convertToRepresentableDate(date: String) -> String{
        let nsdate = NSDate(fromString: date, format: .ISO8601(nil))
        let newDateFormat = nsdate.toString(format: .Custom("dd MMM"))
        return newDateFormat
    }
    
    func calculateCumulativeAverage(newValue: Double, inout cumulativeAverage: Double, numberOfDataPoints: Int){
        cumulativeAverage = (newValue + (Double(numberOfDataPoints)*cumulativeAverage))/(Double(numberOfDataPoints) + 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
