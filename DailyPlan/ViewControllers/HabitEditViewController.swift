//
//  HabitEditViewController.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 31.10.2024.
//

import UIKit

class HabitEditViewController: UIViewController {

    @IBOutlet var habitTextField: UITextField!
    @IBOutlet var timesADayTextField: UITextField!
    @IBOutlet var durationCountTextField: UITextField!
    @IBOutlet var durationTypeTextField: UITextField!
    
    
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    @IBOutlet var sundayButton: UIButton!
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func savingHabit(_ sender: UIButton) {
        saveHabit()
    }
    
    
    @IBAction func cancelAddingHabit(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func saveHabit(){
        guard let habit = habitTextField.text else { return }
        guard habitTextField.text != nil else { return }
        
        let durationCount = Int(durationCountTextField.text ?? "") ?? 1
        let duration =
            switch durationCountTextField.text ?? "" {
            case "день", "дней", "дня" : durationCount
            case "месяц", "месяцев", "месяца" : durationCount * 30
            case "год" : durationCount * 365
            default : 1
            }

        let newHabit = Habit(
            habit: habit,
            duration: duration,
            timesADay: Int(timesADayTextField.text ?? "") ?? 1,
            progress: 0,
            habitDone: false,
            id: 4) //TODO: дописать логику с id
        
        StorageManager.shared.save(habit: newHabit)
        delegate?.add(newHabit)
        navigationController?.popViewController(animated: true)
    }
}
