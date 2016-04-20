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
class HomeViewController: UIViewController, StepTrackerDelegate {
    let log = XCGLogger.defaultInstance()
    var last7Days = [String]()
    var bgValuesLast7Days = [Double]()
    var dataPoints = [ChartDataPoint]()
    
    var counter: Int = 0
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var calendarView: CLWeeklyCalendarView!
    
//    var session: WCSession? {
//        didSet {
//            if let session = session {
//                
//                session.delegate = self
//                session.activateSession()
//                if session.paired != true {
//                    print("Apple Watch is not paired")
//                }
//                
//                if session.watchAppInstalled != true {
//                    print("WatchKit app is not installed")
//                }
//            }
//        }
//    }
    
    //var calendarView: CLWeeklyCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        StepTrackerManager.sharedInstance.delegate = self
        StepTrackerManager.sharedInstance.startCountingSteps()

        setupChartProperties(lineChartView)
        getLast7DaysPedagochiEntries()
        
//        if WCSession.isSupported() {
//            log.debug("starting session on phone...")
//            
//            session = WCSession.defaultSession()
//        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didStep(val: Float) {
        if val < 0.8{
            log.debug("step!")
            counter+=1
            dispatch_async(dispatch_get_main_queue(), {
                self.testLabel.text = String(self.counter)
            })
        }
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
        lineChartDataSet.setColor(UIColor.greenColor())
        lineChartDataSet.fillColor = UIColor.blueColor()
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
               // create data point if does not exist
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
