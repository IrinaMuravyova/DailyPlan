//
//  MainViewController.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 06.11.2024.
//

import UIKit

protocol HabitEditViewControllerDelegate: AnyObject {
    func didAddHabit(_ habit: Habit)
}

protocol DateProcessingForHabitsDelegate {
    func filteredOnDay(_ habits: [Habit], for date: Date) -> [Habit]
    func filteredOnWeekDay(_ habits: [Habit], for date: Date) -> [Habit]
    func setCurrentDateLabel(on date: Date)
}

class MainViewController: UIViewController  {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var lastDateButton: UIButton!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet var nextDateButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    
    var habits: [Habit]!
    
    var data: [String: Any] = [:]
    var sectionTitles: [String] = ["ПРИВЫЧКИ", "ЛЕКАРСТВА/БАДЫ", "ЗАДАЧИ"]
    
    var selectedDate: Date!
    var currentDateForLabel: String = ""

    let titlesForMainScreen = [
        "Иду к цели", "Сегодня точно получится!", "Давай сделаем это!"]
    
    var delegate: DeclinedWordsDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Установка делегатов
        self.delegate = HabitEditViewController()
        tableView.dataSource = self
        tableView.delegate = self
        
        setTitleNavigationController()
        
        // Настройка цветов
        tableView.backgroundColor = UIColor.systemGray6
        footerView.backgroundColor = tableView.backgroundColor
        view.backgroundColor = tableView.backgroundColor

        selectedDate = Date()
        setCurrentDateLabel(on: selectedDate)

//        habits = Habit.getExampleHabitsList() // для тестирования без сохранения в сторадж
        habits = StorageManager.shared.fetchHabits()
        print("НАЧАЛЬНЫЙ МАССИВ")
        print(habits!.count)
//        print(habits!)
        data = [
            "ПРИВЫЧКИ": habits!,
                "ЛЕКАРСТВА/БАДЫ": ["Item 4", "Item 5"],
                "ЗАДАЧИ": ["Item 6", "Item 7", "Item 8", "Item 9"]
            ]
        
        //TODO: при первом запуске запустить добавление новой привычки
        
    }
    
    override func viewWillLayoutSubviews() {
        addButton.layer.cornerRadius = addButton.frame.height / 2
        settingsButton.layer.cornerRadius = settingsButton.frame.height / 2
    }
    
    @IBAction func lastButtonTapped(_ sender: UIButton) {
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
    }
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newHabitVC = segue.destination as? HabitEditViewController else { return }
        newHabitVC.delegate = self
    }

}

// MARK: - Methods for ViewDidLoad
extension MainViewController {
    
    private func setTitleNavigationController() {
        // Устанавливаю текст заголовка
        navigationItem.title = titlesForMainScreen.randomElement()
        
        // Настройка шрифта и цвета заголовка
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                //                    .font: UIFont.boldSystemFont(ofSize: 20),
                .font: UIFont.italicSystemFont(ofSize: 20),
                .foregroundColor: UIColor.systemGreen
            ]
        }
    }
    
    private func dateComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day], from: date)
    }

}

