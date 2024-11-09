//
//  StorageManager.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 31.10.2024.
//

import Foundation

protocol completionHistoryDelegate {
    func createTodayCompletionHistory()
}

class StorageManager {
    
    static let shared = StorageManager()
    
    private var defaults = UserDefaults.standard
    private let habitsKey = "habits"
    
    var delegate: DateProcessingForHabitsDelegate?
    
    private init() {}
    
    func fetchHabits() -> [Habit] {
        guard let data = defaults.data(forKey: habitsKey) else { return [] }
        let decoder = JSONDecoder()
        // Устанавливаю стратегию декодирования для дат в формате ISO 8601
        decoder.dateDecodingStrategy = .iso8601
        guard let habits = try? decoder.decode([Habit].self, from: data) else { return [] }
        return habits
    }
    
    func save(habit: Habit) {
        var habits = fetchHabits()
        habits.append(habit)
        let encoder = JSONEncoder()
        // Устанавливаю стратегию кодирования для дат (ISO 8601)
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(habits) else { return }
        defaults.set(data, forKey: habitsKey)
        
//        var habitsCalendar = fetchHabitsCalendar()
//        habitsCalendar.append(HabitCalendar(
//            year: Int(Date().description.prefix(4))!,
//            month: Int(Date().description.prefix(10).suffix(5).prefix(2))!,
//            day: Int(Date().description.prefix(10).suffix(2))!,
//            habitID: habit.id))
//        guard let data = try? encoder.encode(habitsCalendar) else { return }
//        defaults.set(data, forKey: habitsCalendarKey)
    }
    
        func deleteHabit(at index: Int ){
            var habits = fetchHabits()
            let removedHabit = habits.remove(at: index)
            
//            var habitsCalendar = fetchHabitsCalendar()
//            habitsCalendar.removeAll(where: {$0.habitID == removedHabit.id})
            
            let encoder = JSONEncoder()
            // Устанавливаю стратегию кодирования для дат (ISO 8601)
            encoder.dateEncodingStrategy = .iso8601
            
            guard let data = try? encoder.encode(habits) else { return }
            defaults.set(data, forKey: habitsKey)

//            guard let data = try? encoder.encode(habitsCalendar) else { return }
//            defaults.set(data, forKey: habitsCalendarKey)
    }
    
    
    func updateHabit(at index: Int) {
        
    }
    
    
//    func fetchHabitsCalendar() -> [HabitCalendar] {
//        guard let data = defaults.data(forKey: habitsCalendarKey) else {
//            return [] }
//        let decoder = JSONDecoder()
//        // Устанавливаю стратегию декодирования для дат в формате ISO 8601
//        decoder.dateDecodingStrategy = .iso8601
//        guard let habitCalendar = try? decoder.decode([HabitCalendar].self, from: data) else {return [] }
//        return habitCalendar
//    }
    
    
}

extension StorageManager: completionHistoryDelegate {
    func createTodayCompletionHistory() {
        
        var habits = fetchHabits()
        let today = Calendar.current.startOfDay(for: Date())
        habits = delegate?.habits(for: today) ?? [] //TODO: обработать ошибку
        habits = delegate?.habits(forWeekDay: today) ?? []
        print()
        for i in 0 ..< habits.count {
            habits[i].completionHistory.append(HabitCompletionRecord(date: today, timesDone: 0, status: .created))
            save(habit: habits[i])
        }
    }
}
