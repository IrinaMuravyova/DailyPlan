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
    private var habitCalendar = HabitCalendar.getHabitCalendarExamples()

    let currentDateForLabel = Date().formatted(date: .abbreviated, time: .omitted)
    //TODO: улучшить валидацию дат
    let currentYear = Int(Date().description.prefix(4))
    let currentMonth = Int(Date().description.prefix(10).suffix(5).prefix(2))
    let currentDay = Int(Date().description.prefix(10).suffix(2))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        currentDateLabel.text = currentDateForLabel
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
        // #warning Incomplete implementation, return the number of rows
        return habits.count
    }
    
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
            
            
            cell?.leftTimesADayLabel.text = String(leftTimeADate(for: habit, in: habitCalendar))
            
            cell?.progress.progress = (Float(habitCalendar.filter({
                $0.habitID == habit.id && $0.habitDone
            }).count) / Float(habit.duration))
            
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let newHabitVC = segue.destination as? HabitEditViewController else { return }
         newHabitVC.delegate = self
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    


    
    //TODO: улучшить валидацию дат
    private func leftTimeADate(for habit: Habit, in habitCalendar: [HabitCalendar]) -> Int {
        habit.timesADay - (habitCalendar.filter({
            $0.year == Int(currentYear ?? 2000)
            && $0.month == Int(currentMonth ?? 1)
            && $0.day == Int(currentDay ?? 1)
            && $0.habitID == habit.id
        })
            .first?.timesADateDone ?? 0)
    }
    
    //TODO: улучшить валидацию дат
    private func leftDaysToDo(_ habit: Habit) -> Int {
        habit.duration - (habitCalendar.filter({
            $0.year == Int(currentYear ?? 2000)
            && $0.month == Int(currentMonth ?? 1)
            && $0.day == Int(currentDay ?? 1)
            && $0.habitID == habit.id
        })
            .first?.timesADateDone ?? 0)
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

//MARK: - UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            //TODO: решить вопрос с переполнением
            StorageManager.shared.deleteHabit(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } //TODO: продумать логику чтобы удалять одну запись и записи из календаря для нее
    }
}
