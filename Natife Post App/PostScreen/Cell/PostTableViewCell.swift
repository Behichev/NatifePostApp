//
//  PostTableViewCell.swift
//  Natife Post App
//
//  Created by Ivan Behichev on 30.08.2023.
//

import UIKit

protocol StateDelegate: AnyObject {
    func objectStateChanged(state: Bool, index: Int)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var mainTextLabel: UILabel!
    @IBOutlet weak private var likesLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var moreButton: UIButton!
    
    private var isOpen: Bool = false
    private var cellIndex: Int?
    private var configuration: PostConfiguration?
    
    weak var delegate: StateDelegate?
    
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
        cellIndex = configuration.index
        isOpen = configuration.state
        
        if isOpen {
            moreButton.setTitle("Hide", for: .normal)
        } else {
            moreButton.setTitle("More", for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        mainTextLabel.text = nil
        likesLabel.text = nil
        dateLabel.text = nil
    }
    
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.month, .day], from: date, to: currentDate)
        
        switch (components.year, components.month, components.day) {
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
        if let id = configuration?.index {
            if isOpen {
                isOpen = false
                mainTextLabel.numberOfLines = 2
            } else {
                isOpen = true
                mainTextLabel.numberOfLines = 0
            }
            delegate?.objectStateChanged(state: isOpen, index: id)
            print(id)
        }
    }
}
