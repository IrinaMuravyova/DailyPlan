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
    @IBOutlet var timesDeclineLabel: UILabel!
    @IBOutlet var durationCountTextField: UITextField!
    @IBOutlet var durationTypePickerView: UIPickerView!
    
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    @IBOutlet var sundayButton: UIButton!

    @IBOutlet var addHabitButton: UIButton!
    
    var durationOptions = ["день", "месяц", "год"]
    var startDurationValue = "месяц"
    
    
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
        
        
        updateCountDeclinedWord()
        timesADayTextField.addTarget(self, action: #selector(updateCountDeclinedWord), for: .editingChanged)
        
        // picker view settings
        // Установка делегатов
        durationTypePickerView.delegate = self
        durationTypePickerView.dataSource = self
        
        durationTypePickerView.selectedRow(inComponent: 0)
        
        // Установите выбранный индекс на основе текущего значения
        if let index = durationOptions.firstIndex(of: startDurationValue) {
            durationTypePickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        updateDurationDeclinedWords()
        durationCountTextField.addTarget(self, action: #selector(updateDurationDeclinedWords), for:.editingChanged)

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
        addHabitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addHabitButton.heightAnchor.constraint(equalToConstant: 50), // Устанавливаем высоту кнопки
            
        ])

        addHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        addHabitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addHabitButton.titleLabel?.minimumScaleFactor = 0.5
        
        var hasRoundedCorners = false
        // Устанавливаем угол только один раз
            if !hasRoundedCorners {
                addHabitButton.layer.cornerRadius = addHabitButton.frame.size.height / 2
                addHabitButton.layer.masksToBounds = true
                hasRoundedCorners = true
            }
        
        timesADayTextField.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    @IBAction func savingHabit(_ sender: UIButton) {
        addHabit()
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
        guard !habit.isEmpty else { return } //TODO: добавить алерт, если пытаются сохранить без текста привычки

        let duration = countSelectedDaysInPeriod()

        var newHabit = Habit(
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
            startDate: Calendar.current.startOfDay(for: Date()),
            endDate: getEndDateOfPeriod(),
            completionHistory: [],
            id: 4) //TODO: дописать логику с id
        
        newHabit.completionHistory = createTodayCompletionRecord()
        
        StorageManager.shared.save(habit: newHabit)
        delegate?.add(newHabit)
//        navigationController?.popViewController(animated: true)
    }
    
    func getEndDateOfPeriod() -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        let period =
            switch getSelectedPickerViewValue() {
            case 1: Calendar.Component.month
            case 2: Calendar.Component.year
            default: Calendar.Component.day
            }
        let durationCount = Int(durationCountTextField.text ?? "") ?? 1
        
        guard let periodLater = calendar.date(byAdding: period, value: durationCount, to: currentDate) else {
            return Calendar.current.startOfDay(for: Date())
        }
        let endOfPeriod = calendar.startOfDay(for: periodLater) // Начало дня через два месяца
        return endOfPeriod
    }

    func countSelectedDaysInPeriod() -> Int {
        
        let currentDate = Date() 
        let calendar = Calendar.current
        
        // Нахожу дату, которая будет через указанный период от текущей
        let period =
            switch getSelectedPickerViewValue() {
            case 1: Calendar.Component.month
            case 2: Calendar.Component.year
            default: Calendar.Component.day
            }
        let durationCount = Int(durationCountTextField.text ?? "") ?? 1
        
        guard let periodLater = calendar.date(byAdding: period, value: durationCount, to: currentDate) else {
            return 0
        }
        
        // Нахожу начальную и конечную даты периода
        let startOfPeriod = calendar.startOfDay(for: currentDate) // Начало текущего дня
        let endOfPeriod = calendar.startOfDay(for: periodLater) // Начало дня через два месяца
        
        var count = 0
        var currentDateToCheck = startOfPeriod
        
        var selectedWeekdays: [Int] = []
        let dayButtons = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
        for button in dayButtons {
            if buttonIsOn(button!) {
                switch button {
                case mondayButton: selectedWeekdays.append(2)
                case tuesdayButton: selectedWeekdays.append(3)
                case wednesdayButton: selectedWeekdays.append(4)
                case thursdayButton: selectedWeekdays.append(5)
                case fridayButton: selectedWeekdays.append(6)
                case saturdayButton: selectedWeekdays.append(7)
                case sundayButton: selectedWeekdays.append(8)
                default:
                    print() //TODO: обработать или убрать
                }
            }
        }
        // Прохожу через все дни в периоде
        while currentDateToCheck <= endOfPeriod {
            // Проверяю, выбирал ли пользователь этот день
            if selectedWeekdays.contains(calendar.component(.weekday, from: currentDateToCheck)) {
                count += 1
            }
            
            // Перехожу к следующему дню
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDateToCheck) {
                currentDateToCheck = nextDay
            }
        }
        return count
    }
    
    private func createTodayCompletionRecord() -> [HabitCompletionRecord] {
        let calendar = Calendar.current
        
        var selectedWeekdays: [Int] = []
        let dayButtons = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
        for button in dayButtons {
            if buttonIsOn(button!) {
                switch button {
                case mondayButton: selectedWeekdays.append(2)
                case tuesdayButton: selectedWeekdays.append(3)
                case wednesdayButton: selectedWeekdays.append(4)
                case thursdayButton: selectedWeekdays.append(5)
                case fridayButton: selectedWeekdays.append(6)
                case saturdayButton: selectedWeekdays.append(7)
                case sundayButton: selectedWeekdays.append(8)
                default:
                    print() //TODO: обработать или убрать
                }
            }
        }
        
        let completionRecord =
        Date() >= calendar.startOfDay(for: Date()) && Date() <= getEndDateOfPeriod()
        && selectedWeekdays.contains(calendar.component(.weekday, from: Date()))
        ? [HabitCompletionRecord(date: Date(), timesDone: 0, status: .created)]
        : []
        
        return completionRecord
    }
    
    //TODO: дописать (подгружать, очищать, добавлять, отправлять в хранилище
