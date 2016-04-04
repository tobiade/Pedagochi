////
////  PedagochiDataService.swift
////  Pedagochi
////
////  Created by Lanre Durosinmi-Etti on 02/04/2016.
////  Copyright © 2016 Tobi Adewuyi. All rights reserved.
////
//import WatchKit
//import Foundation
//import Firebase
//import XCGLogger
//
//protocol PedagochiDataServiceDelegate{
//    func didUpdateBGLevelLast7Days(dataPoints: [ChartDataPoint])
//}
//class PedagochiDataService {
//    var viewControllerDelegate: HomeViewController?
//    var interfaceControllerDelegate: InterfaceController?
//    private var dataPoints = [ChartDataPoint]()
//    let log = XCGLogger.defaultInstance()
//    
//    
//    
//    
//    func getLast7DaysPedagochiEntries(){
//        let ref = FirebaseDataService.dataService.currentUserPedagochiEntryReference
//        //outer event is for last 7 date nodes in firebase
//        ref.queryOrderedByKey().queryLimitedToLast(7).observeEventType(.Value, withBlock: {snapshot in
//            
//            //iterate over last 7 days
//            for parentNode in snapshot.children.allObjects as! [FDataSnapshot]{
//                
//                let date = self.convertToRepresentableDate(parentNode.key)
//                // create data point if does not exist
//                if self.shouldCreateDataPointIfNotPresent(date) == true{
//                    let dataPoint = ChartDataPoint()
//                    dataPoint.xValue = date
//                    
//                    dataPoint.yValue = self.calculateCumulativeAverage(parentNode)
//                    self.dataPoints.insert(dataPoint, atIndex: 0) //prepend to array
//                    self.sortArrayInDescendingOrder(&self.dataPoints)
//                    self.removeLastItemIfArrayGreaterThanThreshold(&self.dataPoints, threshold: 7)
//                    self.log.debug("Average BG Level for \(parentNode.key) is " + String(dataPoint.yValue))
//                    
//                    
//                }else{
//                    //update current data points
//                    if let index = self.dataPoints.indexOf({$0.xValue == date}){
//                        self.dataPoints[index].yValue = self.calculateCumulativeAverage(parentNode)
//                        self.log.debug("Average BG Level for \(parentNode.key) is " + String(self.dataPoints[index].yValue))
//                        
//                    }
//                }
//                
//            }
//            self.viewControllerDelegate?.didUpdateBGLevelLast7Days(self.dataPoints)
//        
//            
//        })
//        
//        
//        
//    }
//    
//    func convertToRepresentableDate(date: String) -> String{
//        let nsdate = NSDate(fromString: date, format: .ISO8601(nil))
//        let newDateFormat = nsdate.toString(format: .Custom("dd MMM"))
//        return newDateFormat
//    }
//    
//    func calculateCumulativeAverage(parentNode: FDataSnapshot) -> Double{
//        var cumulativeAverage: Double = 0
//        var count: Int = 0
//        for entry in parentNode.children.allObjects as! [FDataSnapshot]{
//            
//            
//            //iterate over Pedagochi entries in parent date node
//            if let bloodGlucose = entry.value["bloodGlucoseLevel"] as? Double{
//                self.calculateCumulativeAverage(bloodGlucose, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
//                count += 1
//            }
//            
//            
//        }
//        return cumulativeAverage
//    }
//    
//    func removeLastItemIfArrayGreaterThanThreshold(inout array: [ChartDataPoint], threshold: Int){
//        if array.count > threshold{
//            array.removeLast()
//        }
//    }
//    
//    func shouldCreateDataPointIfNotPresent(date: String) -> Bool{
//        if dataPoints.indexOf({$0.xValue == date}) == nil{
//            return true
//        }else{
//            return false
//        }
//        
//    }
//    
//    func sortArrayInDescendingOrder(inout array:[ChartDataPoint]){
//        array.sortInPlace{
//            $0.xValue > $1.xValue
//        }
//    }
//
//}