//
//  StorageManager.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 31.10.2024.
//

import Foundation

protocol completionHistoryDelegate {
    func createTodayCompletionHistory()
    func checkAndCancelYesterdayCompletionHistory()
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
    }
    
    func deleteHabit(at index: Int){
        var habits = fetchHabits()
        
        let encoder = JSONEncoder()
        // Устанавливаю стратегию кодирования для дат (ISO 8601)
        encoder.dateEncodingStrategy = .iso8601
        
        guard let data = try? encoder.encode(habits) else { return }
        defaults.set(data, forKey: habitsKey)
        
    }
    
    
    func updateHabit(with habitID: Int) {
        
    }
    
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
    
    //TODO: если есть за вчера записи в статусе не .complited, то за вчера пометить их как невыполненные
    func checkAndCancelYesterdayCompletionHistory() {
        // получается что проверяю в mainVC, а перезаписываю в памяти здесь
    }
}
