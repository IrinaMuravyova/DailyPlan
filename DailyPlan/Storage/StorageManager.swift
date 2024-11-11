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
    
    func save(addedHabit: Habit) {
        var habits = fetchHabits()
        habits.append(addedHabit)
        let encoder = JSONEncoder()
        // Устанавливаю стратегию кодирования для дат (ISO 8601)
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(habits) else { return }
        defaults.set(data, forKey: habitsKey)
    }
    
    func save(changedHabit: Habit) {
        var habits = fetchHabits()
        
        let index = habits.firstIndex {$0.id == changedHabit.id}
        guard let index = index else { return }
        habits.remove(at: index)
        habits.append(changedHabit)
        
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
        let todaySystemDate = Date()
        print("ДО ФИЛЬТРАЦИИ")
        print(habits.count)
//        print(habits)
        habits = delegate?.filteredOnDay(habits, for: todaySystemDate) ?? [] //TODO: обработать ошибку
        print("ПОСЛЕ ФИЛЬТРАЦИИ ПО ДАТЕ")
        print(habits.count)
        habits = delegate?.filteredOnWeekDay(habits, for: todaySystemDate) ?? []
        print("ПОСЛЕ ФИЛЬТРАЦИИ ПО ДНЮ НЕДЕЛИ")
        print(habits.count)
        
        for i in 0 ..< habits.count {
            
            if habits[i].completionHistory.filter({
                isSameDateWithoutTime($0.date, todaySystemDate)
            }).count == 0 {
                habits[i].completionHistory.append(HabitCompletionRecord(date: todaySystemDate, timesDone: 0, status: .created))
                save(changedHabit: habits[i])
            } else {
                print("запись \(habits[i].completionHistory) уже существует") //TODO: обработать ошибку
            }
        }
    }
    
    //TODO: если есть за вчера записи в статусе не .complited, то за вчера пометить их как невыполненные
    func checkAndCancelYesterdayCompletionHistory() {
        // получается что проверяю в mainVC, а перезаписываю в памяти здесь
    }
    
    func isSameDay(_ dateFirst: Date, _ dateSecond: Date) -> Bool {
        Calendar.current.component(.day, from: dateFirst) == Calendar.current.component(.day, from: dateSecond)
    }
    
    func isSameMonth(_ dateFirst: Date, _ dateSecond: Date) -> Bool {
        Calendar.current.component(.month, from: dateFirst) == Calendar.current.component(.month, from: dateSecond)
    }
    
    func isSameYear(_ dateFirst: Date, _ dateSecond: Date) -> Bool {
        Calendar.current.component(.year, from: dateFirst) == Calendar.current.component(.year, from: dateSecond)
    }
    
    func isSameDateWithoutTime(_ dateFirst: Date, _ dateSecond: Date) -> Bool {
        isSameDay(dateFirst, dateSecond)
        && isSameMonth(dateFirst, dateSecond)
        && isSameYear(dateFirst, dateSecond)
    }
}
