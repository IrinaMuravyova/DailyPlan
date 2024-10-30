//
//  Habit.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 30.10.2024.
//
import Foundation

struct Habit {
    
    let habit: String
    let duration: Int
    let timesADay: Int
    let progress: Float
    let habitDone: Bool
    let doneImageName: String = "habitDone"
    //TODO: дописать id
    let id: Int
    
    static func getExampleHabitsList() -> [Habit] {
        [
            Habit(
                habit: "Заниматься английским",
                duration: 3,
                timesADay: 2,
                progress: 10,
                habitDone: false,
                id: 1
            ),
            Habit(
                habit: "Делать тело",
                duration: 90,
                timesADay: 1,
                progress: 1,
                habitDone: false,
                id: 2
            ),
            Habit(
                habit: "Читать",
                duration: 120,
                timesADay: 1,
                progress: 70,
                habitDone: true,
                id: 3
            )
        ]
    }
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

struct HabitCalendar {
    let year: Int
    let month: Int
    let day: Int
//    var date: String {
//        "\(year)-\(month)-\(day)"
//    }
    
    let habitID: Int
    var habitDone: Bool = false
    var timesADateDone: Int = 0
    //TODO: дописать id
    let id: Int = 0
    
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

