//
//  ContentCell.swift
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

class ContentCell: UITableViewCell{
    
    let contentInput: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
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
        contentView.addSubview(contentInput)
        setupConstraints()
    }
    
    func setupConstraints(){
        contentInput.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
            make.height.equalTo(300)
        }
    }
    
    func configure(text: String){
        contentInput.text = text
        disposeBag = DisposeBag()
        setupTextFieldChangeObserver().disposed(by: disposeBag)
    }
    
    public func setupTextFieldChangeObserver(_ subscribeScheduler:  SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) -> Disposable{
        return contentInput.rx.text.orEmpty
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
