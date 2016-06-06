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
import WatchConnectivity
import MBCircularProgressBar
import HealthKit

class HomeViewController: UIViewController, TodayUserDataChangeDelegate {
    let log = XCGLogger.defaultInstance()
    var last7Days = [String]()
    var bgValuesLast7Days = [Double]()
    var dataPoints = [ChartDataPoint]()
    let todaysDate = NSDate()
    

    
    var counter: Int = 0
    
    @IBOutlet weak var bloodGlucoseCircularView: MBCircularProgressBarView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var stepsCircularView: MBCircularProgressBarView!

    @IBOutlet weak var carbsCircularView: MBCircularProgressBarView!
    
    
    @IBOutlet weak var insulinCircularView: MBCircularProgressBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        
        PedagochiUserStatistics.sharedInstance.delegates.append(self)
        PedagochiUserStatistics.sharedInstance.listenOnUSerDataForDate(todaysDate)


        setupChartProperties(lineChartView)
        getLast7DaysPedagochiEntries()
        
        //authorize healthkit
        HealthManager.sharedInstance.authorizeHealthKit({
            success, error in
            if success{
                self.log.debug("healthkit authorised")
                self.outputStepCount()
            }else{
                self.log.debug("failed to authorise healthkit")
            }
        })
        
        
        //notify when app enters foreground
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(enteredForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
     
        
    }
    func enteredForeground(){
        outputStepCount()
        checkIfDateChanged()
    }
    //implemented protocol
    func dataDidChange(snapshot: FDataSnapshot) {
        var cumulativeAverage: Double = 0
        var count: Int = 0
        var carbsSum: Double = 0
        var bolusInsulinSum: Int = 0
        for entry in snapshot.children.allObjects as! [FDataSnapshot]{
            if let bgLevel = entry.value["bloodGlucoseLevel"] as? Double{
                MathFunction.calculator.calculateCumulativeAverage(bgLevel, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                count += 1
            }
            if let value = entry.value["carbs"] as? Double{
                carbsSum = carbsSum + value
            }
            if let value = entry.value["bolusInsulin"] as? Int{
                bolusInsulinSum = bolusInsulinSum + value
            }
        }
        let roundedCumulativeAverage = round(10 * cumulativeAverage) / 10 //round to one decimal place
        bloodGlucoseCircularView.value = CGFloat(roundedCumulativeAverage)
        carbsCircularView.value = CGFloat(carbsSum)
        insulinCircularView.value = CGFloat(bolusInsulinSum)
    }
    
    
    func checkIfDateChanged(){
        if todaysDate.isYesterday() {
            bloodGlucoseCircularView.value = 0
            carbsCircularView.value = 0
            insulinCircularView.value = 0
            
            PedagochiUserStatistics.sharedInstance.listenOnUSerDataForDate(NSDate())
            
        }
    }
    
    func outputStepCount(){
        HealthManager.sharedInstance.getStepCount() {
            result, error in
            if let numberOfSteps = result{
                //let numberOfSteps = Int(quantity.doubleValueForUnit(HealthManager.sharedInstance.stepsUnit))
                self.log.debug("step count is \(numberOfSteps)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.stepsCircularView.setValue(CGFloat(numberOfSteps), animateWithDuration: 1)
                })
            }
        }
    }
    
   
    
 
    
