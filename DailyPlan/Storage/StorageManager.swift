//
//  StorageManager.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 31.10.2024.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private var defaults = UserDefaults.standard
    private let habitsKey = "habits"
    private let habitsCalendarKey = "habitCalendar"
    
    private init() {}
    
    func fetchHabits() -> [Habit] {
        guard let data = defaults.data(forKey: habitsKey) else { return [] }
        guard let habits = try? JSONDecoder().decode([Habit].self, from: data) else { return [] }
        return habits
    }
    
    func save(habit: Habit) {
        var habits = fetchHabits()
        habits.append(habit)
        
        guard let data = try? JSONEncoder().encode(habits) else { return }
        defaults.set(data, forKey: habitsKey)
        
        var habitsCalendar = fetchHabitsCalendar()
        habitsCalendar.append(HabitCalendar(
            year: Int(Date().description.prefix(4))!,
            month: Int(Date().description.prefix(10).suffix(5).prefix(2))!,
            day: Int(Date().description.prefix(10).suffix(2))!,
            habitID: habit.id)) 
        guard let data = try? JSONEncoder().encode(habitsCalendar) else { return }
        defaults.set(data, forKey: habitsCalendarKey)
    }
    
        func deleteHabit(at index: Int ){
            var habits = fetchHabits()
            let removedHabit = habits.remove(at: index)
            
            var habitsCalendar = fetchHabitsCalendar()
            habitsCalendar.removeAll(where: {$0.habitID == removedHabit.id})
            
            guard let data = try? JSONEncoder().encode(habits) else { return }
            defaults.set(data, forKey: habitsKey)

            guard let data = try? JSONEncoder().encode(habitsCalendar) else { return }
            defaults.set(data, forKey: habitsCalendarKey)
    }
    
    
    func updateHabit(at index: Int) {
        
    }
    
    
    func fetchHabitsCalendar() -> [HabitCalendar] {
        guard let data = defaults.data(forKey: habitsCalendarKey) else {
            return [] }
        guard let habitCalendar = try? JSONDecoder().decode([HabitCalendar].self, from: data) else {return [] }
        return habitCalendar
    }
}
