//
//  HabitEditViewController.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 31.10.2024.
//

import UIKit

class HabitEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var habitTextField: UITextField!
    @IBOutlet var timesADayTextField: UITextField!
    @IBOutlet var durationCountTextField: UITextField!
    @IBOutlet var durationTypePickerView: UIPickerView!
    @IBOutlet var durationTypeLabel: UILabel!
    
    
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    @IBOutlet var sundayButton: UIButton!
    
    var durationOptions = ["day", "month", "year"] //TODO: сделать склонение в зависимости от числа
    var startDurationValue = "month"
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // days buttons settings
        flagButtonSetting(button: mondayButton)
        flagButtonSetting(button: tuesdayButton)
        flagButtonSetting(button: wednesdayButton)
        flagButtonSetting(button: thursdayButton)
        flagButtonSetting(button: fridayButton)
        flagButtonSetting(button: saturdayButton)
        flagButtonSetting(button: sundayButton)
        
        mondayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        tuesdayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        wednesdayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        thursdayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        fridayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        saturdayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        sundayButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        
        // picker view settings
        // Установка делегатов
        durationTypePickerView.delegate = self
        durationTypePickerView.dataSource = self
        
        durationTypePickerView.selectedRow(inComponent: 0)
        
        // Установите выбранный индекс на основе текущего значения
        if let index = durationOptions.firstIndex(of: startDurationValue) {
            durationTypePickerView.selectRow(index, inComponent: 0, animated: false)
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Обновление радиуса скругления углов при изменении размеров
        mondayButton.layer.cornerRadius = mondayButton.frame.size.width / 2
        tuesdayButton.layer.cornerRadius = tuesdayButton.frame.size.width / 2
        wednesdayButton.layer.cornerRadius = wednesdayButton.frame.size.width / 2
        thursdayButton.layer.cornerRadius = thursdayButton.frame.size.width / 2
        fridayButton.layer.cornerRadius = fridayButton.frame.size.width / 2
        saturdayButton.layer.cornerRadius = saturdayButton.frame.size.width / 2
        sundayButton.layer.cornerRadius = sundayButton.frame.size.width / 2
        
        }
    
    @IBAction func savingHabit(_ sender: UIButton) {
        addHabit()
    }
    
    
    @IBAction func cancelAddingHabit(_ sender: UIButton) {
        dismiss(animated: true)
    }

    
    @objc private func flagTapped(dayButton: UIButton) {
        
        // Изменение состояния флага}
        if dayButton.backgroundColor == .systemGreen {
            dayButton.backgroundColor = .white
            dayButton.layer.borderColor = UIColor.black.cgColor
            dayButton.layer.borderWidth = 1
            } else {
                dayButton.backgroundColor = .systemGreen
                dayButton.layer.borderColor = UIColor.clear.cgColor
            }
    }
    
    private func flagButtonSetting(button: UIButton) {
        
        // Отключение автоматического управления размерами
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: view.layer.frame.height * 0.03),
            button.heightAnchor.constraint(equalTo: button.widthAnchor),
            ])
                
        // Для скругления углов
        button.clipsToBounds = true

        button.backgroundColor = .systemGreen
        
        button.layer.shadowColor = UIColor.systemGreen.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    private func buttonIsOn(_ button : UIButton) -> Bool {
        button.backgroundColor == .systemGreen ? true : false
    }
    
    private func addHabit(){
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
            doOnMonday:  buttonIsOn(mondayButton),
            doOnTuesday: buttonIsOn(tuesdayButton),
            doOnWednesday: buttonIsOn(wednesdayButton),
            doOnThursday: buttonIsOn(thursdayButton),
            doOnFriday: buttonIsOn(fridayButton),
            doOnSaturday: buttonIsOn(saturdayButton),
            doOnSunday: buttonIsOn(sundayButton),
            habitDone: false,
            id: 4) //TODO: дописать логику с id
        
        StorageManager.shared.save(habit: newHabit)
        delegate?.add(newHabit)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIPickerView Data Source Methods

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Один компонент для простого списка
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return durationOptions.count // Количество строк в списке
        }

        // MARK: - UIPickerView Delegate Methods

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return durationOptions[row] // Текст для каждого элемента
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // Обновление метки при выборе нового значения
            if component == 0 {
                    let selectedValue = durationOptions[row]
                    print("Selected: \(selectedValue)")
                }
        }
    
    func getSelectedValue() {
            // Получение выбранного значения из первого компонента
            let selectedRow = durationTypePickerView.selectedRow(inComponent: 0) // Используйте 0
            let selectedValue = durationOptions[selectedRow]
            print("Currently selected value: \(selectedValue)")
        }
}

