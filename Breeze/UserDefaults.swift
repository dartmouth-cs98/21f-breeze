//
//  UserDefaults.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/4/21.
//

import Foundation
import SendGrid

// getters and setters for stander UserDefaults data
extension UserDefaults{

    // example usage:
    // UserDefaults.standard.setPoints(value: 90)
    func setPoints(value: Int) {
        var currPoints: Int = integer(forKey: UserDefaultsKeys.points.rawValue)
        currPoints += value
        set(currPoints, forKey: UserDefaultsKeys.points.rawValue)
    }

    // example usage:
    // UserDefaults.standard.getPoints()
    func getPoints()-> Int {
        return integer(forKey: UserDefaultsKeys.points.rawValue)
    }

    func setStreak(value: Int){
        set(value, forKey: UserDefaultsKeys.streak.rawValue)
    }

    func getStreak() -> Int{
        return integer(forKey: UserDefaultsKeys.streak.rawValue)
    }
    
    func setTime(value: Int){
        set(value, forKey: UserDefaultsKeys.timeInMinutes.rawValue)
    }

    func getTime() -> Int{
        return integer(forKey: UserDefaultsKeys.timeInMinutes.rawValue)
    }
    
    func setSetupBool(value: Bool) {
        set(value, forKey: UserDefaultsKeys.setup.rawValue)
    }

    func isSetup()-> Bool {
        return bool(forKey: UserDefaultsKeys.setup.rawValue)
    }
    
    func setGameStatus(value: Bool) {
        set(value, forKey: UserDefaultsKeys.endedGame.rawValue)
    }
    
    func isEnded() -> Bool {
        return bool(forKey: UserDefaultsKeys.endedGame.rawValue)
    }
    
    func setLastDatePlayedToToday() {
        set(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastDatePlayed.rawValue)
    }
    
