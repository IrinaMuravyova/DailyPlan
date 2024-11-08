//
//  MainViewController.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 06.11.2024.
//

import UIKit

protocol HabitEditViewControllerDelegate: AnyObject {
    func add(_ habit: Habit)
}

class MainViewController: UIViewController  {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var lastDateButton: UIButton!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet var nextDateButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    

    
    lazy var habits = Habit.getExampleHabitsList() // для тестирования без сохранения в сторадж
    
    var data: [String: Any] = [:]
    var sectionTitles: [String] = ["ПРИВЫЧКИ", "ЛЕКАРСТВА/БАДЫ", "ЗАДАЧИ"]
    
    var selectedDate: Date!
    var currentDateForLabel: String = ""
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int  = 0

    let titleForController = ["Иду к целям!"]
    
    var delegate: DeclinedWordsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Установка делегатов
        self.delegate = HabitEditViewController()
        
        
        setTitleNavigationController()
        
        tableView.dataSource = self
        tableView.delegate = self

        let calendar = Calendar.current
        let currentDate = Date()
        
        // Извлекаем компоненты года, месяца и дня

        selectedDate = calendar.date(from: dateComponents(from: currentDate))
        
        currentDateForLabel = self.selectedDate.formatted(date: .abbreviated, time: .omitted)
        currentDateLabel.text = currentDateForLabel

        currentYear =  Calendar.current.component(.year, from: selectedDate)
        currentMonth = Calendar.current.component(.month, from: selectedDate)
        currentDay = Calendar.current.component(.day, from: selectedDate)
     
        
//        habits = StorageManager.shared.fetchHabits()
        
        data = [
            "ПРИВЫЧКИ": habits,
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
        navigationItem.title = titleForController.randomElement()
        
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
   
//    var delegate: SomeProtocol?
    
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
            tableView.rowHeight = 60
        
            let habitsForSelectedDate = data[sectionKey] as? [Habit] ?? [] //TODO: добавить обработчик ошибки
                items = habitsForSelectedDate.filter{ $0.isHabitDue(on: selectedDate)}
            
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
 
        let sectionKey = sectionTitles[indexPath.section]
        
        switch indexPath.section {
        case 0: // строки с привычками
            let items = data[sectionKey] as? [Habit] ?? [] //TODO: добавить обработчик ошибки
            let habit = items[indexPath.row]
            
            //TODO: выводить только те, которые есть в календаре на указанную дату. При запуске приложения сегодня первый раз, создавать автоматически на сегодняшнюю дату
            if !habit.habitDone {
                let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as? HabitViewCell
                
                let content = cell?.contentConfiguration

                cell?.habitLabel.text = habit.habit
                cell?.leftTimesADayLabel.text = leftTimeADate(for: habit).formatted()
                //TODO: дописать
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

//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(at: indexPath, animated: true)
//            let sectionKey = sectionTitles[indexPath.section]
//            let items = data[sectionKey] as? [String]
//            let item = items?[indexPath.row]
//            print("Выбран элемент: \(item ?? "")")
//        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            //TODO: решить вопрос с переполнением
            StorageManager.shared.deleteHabit(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } //TODO: продумать логику чтобы удалять одну запись и записи из календаря для нее
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

// MARK: - NewHabitViewControllerDelegate
extension MainViewController: HabitEditViewControllerDelegate {
    //TODO: сделать дженерик
    func add(_ habit: Habit) {
        habits.append(habit)
        print(habits)
        tableView.reloadData()
        }
}



//полезный код для сравнения двух дат по дню
//let selectedDate = Calendar.current.startOfDay(for: Date())
//let currentDate = Calendar.current.startOfDay(for: Date())
//
//if Calendar.current.isDate(selectedDate, inSameDayAs: currentDate) {
//    print("Dates are the same.")
//} else {
//    print("Dates are different.")
//}
