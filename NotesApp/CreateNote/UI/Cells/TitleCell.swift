//
//  TitleCell.swift
//  NotesApp
//
//  Created by Josip Marković on 02/06/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TitleCell: UITableViewCell{
    
    let titleInput: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = R.string.localizable.title_placeholder()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    public var textChangedValue:( (String) -> ())?
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        selectionStyle = .none
        contentView.addSubview(titleInput)
        setupConstraints()
    }
    
    func setupConstraints(){
        titleInput.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func configure(text: String){
        titleInput.text = text
        disposeBag = DisposeBag()
        setupTextFieldChangeObserver().disposed(by: disposeBag)
    }
    
    public func setupTextFieldChangeObserver(_ subscribeScheduler:  SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) -> Disposable{
        return titleInput.rx.text.orEmpty
            .distinctUntilChanged({ (first, second) -> Bool in
                return  first == second
            })
            .debounce(.milliseconds(250), scheduler: subscribeScheduler)
            .asDriver(onErrorJustReturn: "")
            .do(onNext: {[unowned self] (text) in
                self.textChangedValue?(text)
            })
            .drive()
    }
}

