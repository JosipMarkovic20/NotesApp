//
//  EmptyListCell.swift
//  NotesApp
//
//  Created by Josip Marković on 31/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class EmptyListCell: UITableViewCell{
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.text = R.string.localizable.empty_list()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(title)
        setupConstraints()
    }
    
    private func setupConstraints(){
        title.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
        }
    }
}
