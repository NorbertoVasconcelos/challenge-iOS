//
//  DetailNoteNavigator.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 05/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

protocol DetailNoteNavigator {
    
    func toNotes()
}

final class DefaultDetailNoteNavigator: DetailNoteNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toNotes() {
        navigationController.popViewController(animated: true)
    }
}
