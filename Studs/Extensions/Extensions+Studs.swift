//
//  Extensions+Studs.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import Foundation
import UIKit

protocol ScopeFunc {}
extension ScopeFunc {
    func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }
    
    func run(block: (Self) -> ()) {
        block(self)
    }
}

extension NSObject: ScopeFunc {}
