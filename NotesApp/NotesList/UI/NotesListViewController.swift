//
//  ViewController.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class NotesListViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let NOTE_CELL_IDENTIFIER = "NoteCell"
    let EMPTY_CELL_IDENTIFIER = "EmptyCell"
    let viewModel: NotesListViewModel
    let disposeBag = DisposeBag()
    weak var coordinatorDelegate: CoordinatorDelegate?
    
    init(viewModel: NotesListViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        view.addSubview(tableView)
        self.title = R.string.localizable.title()
        setupConstraints()
        setupTableView()
        addItemToNavBar()
    }
    
    func addItemToNavBar(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddScreen))
        addButton.tintColor = R.color.navButton()
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func openAddScreen(){
        viewModel.input.userInteractionSubject.onNext(.openAddNote)
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func initializeVM(){
        let input = NotesListViewModel.Input(loadDataSubject: ReplaySubject.create(bufferSize: 1),
                                             userInteractionSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        output.disposables.forEach { (disposable) in
            disposable.disposed(by: disposeBag)
        }
        initializeTableRefresh(for: output.refreshTableView).disposed(by: disposeBag)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: NOTE_CELL_IDENTIFIER)
        tableView.register(EmptyListCell.self, forCellReuseIdentifier: EMPTY_CELL_IDENTIFIER)
    }
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.output.screenData[indexPath.row]
        switch item{
        case .note(let note):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NOTE_CELL_IDENTIFIER) as? NoteCell else {
                fatalError("The dequeued cell is not an instance of NoteCell.")
            }
            cell.configure(note: note)
            return cell
        case .empty:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EMPTY_CELL_IDENTIFIER) as? EmptyListCell else {
                fatalError("The dequeued cell is not an instance of EmptyListCell.")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.userInteractionSubject.onNext(.openDetails(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            viewModel.input.userInteractionSubject.onNext(.deleteNote(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewModel.output.screenData[indexPath.row] == .empty{
            return .none
        }else{
            return .delete
        }
    }
}
