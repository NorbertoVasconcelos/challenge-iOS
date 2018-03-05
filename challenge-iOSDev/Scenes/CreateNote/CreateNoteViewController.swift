//
//  CreateNoteViewController.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit
import RxSwift

class CreateNoteViewController: UIViewController {

    @IBOutlet weak var tvTitle: UITextField!
    @IBOutlet weak var tvSpeech: UITextView!
    @IBOutlet weak var btnSaveNote: UIBarButtonItem!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: CreateNoteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()

        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let btn = UIBarButtonItem()
        btn.title = "Stop Editing"
        btn.rx.tap.subscribe({
            [weak self] _ in
            self?.tvSpeech.endEditing(true)
        })
        .disposed(by: disposeBag)
        
        keyboardToolbar.items = [btn]
        tvSpeech.inputAccessoryView = keyboardToolbar
        
        
    }

    private func bindViewModel() {
        
        let input = CreateNoteViewModel.Input(cancelTrigger: btnSaveNote.rx.tap.asDriver(),
                                              saveTrigger: btnSaveNote.rx.tap.asDriver(),
                                              recordTrigger: btnRecord.rx.tap.asDriver(),
                                              pauseTrigger: btnPause.rx.tap.asDriver(),
                                              title: tvTitle.rx.text.orEmpty.asDriver(),
                                              details: tvSpeech.rx.text.orEmpty.asDriver())
        
        let output = viewModel?.transform(input: input)
        
        output?.dismiss.drive()
            .disposed(by: disposeBag)
        output?.saveEnabled.drive(btnSaveNote.rx.isEnabled)
            .disposed(by: disposeBag)
        output?.recording.drive().disposed(by: disposeBag)
        output?.pause.drive().disposed(by: disposeBag)
        
        output?
            .speech
            .asObservable()
            .subscribe(onNext: { [weak self] text in
                self?.tvSpeech.text = text
            })
            .disposed(by: disposeBag)
    }

}
