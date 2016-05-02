//
//  LogGoal.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 02/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import CareKit

struct LogGoal: Activity {
    let activityType: ActivityType = .LogGoal
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.dailyScheduleWithStartDate(startDate, occurrencesPerDay: 3)
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Logging Goal", comment: "")
        let summary = NSLocalizedString("5", comment: "")
        let instructions = NSLocalizedString("Log your blood glucose levels and carbs at least 3 times today", comment: "")
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.interventionWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.Yellow.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }

}