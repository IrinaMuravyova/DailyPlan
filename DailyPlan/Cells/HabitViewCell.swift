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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