// MARK: - UITableView methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    // Количество строк в каждой секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionTitles[section]
        let items : Any
        switch section {
        case 0: 
            tableView.rowHeight = 70
        
            let habitsForSelectedDate = data[sectionKey] as? [Habit] ?? [] //TODO: добавить обработчик ошибки
            items = habitsForSelectedDate.filter({$0.completionHistory.contains { record in
                dateComponents(from: record.date ) == dateComponents(from: selectedDate)
            }})
            
        case 1: 
            items = data[sectionKey] as? [String] ?? []
        case 2:
            items = data[sectionKey] as? [String] ?? []
        default:
            items = [] 
        }
        
        return (items as AnyObject).count ?? 0
    }
    

    // Заполнение ячеек таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        habits = StorageManager.shared.fetchHabits()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
 
        let sectionKey = sectionTitles[indexPath.section]
        
        switch indexPath.section {
        case 0: // строки с привычками
            
            var items = data[sectionKey] as? [Habit] ?? [] //TODO: добавить обработчик ошибки
            items = items.filter({$0.completionHistory.contains { record in
                dateComponents(from: record.date ) == dateComponents(from: selectedDate)
            }})
            
            let habit = items[indexPath.row]
                              
            if !habit.habitDone {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as? HabitViewCell
                let content = cell?.contentConfiguration
                
                cell?.habitLabel.text = habit.habit
                cell?.leftTimesADayLabel.text = leftTimeADate(for: habit).formatted()
                cell?.progress.progress = habit.progress / 100
                cell?.contentConfiguration = content
                return cell!
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "habitCellDone", for: indexPath) as? HabitViewCell
                let content = cell?.contentConfiguration
                
                cell?.habitLabel.text = habit.habit
                let declinedWord = delegate?.getDeclinedDayWord(for: leftDaysToDo(habit))
                cell?.leftDaysLabel.text = "Ещё \(leftDaysToDo(habit)) \(declinedWord ?? "дня")"
                cell?.percentLabel.text = "\(habit.progress.formatted())%"
                cell?.contentConfiguration = content
                
                return cell!
            }
            
        case 1:
            let items = data[sectionKey] as? [String] ?? []
            cell.textLabel?.text = items[indexPath.row]
        case 2:
            let items = data[sectionKey] as? [String] ?? []
            cell.textLabel?.text = items[indexPath.row]
        default:
            cell.textLabel?.text = "" //TODO: обработать ошибку
        }

        return cell
        
    }
    


    // Название заголовка для каждой секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
        
        // MARK: - UITableViewDelegate (какая строка выделена)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionKey = sectionTitles[indexPath.section]
        switch indexPath.section {
        case 0:
            let items = data[sectionKey] as? [Habit]
            let item = items?[indexPath.row]

            let itemWithCompletionRecordOnSelectedDate = item?.completionHistory.filter({
                Calendar.current.startOfDay(for: $0.date) == Calendar.current.startOfDay(for: Date())
            }).first
            if item?.timesADay == (itemWithCompletionRecordOnSelectedDate?.timesDone ?? 0) + 1 {
                // в completion timesDone  += 1, статус .completed, перезаписать данные в сторадж, reload секции
            } else {
                // в completion timesDone  += 1
//                itemWithCompletionRecordOnSelectedDate?.timesDone += 1
            }
        default:
            print() //TODO: обработать ошибку
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            // Удаляем элемент из хранилища
            StorageManager.shared.deleteHabit(at: indexPath.row)
            habits = StorageManager.shared.fetchHabits()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        // Перезагружаем данные для конкретной строки или всей таблицы
        if let indexPath = indexPath {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - Habits methods
extension MainViewController {
    private func leftTimeADate(for habit: Habit) -> Int {
        let record = habit.completionHistory.filter({
            dateComponents(from: $0.date) == dateComponents(from: selectedDate)}).first
        let leftTimeADate = habit.timesADay - (record?.timesDone ?? 0)
        return leftTimeADate //TODO: обработать ошибку
    }
    
    private func leftDaysToDo(_ habit: Habit) -> Int {
        habit.duration - habit.completionHistory.filter({$0.status == .completed}).count
    }
    
    
    // Функция для обновления статуса выполнения задачи на определенную дату
//    func updateHabitStatus(habit: Habit, date: Date, status: HabitStatus) {
//        guard let index = habits.firstIndex(where: { $0.habit == habit.habit }) else { return }
//        habits[index].addCompletionRecord(on: date, status: status)
//    }
    
}

// MARK: - NewHabitViewControllerDelegate
extension MainViewController: HabitEditViewControllerDelegate {
    func didAddHabit(_ habit: Habit) {
        // Добавляем новую привычку в массив
        habits.append(habit)
        // Определяем индекс секции, которую нужно обновить
        let sectionIndex = 0 // привычки в первой секции
        let indexSet = IndexSet(integer: sectionIndex)

       // Обновляем данные только этой секции
       tableView.reloadSections(indexSet, with: .automatic)
    }
    
    func didDeleteHabit(_ habit: Habit) {
        // Удаляем привычку из массива
        habits.removeAll(where: { $0.id == habit.id })
        // Определяем индекс секции, которую нужно обновить
        let sectionIndex = 0 // привычки в первой секции
        let indexSet = IndexSet(integer: sectionIndex)

       // Обновляем данные только этой секции
       tableView.reloadSections(indexSet, with: .automatic)
    }
}

//MARK: - dateProcessingForHabitsDelegate
extension MainViewController: DateProcessingForHabitsDelegate {
    // Функция для фильтрации задач по дате
    func filteredOnDay(_ habits: [Habit], for date: Date) -> [Habit] {
        return habits.filter { $0.isHabitDue(on: date) }
    }
    
    // Функция для фильтрации задач по дню недели
    func filteredOnWeekDay(_ habits: [Habit], for date: Date) -> [Habit] {
        return habits.filter { $0.isWithinPeriod(on: date)}
    }
    
    func setCurrentDateLabel(on date: Date) {
        currentDateForLabel = date.formatted(date: .abbreviated, time: .omitted)
        currentDateLabel.text = currentDateForLabel
    }
}
