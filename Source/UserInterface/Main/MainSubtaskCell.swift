//
//  MainSubtaskCell.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import UIKit
import SnapKit

final class MainSubtaskCell: UITableViewCell {
    // MAKK: - Properties
    private lazy var projectLabel: UILabel = {
        let projectLabel = UILabel()
        
        projectLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        projectLabel.textColor = .lightGray
        projectLabel.textAlignment = .left
        
        return projectLabel
    }()
    
    private lazy var dueDateLabel: UILabel = {
        let dueDateLabel = UILabel()
        
        dueDateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dueDateLabel.textColor = .gray
        dueDateLabel.textAlignment = .right
        
        return dueDateLabel
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
    
    private lazy var taskLabel: UILabel = {
        let taskLabel = UILabel()
        
        taskLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        taskLabel.textColor = .lightGray
        taskLabel.textAlignment = .left
        
        return taskLabel
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
        
        dueDateLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh + 1, for: .horizontal)
        addSubview(dueDateLabel)
        dueDateLabel.snp.makeConstraints { (make) in
            make.firstBaseline.equalTo(projectLabel)
            make.left.equalTo(projectLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(projectLabel)
            make.top.equalTo(projectLabel.snp.bottom).offset(3)
            make.right.equalTo(dueDateLabel)
        }
        
        addSubview(taskLabel)
        taskLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    // MARK: - UI Config
    func config(with subtask: Subtask, time: MainViewController.DataTime) {
        projectLabel.text = subtask.project?.name ?? "Unknown Project"
        
        let dateFormatter = DateFormatter()
        switch time {
        case .today:
            dateFormatter.dateFormat = "h:m a"
        case .tomorrow:
            dateFormatter.dateFormat = "'tomorrow' h:m a"
        case .future:
            dateFormatter.dateFormat = "MMM d h:m a"
        }
        
        dueDateLabel.text = dateFormatter.string(from: subtask.dueDate ?? .distantFuture)
        
        titleLabel.text = subtask.content
        taskLabel.text = "from task: \(subtask.task?.content ?? "unknown task")"
    }
}
