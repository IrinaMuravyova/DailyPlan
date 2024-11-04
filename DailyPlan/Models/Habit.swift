//
//  Habit.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 30.10.2024.
//
import Foundation

struct Habit: Codable {
    
    let habit: String
    let duration: Int
    let timesADay: Int
    let progress: Float
    
    var doOnMonday: Bool //= true
    var doOnTuesday: Bool //= true
    var doOnWednesday: Bool //= true
    var doOnThursday: Bool //= true
    var doOnFriday: Bool //= true
    var doOnSaturday: Bool //= true
    var doOnSunday: Bool //= true
    
    let habitDone: Bool
    var doneImageName: String = "habitDone"
    //TODO: дописать id
    let id: Int
    
    static func getExampleHabitsList() -> [Habit] {
        [
            Habit(
                habit: "Заниматься английским",
                duration: 3,
                timesADay: 2,
                progress: 10,
                doOnMonday: false,
                doOnTuesday: false,
                doOnWednesday: false,
                doOnThursday: false,
                doOnFriday: false,
                doOnSaturday: false,
                doOnSunday: false,
                habitDone: false,
                id: 1
            ),
            Habit(
                habit: "Делать тело",
                duration: 90,
                timesADay: 1,
                progress: 1,
                doOnMonday: false,
                doOnTuesday: false,
                doOnWednesday: false,
                doOnThursday: false,
                doOnFriday: false,
                doOnSaturday: false,
                doOnSunday: false,
                habitDone: false,
                id: 2
            ),
            Habit(
                habit: "Читать",
                duration: 120,
                timesADay: 1,
                progress: 70,
                doOnMonday: true,
                doOnTuesday: false,
                doOnWednesday: false,
                doOnThursday: false,
                doOnFriday: false,
                doOnSaturday: false,
                doOnSunday: false,
                habitDone: false,
                id: 3
            )
        ]
    }
    
    private func addHabit() {}
    private func deleteHabit() {}
    private func markHabit() {}
    private func changeHabit() {}
}

enum Days: String {
    case monday    = "ПН"
    case tuesday   = "ВТ"
    case wednesday = "СР"
    case thursday  = "ЧТ"
    case friday    = "ПТ"
    case saturday  = "СБ"
    case sunday    = "ВС"
}

struct HabitCalendar: Codable {
    let year: Int
    let month: Int
    let day: Int  
    let habitID: Int
    var habitDone: Bool = false
    var timesADateDone: Int = 0
    //TODO: дописать id
    var id: Int = 0
    
    static func getHabitCalendarExamples() -> [HabitCalendar] {
        [HabitCalendar(year: 2024,
                       month: 10,
                       day: 30,
                       habitID: 1,
                       habitDone: false,
                       timesADateDone: 1),
         HabitCalendar(year: 2024,
                       month: 10,
                       day: 29,
                       habitID: 1,
                       habitDone: true,
                       timesADateDone: 2),
         HabitCalendar(year: 2024,
                       month: 10,
                       day: 28,
                       habitID: 1,
                       habitDone: true,
                       timesADateDone: 2),
         HabitCalendar(year: 2024,
                       month: 10,
                       day: 30,
                       habitID: 3,
                       habitDone: false,
                       timesADateDone: 1)
        ]
    }
}

