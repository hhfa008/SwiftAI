//
//  SourceEditorCommand.swift
//  JSONAI
//
//  Created by hhfa on 28/01/2018.
//  Copyright © 2018 hhfa. All rights reserved.
//

import Foundation
import XcodeKit
import SwiftyJSON

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        let range = invocation.buffer.selections.firstObject as! XCSourceTextRange
        // match clipped text
        let match = xTextMatcher.match(selection: range, invocation: invocation, options: .selected)

        let endLineIndex = range.end.line
        let jsonstr = match.text
        
       let baseClass =  invocation.commandIdentifier
       let model = ModelFactory(base:baseClass,name:"<#NewModelName#>")
        let modelCode  = model.genModel(src: jsonstr)
        invocation.buffer.lines.insert(modelCode, at: endLineIndex)
        completionHandler(nil)
    }
    
}
