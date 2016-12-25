//
//  MainEventCell.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import UIKit
import SnapKit

final class MainEventCell: UITableViewCell {
    // MAKK: - Properties
    private lazy var projectLabel: UILabel = {
        let projectLabel = UILabel()
        
        projectLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        projectLabel.textColor = .lightGray
        projectLabel.textAlignment = .left
        
        return projectLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .right
        
        return dateLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        
        return titleLabel
    }()
    
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        
        contentLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        contentLabel.textColor = .lightGray
        contentLabel.textAlignment = .left
        
        return contentLabel
    }()
    
    // MARK: - Init & Deinit
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        
        addSubview(projectLabel)
        projectLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(10)
        }
        
        dateLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh + 1, for: .horizontal)
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.firstBaseline.equalTo(projectLabel)
            make.left.equalTo(projectLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(projectLabel)
            make.top.equalTo(projectLabel.snp.bottom).offset(3)
            make.right.equalTo(dateLabel)
        }
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    // MARK: - UI Config
    func config(with event: Event, time: MainViewController.DataTime) {
        projectLabel.text = event.project?.name ?? "Unknown Project"
        
        let dateFormatter = DateFormatter()
        switch time {
        case .today:
            dateFormatter.dateFormat = "h:m a"
        case .tomorrow:
            dateFormatter.dateFormat = "'tomorrow' h:m a"
        case .future:
            dateFormatter.dateFormat = "MMM d h:m a"
        }
        
        dateLabel.text = "\(dateFormatter.string(from: event.startDate ?? .distantFuture)) - \(dateFormatter.string(from: event.endDate ?? .distantFuture)))"
        
        titleLabel.text = event.title
        contentLabel.text = event.content
    }
}