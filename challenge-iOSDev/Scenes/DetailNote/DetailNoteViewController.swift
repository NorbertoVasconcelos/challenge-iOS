//
//  DetailNoteViewController.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import UIKit
import RxSwift

class DetailNoteViewController: UIViewController {

    @IBOutlet weak var btnListen: UIButton!
    @IBOutlet weak var btnDeleteNote: UIBarButtonItem!
    @IBOutlet weak var tvSpeech: UITextView!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    
    var viewModel: DetailNoteViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        
        let input = DetailNoteViewModel.Input(deleteTrigger: btnDeleteNote.rx.tap.asDriver(),
                                              speakTrigger: btnListen.rx.tap.asDriver())
        let output = viewModel?.transform(input: input)
        
        output?
            .note
            .asObservable()
            .subscribe(onNext: { [weak self] note in
                self?.tvSpeech.text = note.body
                let lat = Double(note.location.latitude).rounded(toPlaces: 3)
                let lon = Double(note.location.longitude).rounded(toPlaces: 3)
                self?.lblLatitude.text = "Lat: \(lat)"
                self?.lblLongitude.text = "Lon: \(lon)"
            })
            .disposed(by: disposeBag)
        
        output?
            .delete
            .drive()
            .disposed(by: disposeBag)
        
        output?
            .speak
            .drive()
            .disposed(by: disposeBag)
    }

}
