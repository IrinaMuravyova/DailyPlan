//
//  MainViewController.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 30.10.2024.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func add(_ habit: Habit)
}

class MainViewController: UITableViewController {
    
    @IBOutlet var currentDateLabel: UILabel!
    
    private var habits = Habit.getExampleHabitsList()
//    private var habitCalendar = HabitCalendar.getHabitCalendarExamples()

    var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    var currentDateForLabel: String = ""
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int  = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        
        currentDateForLabel = self.selectedDate.formatted(date: .abbreviated, time: .omitted)
        currentDateLabel.text = currentDateForLabel
        
        currentYear =  Calendar.current.component(.year, from: selectedDate)
        currentMonth = Calendar.current.component(.month, from: selectedDate)
        currentDay = Calendar.current.component(.day, from: selectedDate)
//        habits = StorageManager.shared.fetchHabits()
        
        
        //TODO: при первом запуске запустить добавление новой привычки
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let habitsForSelectedDate = habits.filter { $0.isHabitDue(on: selectedDate) }
        let habitsForSelectedDate = habits.filter { $0.isHabitDue(on: selectedDate) }
        print(habitsForSelectedDate)
        return habitsForSelectedDate.count
        
//        return habits.count
    }
    
//    private func convertToDate(from dateString: String) -> Date {
//        
//        let dateFormatter = DateFormatter()
//
//        // Устанавливаем формат, соответствующий формату строки
//        dateFormatter.dateFormat = "dd-MM"
//
//        // Преобразуем строку в дату
//        if let date = dateFormatter.date(from: dateString) {
//            print("Дата: \(date)")
//        } else {
//            print("Не удалось преобразовать строку в дату")
//        }
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ПРИВЫЧКИ"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let habit = habits[indexPath.row]
        //TODO: выводить только те, которые есть в календаре на указанную дату. При запуске приложения сегодня первый раз, создавать автоматически на сегодняшнюю дату
        if !habit.habitDone {
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as? HabitViewCell
            
            let content = cell?.contentConfiguration
            cell?.habitLabel.text = habit.habit
            
            
            cell?.leftTimesADayLabel.text = "" //String(leftTimeADate(for: habit, in: habitCalendar))
            
            cell?.progress.progress = 0.7 //(Float(habitCalendar.filter({
//                $0.habitID == habit.id && $0.habitDone
//            }).count) / Float(habit.duration))
            
            cell?.contentConfiguration = content
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitCellDone", for: indexPath) as? HabitViewCell
            let content = cell?.contentConfiguration
            
            cell?.habitLabel.text = habit.habit
            cell?.leftDaysLabel.text = "Еще \(leftDaysToDo(habit)) дней"
            cell?.percentLabel.text = "\(habit.progress.formatted())%"
            cell?.contentConfiguration = content
            
            return cell!
        }
        //TODO: при заполнении View создавать записи в таблице словарей для текущего дня
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let newHabitVC = segue.destination as? HabitEditViewController else { return }
         newHabitVC.delegate = self
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    


    
    //TODO: улучшить валидацию дат
//    private func leftTimeADate(for habit: Habit, in habitCalendar: [HabitCalendar]) -> Int {
//        habit.timesADay - (habitCalendar.filter({
//            $0.year == currentYear
//            && $0.month == currentMonth
//            && $0.day == currentDay
//            && $0.habitID == habit.id
//        })
//            .first?.timesADateDone ?? 0)
//    }
    
    //TODO: улучшить валидацию дат
    private func leftDaysToDo(_ habit: Habit) -> Int {
//        habit.duration - (habitCalendar.filter({
//            $0.year == currentYear
//            && $0.month == currentMonth
//            && $0.day == currentDay
//            && $0.habitID == habit.id
//        })
//            .first?.timesADateDone ?? 0)
        6
    }
}

// MARK: - NewHabitViewControllerDelegate
extension MainViewController: NewHabitViewControllerDelegate {
    //TODO: сделать дженерик
    func add(_ habit: Habit) {
        habits.append(habit) // ??
        print(habits)
        tableView.reloadData()
        }
}

// MARK: - UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            //TODO: решить вопрос с переполнением
            StorageManager.shared.deleteHabit(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } //TODO: продумать логику чтобы удалять одну запись и записи из календаря для нее
    }
}

// MARK: - работа с привычками
extension MainViewController {
    // Функция для фильтрации задач по дате
    func habits(for date: Date) -> [Habit] {
        return habits.filter { $0.isHabitDue(on: date) }
    }
    
    // Функция для обновления статуса выполнения задачи на определенную дату
//    func updateHabitStatus(habit: Habit, date: Date, status: HabitStatus) {
//        guard let index = habits.firstIndex(where: { $0.habit == habit.habit }) else { return }
//        habits[index].addCompletionRecord(on: date, status: status)
//    }
    
    // Пример функции для обновления статуса задачи (вызывается по кнопке, например)
    func completeHait(_ habit: Habit, on date: Date) {
//        updateHabitStatus(habit: Habit, date: date, status: .completed)
//        tableView.reloadData()
    }
}