    func getDaysFromLastPlay() -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date(timeIntervalSince1970: double(forKey: UserDefaultsKeys.lastDatePlayed.rawValue)))
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
        
    }
    
    // example usage:
    // UserDefaults.standard.setPoints(value: 90)
    func setNumClicks(value: Int) {
        set(value, forKey: UserDefaultsKeys.numClicks.rawValue)
    }

    // example usage:
    // UserDefaults.standard.getPoints()
    func getNumClicks()-> Int {
        return integer(forKey: UserDefaultsKeys.numClicks.rawValue)

    }
    
    func getPreviousProtectedDataStatus()-> Bool {
        return bool(forKey: UserDefaultsKeys.previousProtectedDataStatus.rawValue)
    }

    func setPreviousProtectedDataStatus(value: Bool){
        set(value, forKey: UserDefaultsKeys.previousProtectedDataStatus.rawValue)
    }
    
    func getSecondsElapsedFromLastTimeProtectedDataStatusChecked()-> Int {
        let calender = Calendar.current
        
        let date1 = Date(timeIntervalSince1970: double(forKey: UserDefaultsKeys.lastTimeProtectedDataStatusChecked.rawValue))
        let date2 = Date()
        let components = calender.dateComponents([.second], from: date1, to: date2)
        return components.second ?? 0
    }

    func setLastTimeProtectedDataStatusChecked(){
        set(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastTimeProtectedDataStatusChecked.rawValue)
    }
    
    func getCurrentPhoneUsage() -> Int {
        return integer(forKey: UserDefaultsKeys.currentPhoneUsage.rawValue)
    }
    
    func getCurrentWeekPhoneUsage() -> Int {
        return integer(forKey: UserDefaultsKeys.currWeekPhoneUsage.rawValue)
    }
    
    func getPreviousWeekPhoneUsage() -> Int {
        return integer(forKey: UserDefaultsKeys.prevWeekPhoneUsage.rawValue)
    }
    
    func getCurrentDayPhoneUsage() -> Int {
        return integer(forKey: UserDefaultsKeys.currDayPhoneUsage.rawValue)
    }
    
    //
    func setCurrentIsland(value: Int){
        set(value, forKey: UserDefaultsKeys.currentIsland.rawValue)
    }
    
    func getCurrentIsland() -> Int {
        return integer(forKey: UserDefaultsKeys.currentIsland.rawValue)
    }
    //
    func addIntervalToCurrentPhoneUsage() {
        let secondsElapsed = getSecondsElapsedFromLastTimeProtectedDataStatusChecked()
        print("Seconds elapsed since last check: " + String(secondsElapsed))
        
        let currentPhoneUsage = getCurrentPhoneUsage()
        let currDayPhoneUsage = getCurrentDayPhoneUsage()
        let currWeekPhoneUsage = getCurrentWeekPhoneUsage()
        
        set((currentPhoneUsage + Int(secondsElapsed)), forKey: UserDefaultsKeys.currentPhoneUsage.rawValue)
        set((currDayPhoneUsage + Int(secondsElapsed)), forKey: UserDefaultsKeys.currDayPhoneUsage.rawValue)
        set((currWeekPhoneUsage + Int(secondsElapsed)), forKey: UserDefaultsKeys.currWeekPhoneUsage.rawValue)
    }
    
    func resetCurrentPhoneUsage() {
        set(0, forKey: UserDefaultsKeys.currentPhoneUsage.rawValue)
        print("reset")
        print(getCurrentPhoneUsage())
    }
    
    func isAboveTimeLimit() -> Bool {
        let currentPhoneUsage = getCurrentPhoneUsage()
        print("Current phone usage (in seconds): " + String(currentPhoneUsage))
        print("Current phone usage (in seconds): " + String(currentPhoneUsage/60))
        
        let timeLimit = getTime()
        print("Time limit: " + String(timeLimit))
        if ((currentPhoneUsage/60) >= timeLimit && timeLimit > 0) {
            return true
        } else {
            return false
        }
    }
    
    func islandLevelUp(value: Int) {
        if (value == 1) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island1.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island1.rawValue)
        }
        else if (value == 2) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island2.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island2.rawValue)
        }
        else if (value == 3) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island3.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island3.rawValue)
        }
        else if (value == 4) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island4.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island4.rawValue)
        }
        else if (value == 5) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island5.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island5.rawValue)
        }
    }
    
    func islandGetLevel(value: Int) -> Int {
        if (value == 1) {
            return integer(forKey: UserDefaultsKeys.island1.rawValue)
        }
        else if (value == 2) {
            return integer(forKey: UserDefaultsKeys.island2.rawValue)
        }
        else if (value == 3) {
            return integer(forKey: UserDefaultsKeys.island3.rawValue)
        }
        else if (value == 4) {
            return integer(forKey: UserDefaultsKeys.island4.rawValue)
        }
        else if (value == 5) {
            return integer(forKey: UserDefaultsKeys.island5.rawValue)
        }
        else {
            return 0
        }
    }
    
    func resetMap() {
        set(0, forKey: UserDefaultsKeys.island1.rawValue)
        set(0, forKey: UserDefaultsKeys.island2.rawValue)
        set(0, forKey: UserDefaultsKeys.island3.rawValue)
        set(0, forKey: UserDefaultsKeys.island4.rawValue)
        set(0, forKey: UserDefaultsKeys.island5.rawValue)
        set(0, forKey: UserDefaultsKeys.currentIsland.rawValue)
    }
    
    func checkDayRollover() {
        // if lastTimeProtectedDataStatusChecked is previous day, then store previous day's time and send to Sendgrid??
        let calendar = Calendar.current
        let prevDate = Date(timeIntervalSince1970: double(forKey: UserDefaultsKeys.lastTimeProtectedDataStatusChecked.rawValue))
        let prevComponents = calendar.dateComponents([.weekday], from: prevDate)
        let prevDayOfWeek = prevComponents.weekday
        
        let currDate = Date()
        let currComponents = calendar.dateComponents([.weekday], from: currDate)
        let currDayOfWeek = currComponents.weekday
        
        //If it is a new day, then reset the current phone usage and add it to statistics and send to Sendgrid
        if (prevDayOfWeek != currDayOfWeek) {
            resetCurrentPhoneUsage()
            
            //THIS VARIABLE IS JUST FOR USER TESTING - remove afterwards
            let currDayUsage = getCurrentDayPhoneUsage()
            var eachDayArray = array(forKey: UserDefaultsKeys.eachDayPhoneUsage.rawValue) ?? []
            eachDayArray.append([prevDayOfWeek, currDayUsage])
            set(eachDayArray, forKey: UserDefaultsKeys.eachDayPhoneUsage.rawValue)
            sendUserDataToBreeze()
            
            set(0, forKey: UserDefaultsKeys.currDayPhoneUsage.rawValue) //Now reset current day phone usage
            //END USER TESTING
                        
            if (currDayOfWeek == 1) { //Sunday: roll over statistics
                let currWeekUsage = integer(forKey: UserDefaultsKeys.currWeekPhoneUsage.rawValue)
                set(currWeekUsage, forKey: UserDefaultsKeys.prevWeekPhoneUsage.rawValue)
                set(0, forKey: UserDefaultsKeys.currWeekPhoneUsage.rawValue)
                rollOverNotifications()
            }
        }
    }
    
    //Sendgrid API call to output data
    func sendUserDataToBreeze() {
        let session = Session()
        let SG_KEY="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"
        session.authentication = Authentication.apiKey(SG_KEY)
        
        // Send a basic example
        let personalization = Personalization(recipients: "test@example.com")
        let plainText = Content(contentType: ContentType.plainText, value: "User spent " + string(forKey: UserDefaultsKeys.currDayPhoneUsage.rawValue) + )
        let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>Hello World</h1>")
        let email = Email(
            personalizations: [personalization],
            from: "foo@bar.com",
            content: [plainText, htmlText],
            subject: "Hello World"
        )
        do {
            try Session.shared.send(request: email)
        } catch {
            print(error)
        }
    }
    
    func getCurrNotificationSends() -> Int {
        return integer(forKey: UserDefaultsKeys.notificationsSentCurrWeek.rawValue)
    }
    
    func getCurrNotificationClicks() -> Int {
        return integer(forKey: UserDefaultsKeys.notificationsClickedCurrWeek.rawValue)
    }
    
    func getCurrNotificationSnoozes() -> Int {
        return integer(forKey: UserDefaultsKeys.notificationsSnoozedCurrWeek.rawValue)
    }
    
    func getLastWeekNotificationSends() -> Int {
        return integer(forKey: UserDefaultsKeys.notificationsSentLastWeek.rawValue)
    }
    
    func getLastWeekNotificationClicks() -> Int {
        return integer(forKey: UserDefaultsKeys.notificationsClickedLastWeek.rawValue)
    }
    
    func getLastWeekNotificationSnoozes() -> Int {
        return integer(forKey: UserDefaultsKeys.notificationsSnoozedLastWeek.rawValue)
    }
    
    func addNotificationSent() {
        let currNotificationSends = getCurrNotificationSends()
        set(currNotificationSends + 1, forKey: UserDefaultsKeys.notificationsSentCurrWeek.rawValue)
    }
    func addNotificationClick() {
        let currNotificationClicks = getCurrNotificationClicks()
        set(currNotificationClicks + 1, forKey: UserDefaultsKeys.notificationsClickedCurrWeek.rawValue)
    }
    
    func addNotificationSnooze() {
        let currNotificationSnoozes = getCurrNotificationSnoozes()
        set(currNotificationSnoozes + 1, forKey: UserDefaultsKeys.notificationsSnoozedCurrWeek.rawValue)
    }

    func rollOverNotifications() {
        let currNotificationSends = getCurrNotificationSends()
        let currNotificationClicks = getCurrNotificationClicks()
        let currNotificationSnoozes = getCurrNotificationSnoozes()
        
        set(currNotificationSends, forKey: UserDefaultsKeys.notificationsSentLastWeek.rawValue)
        set(currNotificationClicks, forKey: UserDefaultsKeys.notificationsClickedLastWeek.rawValue)
        set(currNotificationSnoozes, forKey: UserDefaultsKeys.notificationsSnoozedLastWeek.rawValue)
    }
    
    func getProportionWeekSpent() -> Double {
        //Current Date
        let calendar = Calendar.current
        let currDate = Date()
        let dayComponents = calendar.dateComponents([.weekday], from: currDate)
        let dayOfWeek = Int(dayComponents.weekday ?? 1)
        let hourOfDay = calendar.component(.hour, from: currDate)
        print("day: " + String(dayOfWeek))
        print("hour: " + String(hourOfDay)) //HOW TO GET THIS TO MILITARY TIME
        return Double((dayOfWeek-1 + (hourOfDay / 24)) / 7)
    }
}

enum UserDefaultsKeys : String {
    case points
    case streak
    case timeInMinutes
    case endedGame
    case setup
    case numClicks
    case lastDatePlayed
    case previousProtectedDataStatus
    case lastTimeProtectedDataStatusChecked
    case currentPhoneUsage
    case island1
    case island2
    case island3
    case island4
    case island5
    case currentIsland
    
    //Statistics page
    case prevWeekPhoneUsage
    case currWeekPhoneUsage
    case lastUpdatedPhoneUsage
    case notificationsClickedLastWeek
    case notificationsSentLastWeek
    case notificationsSnoozedLastWeek
    case notificationsClickedCurrWeek
    case notificationsSentCurrWeek
    case notificationsSnoozedCurrWeek
    
    //ONLY FOR TESTING! DELETE LATER
    case eachDayPhoneUsage //This variable will be displayed in a view that can be accessed from settings page for user testers - just in case Sendgrid doesn't work...
    case currDayPhoneUsage
}
