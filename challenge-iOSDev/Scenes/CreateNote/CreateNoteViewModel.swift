//
//  CreateNoteViewModel.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 04/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class CreateNoteViewModel: ViewModelType {
    private let createNoteUseCase: NotesUseCaseProtocol
    private let navigator: CreateNoteNavigator
    private let audioRecorder: AudioRecorder
    private let geolocationService = GeolocationService.instance
    private var location: Location?
    private var text: String = ""
    private let disposeBag = DisposeBag()
    
    init(createNoteUseCase: NotesUseCaseProtocol, navigator: CreateNoteNavigator) {
        self.createNoteUseCase = createNoteUseCase
        self.navigator = navigator
        self.audioRecorder = AudioRecorder()

        
        GeolocationService
            .instance
            .location
            .asObservable()
            .subscribe({ [weak self] l2D in
                self?.location = Location(location: l2D.element!)
            })
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let titleAndDetails = Driver.combineLatest([input.title, input.details]) {
            $0
        }
        let activityIndicator = ActivityIndicator()
        
        let canSave = Driver.combineLatest(titleAndDetails, activityIndicator.asDriver()) {
            return $0.count > 0 && !$1
        }
        
        let createdNote = Driver<Note>.combineLatest(titleAndDetails, geolocationService.location) {
            return Note(body: $0[1], title: $0[0], location: $1)
        }
        
        
        let save = input.saveTrigger.withLatestFrom(createdNote)
            .flatMapLatest { [weak self] in
                return (self?.createNoteUseCase.save(note: $0)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete())!
            }
        
        save.asObservable().subscribe(onNext: {
            [weak self] saved in
            self?.navigator.toNotes()
        }).disposed(by: disposeBag)
        
        let recording = input.recordTrigger.do(onNext: audioRecorder.start)
        let pause = input.pauseTrigger.do(onNext: audioRecorder.pause)
        
        let dismiss = Driver.of(save, input.cancelTrigger)
            .merge()
            .do(onNext: navigator.toNotes)
        
        return Output(dismiss: dismiss, saveEnabled: canSave, recording: recording, pause: pause, speech: audioRecorder.recordedText)
    }
}

extension CreateNoteViewModel {
    struct Input {
        let cancelTrigger: Driver<Void>
        let saveTrigger: Driver<Void>
        let recordTrigger: Driver<Void>
        let pauseTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }
    
    struct Output {
        let dismiss: Driver<Void>
        let saveEnabled: Driver<Bool>
        let recording: Driver<Void>
        let pause: Driver<Void>
        let speech: Variable<String>
    }
}
