//
//  UseCaseProvider.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import QueryKit

public protocol UseCaseProviderProtocol {
    
    func makeNotesUseCase() -> NotesUseCaseProtocol
}

public final class UseCaseProvider: UseCaseProviderProtocol {
    private let coreDataStack = CoreDataStack()
    private let noteRepository: Repository<Note>
    
    public init() {
        noteRepository = Repository<Note>(context: coreDataStack.context)
    }
    
    public func makeNotesUseCase() -> NotesUseCaseProtocol {
        return NotesUseCase(repository: noteRepository)
    }
}
