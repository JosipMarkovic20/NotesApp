//
//  NotesDetailsViewController.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class NotesDetailsViewController: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var viewModel: NotesDetailsViewModel!
    weak var detailsDelegate: NotesDetailsDelegate?
    let disposeBag = DisposeBag()
    weak var coordinatorDelegate: CoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent{
            coordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func setupUI(){
        initializeVM()
        addNavBarItem()
        setupContent()
    }
    
    func initializeVM(){
        let input = NotesDetailsViewModel.Input()
        let output = viewModel.transform(input: input)
        output.disposables.forEach { (disposable) in
            disposable.disposed(by: disposeBag)
        }
        initializeViewRefresh(for: output.refreshViewSubject).disposed(by: disposeBag)
    }
    
    func initializeViewRefresh(for subject: PublishSubject<()>) -> Disposable{
        return subject
            .subscribeOn(viewModel.dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (_) in
                self.setupContent()
            })
    }
    
    func setupContent(){
        titleLabel.text = viewModel.dependencies.note.title
        contentLabel.text = viewModel.dependencies.note.content
        dateLabel.text = viewModel.dependencies.note.date
    }
    
    func addNavBarItem(){
        let barItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(openEditMode))
        barItem.tintColor = R.color.navButton()
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func openEditMode(){
        detailsDelegate?.editNote(note: viewModel.dependencies.note)
    }
}

