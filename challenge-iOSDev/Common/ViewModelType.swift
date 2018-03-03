//
//  ViewModelType.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
