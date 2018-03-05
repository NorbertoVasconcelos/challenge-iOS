//
//  NotesNavigator.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

protocol NotesNavigator {
    func toCreateNote()
    func toNote(_ note: Note)
    func toNotes()
}

class DefaultNotesNavigator: NotesNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(services: UseCaseProvider,
         navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.services = services
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toNotes() {
        let vc = storyBoard.instantiateViewController(ofType: NotesViewController.self)
        vc.viewModel = NotesViewModel(useCase: services.makeNotesUseCase(),
                                      navigator: self as NotesNavigator)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toCreateNote() {
        let navigator = DefaultCreateNoteNavigator(navigationController: navigationController)
        let vc = storyBoard.instantiateViewController(ofType: CreateNoteViewController.self)
        vc.viewModel = CreateNoteViewModel(createNoteUseCase: services.makeNotesUseCase(),
                                           navigator: navigator)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toNote(_ note: Note) {
        let navigator = DefaultDetailNoteNavigator(navigationController: navigationController)
        let vc = storyBoard.instantiateViewController(ofType: DetailNoteViewController.self)
        vc.viewModel = DetailNoteViewModel(detailNoteUseCase: services.makeNotesUseCase(), navigator: navigator, note: note)
        navigationController.pushViewController(vc, animated: true)
    }
}
