//
//  NoteUseCase.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import RxSwift

public protocol NotesUseCaseProtocol {
    func notes() -> Observable<[Note]>
    func save(note: Note) -> Observable<Void>
    func delete(note: Note) -> Observable<Void>
}

final class NotesUseCase<Repository>: NotesUseCaseProtocol where Repository: AbstractRepository, Repository.T == Note {
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func notes() -> Observable<[Note]> {
        return repository.query(with: nil, sortDescriptors: [Note.CoreDataType.createdAt.descending()])
    }
    
    func save(note: Note) -> Observable<Void> {
        return repository.save(entity: note)
    }
    
    func delete(note: Note) -> Observable<Void> {
        return repository.delete(entity: note)
    }
}
