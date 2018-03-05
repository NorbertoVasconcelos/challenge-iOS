//
//  CreateNoteNavigator.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 04/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

protocol CreateNoteNavigator {
    
    func toNotes()
}

final class DefaultCreateNoteNavigator: CreateNoteNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toNotes() {
        navigationController.popViewController(animated: true)
    }
}
