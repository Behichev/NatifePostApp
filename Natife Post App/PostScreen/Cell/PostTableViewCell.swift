//
//  PostTableViewCell.swift
//  Natife Post App
//
//  Created by Ivan Behichev on 30.08.2023.
//

import UIKit

protocol State: AnyObject {
    func objectStateChanged(state: Bool, object: Int)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var mainTextLabel: UILabel!
    @IBOutlet weak private var likesLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var moreButton: UIButton!
    
    private var isOpen: Bool = false
    private var cellId: Int?
    private var configuration: PostConfiguration?
    
    weak var delegate: State?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moreButton.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with configuration: PostConfiguration) {
        self.configuration = configuration
        titleLabel.text = configuration.title
        mainTextLabel.text = configuration.text
        likesLabel.text = "❤️ \(configuration.likes)"
        dateLabel.text = timeAgoString(from: configuration.date)
        cellId = configuration.id
    }
    
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: date, to: currentDate)
        
        switch (components.year, components.month, components.day) {
        case (.some(let year), _, _) where year > 0:
            return "\(year) year\(year > 1 ? "s" : "") ago"
        case (_, .some(let month), _) where month > 0:
            return "\(month) month\(month > 1 ? "s" : "") ago"
        case (_, _, .some(let day)) where day > 0:
            return "\(day) day\(day > 1 ? "s" : "") ago"
        default:
            return "Today"
        }
    }
    
    //MARK: - Actions
    @IBAction private func moreButtonPressed(_ sender: UIButton) {
        if !isOpen {
            if cellId == configuration?.id {
                isOpen = true
                UIView.animate(withDuration: 0.3) {
                    self.mainTextLabel.numberOfLines = 0
                    sender.setTitle("Hide", for: .normal)
                }
            }
            
        } else {
            if cellId == configuration?.id {
                isOpen = false
                UIView.animate(withDuration: 0.3) {
                    self.mainTextLabel.numberOfLines = 2
                    sender.setTitle("More", for: .normal)
                }
            }
        }
        
        if let id = configuration?.id {
            delegate?.objectStateChanged(state: true, object: id)
        }
    }
}
