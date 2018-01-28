//
//  VMFactory.swift
//  SwiftAI
//
//  Created by hhfa on 22/01/2018.
//  Copyright © 2018 hhfa. All rights reserved.
//

import Foundation

class VMFactory : ClassFactory {
    var model : ModelFactory
    init(model:ModelFactory) {
        self.model = model
    }
    
    func genVM(dest:String) -> () {
        
    }
}
