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
    
    var doOnMonday: Bool
    var doOnTuesday: Bool
    var doOnWednesday: Bool
    var doOnThursday: Bool
    var doOnFriday: Bool
    var doOnSaturday: Bool
    var doOnSunday: Bool 
    
    let habitDone: Bool
    
    let startDate: Date
    let endDate: Date
    var completionHistory: [HabitCompletionRecord] = [] // история выполнения
    var doneImageName: String = "habitDone"

    //TODO: дописать id
    let id: Int
    
//    private var defaults = UserDefaults.standard
//    private let habitsKey = "habits"
    
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
    
    // Проверка, подходит ли текущая дата для выполнения задачи
    func isHabitDue(on date: Date) -> Bool {
        let calendar = Calendar.current
        
        // Проверяем, что дата входит в интервал от startDate до endDate (если endDate указана)
        if date >= startDate && date <= endDate {
            return isWithinPeriod(on: date, calendar: calendar)
        }
        return false
    }
        
    // Проверка, подходит ли дата по дню недели
    private func isWithinPeriod(on date: Date, calendar: Calendar) -> Bool {
//        switch periodicity {
//        case .daily:
//            return true
//            
//        case .weekly:
//            return calendar.component(.weekday, from: date) == calendar.component(.weekday, from: startDate)
//            
//        case .monthly:
//            return calendar.component(.day, from: date) == calendar.component(.day, from: startDate)
//        }
        return true //TODO: написать проверку на день недели
    }
        
    // Функция для добавления записи выполнения задачи на определенную дату
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
enum HabitStatus : Codable{
    case created
    case completed
    case paused
    case missed
    
    // Ключи для кодирования и раскодирования значений
    private enum CodingKeys: String {
        case created = "created"
        case completed = "completed"
        case paused = "paused"
        case missed = "missed"
    }
    
    // MARK: - Init для декодирования (Decodable)
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
        case CodingKeys.created.rawValue:
            self = .created
        case CodingKeys.completed.rawValue:
            self = .completed
        case CodingKeys.paused.rawValue:
            self = .paused
        case CodingKeys.missed.rawValue:
            self = .missed
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid HabitStatus value")
        }
    }
    
    // MARK: - Encode для кодирования (Encodable)
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .created:
            try container.encode(CodingKeys.created.rawValue)
        case .completed:
            try container.encode(CodingKeys.completed.rawValue)
        case .paused:
            try container.encode(CodingKeys.paused.rawValue)
        case .missed:
            try container.encode(CodingKeys.missed.rawValue)
        }
    }
}

// Структура записи выполнения привычки
struct HabitCompletionRecord: Codable {
    let date: Date
    let status: HabitStatus
}

//struct HabitCalendar: Codable {
//    let year: Int
//    let month: Int
//    let day: Int  
//    let habitID: Int
//    var habitDone: Bool = false
//    var timesADateDone: Int = 0
//    //TODO: дописать id
//    var id: Int = 0
//    
//    static func getHabitCalendarExamples() -> [HabitCalendar] {
//        [HabitCalendar(year: 2024,
//                       month: 10,
//                       day: 30,
//                       habitID: 1,
//                       habitDone: false,
//                       timesADateDone: 1),
//         HabitCalendar(year: 2024,
//                       month: 10,
//                       day: 29,
//                       habitID: 1,
//                       habitDone: true,
//                       timesADateDone: 2),
//         HabitCalendar(year: 2024,
//                       month: 10,
//                       day: 28,
//                       habitID: 1,
//                       habitDone: true,
//                       timesADateDone: 2),
//         HabitCalendar(year: 2024,
//                       month: 10,
//                       day: 30,
//                       habitID: 3,
//                       habitDone: false,
//                       timesADateDone: 1)
//        ]
//    }
//}

