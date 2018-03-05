//
//  NoteItemViewModel.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation

final class NoteItemViewModel   {
    let title:String
    let subtitle : String
    let note: Note
    
    init (with note:Note) {
        self.note = note
        self.title = ""
        self.subtitle = ""
    }
}