//    private func addTodayCompletionRecord() -> HabitCompletionRecord {
//        
//    }
}

//MARK: UIPickerView Methods
extension HabitEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //TODO: поменять шрифт у значения
    //TODO: скачет цифра
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

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30),
                .foregroundColor: UIColor.black           // Цвет текста
            ]
            return NSAttributedString(string: durationOptions[row], attributes: attributes)
        }
    
    func getSelectedPickerViewValue() -> Int {
            // Получение выбранного значения из первого компонента
        durationTypePickerView.selectedRow(inComponent: 0)
//            let selectedRow = durationTypePickerView.selectedRow(inComponent: 0) // Используйте 0
//            let selectedValue = durationOptions[selectedRow]
//            print("Currently selected value: \(selectedValue)")
        }
}

// MARK: Get declined words
extension HabitEditViewController {
    private func getDeclinedDayWord(for number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastDigit == 1 && lastTwoDigits != 11 {
            return "день"
        } else if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) && !(lastTwoDigits >= 11 && lastTwoDigits <= 14) {
            return "дня"
        } else {
            return "дней"
        }
    }
    
    private func getDeclinedYearWord(for number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastDigit == 1 && lastTwoDigits != 11 {
            return "год"
        } else if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) && !(lastTwoDigits >= 11 && lastTwoDigits <= 14) {
            return "года"
        } else {
            return "лет"
        }
    }
    
    private func getDeclinedMonthWord(for number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastDigit == 1 && lastTwoDigits != 11 {
            return "месяц"
        } else if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) && !(lastTwoDigits >= 11 && lastTwoDigits <= 14) {
            return "месяца"
        } else {
            return "месяцев"
        }
    }
    
    @objc private func updateDurationDeclinedWords() {
        let count = Int(durationCountTextField.text ?? "1") ?? 1
        let day = getDeclinedDayWord(for: count).uppercased()
        let month = getDeclinedMonthWord(for: count).uppercased()
        let year = getDeclinedYearWord(for: count).uppercased()
        durationOptions = [day, month, year]
        durationTypePickerView.reloadComponent(0)
        
    }
    
    private func getDeclinedTimesWord(for number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastDigit == 1 && lastTwoDigits != 11 {
            return "раз"
        } else if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) && !(lastTwoDigits >= 11 && lastTwoDigits <= 14) {
            return "раза"
        } else {
            return "раз"
        }
    }
    
    @objc private func updateCountDeclinedWord() {
        let count = Int(timesADayTextField.text ?? "1") ?? 1
        timesDeclineLabel.text = " \(getDeclinedTimesWord(for: count)) в день".uppercased()
        timesDeclineLabel.reloadInputViews()
//        timesADayTextField.font = UIFont.systemFont(ofSize: 30)
    }
}
