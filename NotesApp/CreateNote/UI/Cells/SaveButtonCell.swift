//
//  SaveButtonCell.swift
//  NotesApp
//
//  Created by Josip Marković on 02/06/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SaveButtonCell: UITableViewCell {
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(R.string.localizable.save_button(), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    public var saveButtonPressed: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        selectionStyle = .none
        contentView.addSubview(saveButton)
        setupConstraints()
        saveButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed(){
        saveButtonPressed?()
    }
    
    func setupConstraints(){
        saveButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(80)
        }
    }
}
