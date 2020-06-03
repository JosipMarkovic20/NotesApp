//
//  NoteCell.swift
//  NotesApp
//
//  Created by Josip Marković on 30/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class NoteCell: UITableViewCell{
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
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
        selectionStyle = .none
        contentView.addSubview(title)
        contentView.addSubview(date)
        setupConstraints()
    }
    
    private func setupConstraints(){
        title.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(15)
        }
        date.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.bottom.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    func configure(note: Note){
        title.text = note.title
        date.text = note.date
    }
}
