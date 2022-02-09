//
//  UserDefaults.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/4/21.
//

import Foundation

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
        let calender = Calendar.current
        let date1 = calender.startOfDay(for: Date(timeIntervalSince1970: double(forKey: UserDefaultsKeys.lastDatePlayed.rawValue)))
        let date2 = calender.startOfDay(for: Date())
        let components = calender.dateComponents([.day], from: date1, to: date2)
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
        
        //If it is a new day, then reset the current phone usage and add it to statistics
        if (prevDayOfWeek != currDayOfWeek) {
            resetCurrentPhoneUsage()
            
            //THIS VARIABLE IS JUST FOR USER TESTING - remove afterwards
            let currDayUsage = getCurrentDayPhoneUsage()
            var eachDayArray = array(forKey: UserDefaultsKeys.eachDayPhoneUsage.rawValue) ?? []
            eachDayArray.append([prevDayOfWeek, currDayUsage])
            set(eachDayArray, forKey: UserDefaultsKeys.eachDayPhoneUsage.rawValue)
            set(0, forKey: UserDefaultsKeys.currDayPhoneUsage.rawValue)
            //END USER TESTING
            
            
            
            let currWeekUsage = integer(forKey: UserDefaultsKeys.currWeekPhoneUsage.rawValue)
            
            if (currDayOfWeek == 1) {
                set(currWeekUsage, forKey: UserDefaultsKeys.prevWeekPhoneUsage.rawValue)
                set(0, forKey: UserDefaultsKeys.currWeekPhoneUsage.rawValue)
            }
        }
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
    
    case prevWeekPhoneUsage
    case currWeekPhoneUsage
    case currDayPhoneUsage
    case lastUpdatedPhoneUsage
    
    //ONLY FOR TESTING! DELETE LATER
    case eachDayPhoneUsage
}
