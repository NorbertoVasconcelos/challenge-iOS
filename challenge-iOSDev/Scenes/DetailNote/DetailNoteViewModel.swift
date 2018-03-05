//
//  DetailNoteViewModel.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 05/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailNoteViewModel: ViewModelType {
    private let detailNoteUseCase: NotesUseCaseProtocol
    private let navigator: DetailNoteNavigator
    private let note: Note
    private let disposeBag = DisposeBag()
    
    init(detailNoteUseCase: NotesUseCaseProtocol, navigator: DetailNoteNavigator, note: Note) {
        self.detailNoteUseCase = detailNoteUseCase
        self.navigator = navigator
        self.note = note
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let note: Driver<Note> = Driver.just(self.note)
        
        let deleteNote = input.deleteTrigger.withLatestFrom(note)
            .flatMapLatest { note in
                return self.detailNoteUseCase.delete(note: note)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.do(onNext: {
                self.navigator.toNotes()
            })
        
        let speakText = input.speakTrigger.do(onNext: {
            SpeechSynthesizer().speak(text: self.note.body)
        })
        
        return Output(note: note, delete: deleteNote, speak: speakText)
    }
}

extension DetailNoteViewModel {
    struct Input {
        let deleteTrigger: Driver<Void>
        let speakTrigger: Driver<Void>
    }
    
    struct Output {
        let note: Driver<Note>
        let delete: Driver<Void>
        let speak: Driver<Void>
    }
}
