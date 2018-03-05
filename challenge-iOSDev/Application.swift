//
//  Application.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 04/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class Application {
    static let shared = Application()
    
    private let coreDataUseCaseProvider: UseCaseProvider
    
    private init() {
        coreDataUseCaseProvider = UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        let navigator = DefaultNotesNavigator(services: coreDataUseCaseProvider,
                                                navigationController: navigationController,
                                                storyBoard: storyboard)
        
        let vc = storyboard.instantiateViewController(ofType: NotesViewController.self)
        vc.viewModel = NotesViewModel(useCase: coreDataUseCaseProvider.makeNotesUseCase(),
                                      navigator: navigator)
        
        window.rootViewController = navigationController
        
        navigator.toNotes()
    }
}
