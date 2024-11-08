//
//  HabitViewCell.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 30.10.2024.
//

import UIKit

class HabitViewCell: UITableViewCell {
    
    @IBOutlet var habitLabel: UILabel!
    @IBOutlet var leftTimesADayLabel: UILabel!
    @IBOutlet var progress: UIProgressView!

    @IBOutlet var leftDaysLabel: UILabel!
    @IBOutlet var percentLabel: UILabel!
    
//    private let containerView = UIView()
    @IBOutlet var containerForHabitCellsView: UIView!
    
    


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupShadow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Установка цвета контейнера View + тень, чтобы создать 3D эффект
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        setupShadow()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     
    
    
}

extension HabitViewCell {
    func setupShadow() {
    // Настройка тени для containerView
    if let containerForHabitCellView = containerForHabitCellsView {
        containerForHabitCellView.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        containerForHabitCellView.layer.shadowOpacity = 0.2 // Прозрачность тени
        containerForHabitCellView.layer.shadowOffset = CGSize(width: 0, height: 2) // Смещение тени
        containerForHabitCellView.layer.shadowRadius = 4 // Радиус размытия тени
    }
    }
}
