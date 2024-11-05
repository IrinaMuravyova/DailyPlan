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
    
    let startDate: Date
    let endDate: Date
//    var completionHistory: [HabitCompletionRecord] = [] // история выполнения
    
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
                startDate: Calendar.current.startOfDay(for: Date()),
                endDate: Calendar.current.startOfDay(for: Date()) + 5,
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
                startDate: Calendar.current.startOfDay(for: Date()) - 1,
                endDate: Calendar.current.startOfDay(for: Date()) + 3,
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
                startDate: Calendar.current.startOfDay(for: Date()),
                endDate: Calendar.current.startOfDay(for: Date()) + 4,
                id: 3
            )
        ]
        
        
    }
    
    private func addHabit() {}
    private func deleteHabit() {}
    private func markHabit() {}
    private func changeHabit() {}
    
    // Функция для добавления записи выполнения привычки на определенную дату
//    mutating func addCompletionRecord(on date: Date, status: HabitStatus) {
//        let record = HabitCompletionRecord(date: date, status: status)
//        completionHistory.append(record)
//    }
    
    // Получение статуса выполнения для определенной даты
//    func statusForDate(_ date: Date) -> HabitStatus? {
//        return completionHistory.first { Calendar.current.isDate($0.date, inSameDayAs: date) }?.status
//    }
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

// Перечисление для статуса выполнения привычки на определенную дату
enum HabitStatus {
    case created
    case completed
    case paused
    case missed
}

// Структура записи выполнения привычки
//struct HabitCompletionRecord: Codable {
//    let date: Date
//    let status: HabitStatus
//}

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