    func progressSet(){
        //progressView.value = 7
        bloodGlucoseCircularView.setValue(7, animateWithDuration: 1)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButton(sender: AnyObject) {
        //remove event observers
        let ref = FirebaseDataService.dataService.currentUserPedagochiEntryReference //observer for chart data
        ref.removeAllObservers()
        
        //remove observer for watch connectivity
        PedagochiWatchConnectivity.connectionManager.removeCurrentDayBGAverageEventObserver()
        FirebaseDataService.dataService.rootReference.unauth()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
        
        self.presentViewController(loginViewController, animated: false, completion: nil)

    }
    func setupChartProperties(lineChartView: LineChartView){
        lineChartView.descriptionText = "Daily average blood glucose"
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        lineChartView.dragEnabled = true
        lineChartView.opaque = false
        lineChartView.backgroundColor = UIColor.clearColor()
        lineChartView.gridBackgroundColor = UIColor.whiteColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.xAxis.setLabelsToSkip(0)
//        lineChartView.xAxis.drawAxisLineEnabled = false
//        lineChartView.xAxis.drawGridLinesEnabled = false
        
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false


        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = true
        lineChartView.rightAxis.drawGridLinesEnabled = false

    }
    
    func drawChart(dataPoints: [ChartDataPoint]){
        
        var dataEntries: [ChartDataEntry] = []
        var xValues: [String] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: dataPoints[i].yValue!, xIndex: i)
            dataEntries.append(dataEntry)
            xValues.append(dataPoints[i].xValue!)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Blood Glucose Level")
        //lineChartDataSet.drawCubicEnabled = true
        //lineChartDataSet.cubicIntensity = 0.2
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.lineWidth = 1.8
        lineChartDataSet.circleRadius = 4.0
        lineChartDataSet.setCircleColor(UIColor.blackColor())
        lineChartDataSet.highlightColor = UIColor(red:244/255.0, green:117/255.0 ,blue:117/255.0, alpha:1)
        lineChartDataSet.setColor(UIColor(red: 44/255.0, green: 99/255.0, blue: 210/255.0, alpha: 1))
        lineChartDataSet.fillColor = UIColor(red: 44/255.0, green: 99/255.0, blue: 210/255.0, alpha: 1)
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        //lineChartDataSet.fillFormatter = CubicLineSampleFillFormatter()
        
        let lineChartData = LineChartData(xVals: xValues, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
//    func didUpdateBGLevelLast7Days(dataPoints: [ChartDataPoint]){
//          self.drawChart(self.dataPoints)
//    }

    
    
    func getLast7DaysPedagochiEntries(){
        let ref = FirebaseDataService.dataService.currentUserPedagochiEntryReference
        //outer event is for last 7 date nodes in firebase
        ref.queryOrderedByKey().queryLimitedToLast(7).observeEventType(.Value, withBlock: {snapshot in
    
            //iterate over last 7 days
            for parentNode in snapshot.children.allObjects as! [FDataSnapshot]{
                let isoDate = parentNode.key
               // create data point if it does not exist
                if self.shouldCreateDataPointIfNotPresent(isoDate) == true{
                    let dataPoint = ChartDataPoint()
                    dataPoint.iso8601Date = isoDate
                    let shortenedDate = self.convertToRepresentableDate(parentNode.key)
                    dataPoint.xValue = shortenedDate

                    dataPoint.yValue = self.calculateCumulativeAverageOfChildren(parentNode)
                    self.dataPoints.insert(dataPoint, atIndex: 0) //prepend to array
                    self.sortArrayInDescendingOrder(&self.dataPoints)
                    self.removeLastItemIfArrayGreaterThanThreshold(&self.dataPoints, threshold: 7)
                    self.log.debug("Average BG Level for \(parentNode.key) is " + String(dataPoint.yValue))
 
                }else{
                    //update current data points
                    if let index = self.dataPoints.indexOf({$0.iso8601Date == isoDate}){
                        self.dataPoints[index].yValue = self.calculateCumulativeAverageOfChildren(parentNode)
                        self.log.debug("Average BG Level for \(parentNode.key) is " + String(self.dataPoints[index].yValue))

                    }
                }

            }
            
            //setup chart
            self.drawChart(self.dataPoints)
            
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
    
    func shouldCreateDataPointIfNotPresent(date: String) -> Bool{
        if dataPoints.indexOf({$0.iso8601Date == date}) == nil{
                return true
        }else{
            return false
        }

    }
    
    func calculateCumulativeAverageOfChildren(parentNode: FDataSnapshot) -> Double{
        var cumulativeAverage: Double = 0
        var count: Int = 0
        for entry in parentNode.children.allObjects as! [FDataSnapshot]{
            
            
            //iterate over Pedagochi entries in parent date node
            if let bloodGlucose = entry.value["bloodGlucoseLevel"] as? Double{
                //self.calculateCumulativeAverage(bloodGlucose, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                MathFunction.calculator.calculateCumulativeAverage(bloodGlucose, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                count += 1
            }
        
            
        }
        return cumulativeAverage
    }
    
    func removeLastItemIfArrayGreaterThanThreshold(inout array: [ChartDataPoint], threshold: Int){
        if array.count > threshold{
            array.removeLast()
        }
    }
    
    func appendToDateArrayWithBound(date: String){
        if last7Days.count > 7{
            last7Days.removeLast()
        }else{
            last7Days.append(date)
        }
    }
    
    func sortArrayInDescendingOrder(inout array:[ChartDataPoint]){
        log.debug("presorted array: \(array.first?.xValue)")
        array.sortInPlace{
            $0.iso8601Date > $1.iso8601Date
        }
        log.debug("sorted array: \(array.last?.xValue)")

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
//    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
//        var command = message["getCurrentDayBGAverage"] as! Bool
//        log.debug("command received is \(command)")
//        testLabel.text = "command received"
//        
//        if command == true{
//            print("command received")
//            //calculateCurrentDayBGAverage()
//        }
//        command = message["stopUpdates"] as! Bool
//        if command == true{
//            //removeCurrentDayBGAverageEventObserver()
//        }
//    }
    
}

//extension HomeViewController: WCSessionDelegate{
//    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
//        var command = message["getCurrentDayBGAverage"] as! Bool
//        log.debug("command received is \(command)")
//        testLabel.text = "command received"
//
//        if command == true{
//            print("command received")
//            //calculateCurrentDayBGAverage()
//        }
//        command = message["stopUpdates"] as! Bool
//        if command == true{
//            //removeCurrentDayBGAverageEventObserver()
//        }
//    }
//}
