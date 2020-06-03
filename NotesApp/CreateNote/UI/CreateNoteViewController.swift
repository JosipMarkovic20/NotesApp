//
//  CreateNoteViewController.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class CreateNoteViewController: UIViewController{
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let TITLE_CELL = "TitleCell"
    let CONTENT_CELL = "ContentCell"
    let SAVE_CELL = "SaveCell"
    let viewModel: CreateNoteViewModel
    let disposeBag = DisposeBag()
    weak var coordinatorDelegate: CoordinatorDelegate?
    
    init(viewModel: CreateNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeVM()
        viewModel.input.loadDataSubject.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent{
            coordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    func setupUI(){
        if viewModel.dependencies.note != nil{
            title = R.string.localizable.edit_a_note()
        }else{
            title = R.string.localizable.create_a_note()
        }
        view.addSubview(tableView)
        setupConstraints()
        setupTableView()
    }
    
    
    func setupConstraints(){
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func initializeVM(){
        let input = CreateNoteViewModel.Input(loadDataSubject: ReplaySubject.create(bufferSize: 1),
                                             userInteractionSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        output.disposables.forEach { (disposable) in
            disposable.disposed(by: disposeBag)
        }
        initializeTableRefresh(for: output.refreshTableView).disposed(by: disposeBag)
        initializePopControllerSubject(for: output.popControllerSubject).disposed(by: disposeBag)
    }
    
    func initializePopControllerSubject(for subject: PublishSubject<()>) -> Disposable{
        return subject
        .subscribeOn(viewModel.dependencies.subscribeScheduler)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {[unowned self] (tableRefresh) in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func initializeTableRefresh(for subject: PublishSubject<TableRefresh>) -> Disposable{
        return subject
            .subscribeOn(viewModel.dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (tableRefresh) in
                switch tableRefresh{
                case .reloadTable:
                    self.tableView.reloadData()
                case .deleteRows(let indexPaths):
                    self.tableView.deleteRows(at: indexPaths, with: .automatic)
                case .insertRows(let indexPaths):
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                case .reloadRows(let indexPaths):
                    self.tableView.reloadRows(at: indexPaths, with: .automatic)
                }
            })
    }
    
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TitleCell.self, forCellReuseIdentifier: TITLE_CELL)
        tableView.register(ContentCell.self, forCellReuseIdentifier: CONTENT_CELL)
        tableView.register(SaveButtonCell.self, forCellReuseIdentifier: SAVE_CELL)
    }
}

extension CreateNoteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.output.screenData[indexPath.row]
        switch item{
        case .titleField(let text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TITLE_CELL) as? TitleCell else {
                fatalError("The dequeued cell is not an instance of NoteCell.")
            }
            cell.configure(text: text)
            cell.textChangedValue = {[unowned self] (text) in
                self.viewModel.input.userInteractionSubject.onNext(.titleInput(text: text))
            }
            return cell
        case .contentField(let text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CONTENT_CELL) as? ContentCell else {
                fatalError("The dequeued cell is not an instance of NoteCell.")
            }
            cell.configure(text: text)
            cell.textChangedValue = {[unowned self] (text) in
                self.viewModel.input.userInteractionSubject.onNext(.contentInput(text: text))
            }
            return cell
        case .saveButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SAVE_CELL) as? SaveButtonCell else {
                fatalError("The dequeued cell is not an instance of NoteCell.")
            }
            cell.saveButtonPressed = {[unowned self] in
                self.viewModel.input.userInteractionSubject.onNext(.saveButtonClicked)
            }
            return cell
        }
    }
    
}
