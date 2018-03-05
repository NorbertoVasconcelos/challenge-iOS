//
//  NotesViewModel.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class NotesViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
        let createNoteTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let notes: Driver<[NoteItemViewModel]>
        let createNote: Driver<Void>
        let selectedNote: Driver<Note>
        let error: Driver<Error>
    }
    
    private let useCase: NotesUseCaseProtocol
    private let navigator: NotesNavigator
    
    init(useCase: NotesUseCaseProtocol, navigator: NotesNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let notes = input.trigger.flatMapLatest { _ in
            return self.useCase.notes()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { NoteItemViewModel(with: $0) } }
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedNote = input.selection
            .withLatestFrom(notes) { (indexPath, notes) -> Note in
                return notes[indexPath.row].note
            }
            .do(onNext: navigator.toNote)
        let createNote = input.createNoteTrigger
            .do(onNext: navigator.toCreateNote)
        
        return Output(fetching: fetching,
                      notes: notes,
                      createNote: createNote,
                      selectedNote: selectedNote,
                      error: errors)
    }
}
