//
//  NotesViewController.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddNote: UIBarButtonItem!
    
    var viewModel: NotesViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "NoteTableViewCell" , bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = NotesViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                         createNoteTrigger: btnAddNote.rx.tap.asDriver(),
                                         selection: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.notes.drive(tableView.rx.items(cellIdentifier: NoteTableViewCell.reuseID, cellType: NoteTableViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
            
            }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.createNote
            .drive()
            .disposed(by: disposeBag)
        
        output.selectedNote
            .drive()
            .disposed(by: disposeBag)
    }

}
