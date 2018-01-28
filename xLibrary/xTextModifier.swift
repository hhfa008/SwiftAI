//
//  ██╗  ██╗████████╗███████╗██╗  ██╗████████╗
//  ╚██╗██╔╝╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝
//   ╚███╔╝    ██║   █████╗   ╚███╔╝    ██║
//   ██╔██╗    ██║   ██╔══╝   ██╔██╗    ██║
//  ██╔╝ ██╗   ██║   ███████╗██╔╝ ██╗   ██║
//  ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝
//
//  xTextModifier.swift
//  xTextHandler (https://github.com/cyanzhong/xTextHandler/)
//
//  Created by cyan on 16/7/4.
//  Copyright © 2016年 cyan. All rights reserved.
//

import XcodeKit
import AppKit

/// Text matching & handling
class xTextModifier {
  
  /// Regular expressions
  private static let xTextHandlerStringPattern    = "\"(.+)\""                    // match "abc"
  private static let xTextHandlerHexPattern       = "([0-9a-fA-F]+)"              // match 00FFFF
  private static let xTextHandlerRGBPattern       = "([0-9]+.+[0-9]+.+[0-9]+)"    // match 20, 20, 20 | 20 20 20 ...
  private static let xTextHandlerRadixPattern     = "([0-9]+)"                    // match numbers
  
  /// Select text with regex & default option
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter pattern:    regex pattern
  /// - parameter handler:    handler
  static func select(invocation: XCSourceEditorCommandInvocation, pattern: String?, handler: xTextModifyHandler) {
    select(invocation: invocation, pattern: pattern, options: [.selected], handler: handler)
  }
  
  /// Select text with regex
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter pattern:    regex pattern
  /// - parameter options:    xTextMatchOptions
  /// - parameter handler:    handler
  static func select(invocation: XCSourceEditorCommandInvocation, pattern: String?, options: xTextMatchOptions, handler: xTextModifyHandler) {
    
    var regex: NSRegularExpression?
    
    if pattern != nil {
      do {
        try regex = NSRegularExpression(pattern: pattern!, options: .caseInsensitive)
      } catch {
        xTextLog(string: "Create regex failed")
      }
    }
    
    // enumerate selections
    for i in 0..<invocation.buffer.selections.count {
      
      let range = invocation.buffer.selections[i] as! XCSourceTextRange
      // match clipped text
      let match = xTextMatcher.match(selection: range, invocation: invocation, options: options)
      
      if match.clipboard { // handle clipboard text
        if match.text.characters.count > 0 {
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
            pasteboard.setString(handler(match.text), forType: NSPasteboard.PasteboardType.string)
        }
        continue
      }
      
      if match.text.characters.count == 0 {
        continue
      }
      
      // handle selected text
      var texts: Array<String> = []
      if regex != nil { // match using regex
        regex!.enumerateMatches(in: match.text, options: [], range: match.range, using: { result, flags, stop in
            if let range = result?.range(at: 1) {
            texts.append((match.text as NSString).substring(with: range))
          }
        })
      } else { // match all
        texts.append((match.text as NSString).substring(with: match.range))
      }
      
      if texts.count == 0 {
        continue
      }
      
      var replace = match.text
      for text in texts {
        // replace each matched text with handler block
        if let textRange = replace.range(of: text) {
          replace.replaceSubrange(textRange, with: handler(text))
        }
      }
      
      // separate text to lines using newline charset
      var lines = replace.components(separatedBy: NSCharacterSet.newlines)
      lines.removeLast()
      // update buffer
      invocation.buffer.lines.replaceObjects(in: NSMakeRange(range.start.line, range.end.line - range.start.line + 1), withObjectsFrom: lines)
      // cancel selection
      let newRange = XCSourceTextRange()
      newRange.start = range.start
      newRange.end = range.start
      invocation.buffer.selections[i] = newRange
    }
  }
  
  /// Select any text with default option
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter handler:    handler
  static func any(invocation: XCSourceEditorCommandInvocation, handler: xTextModifyHandler) {
    any(invocation: invocation, options: [.selected], handler: handler)
  }
  
  /// Select any text
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter options:    xTextMatchOptions
  /// - parameter handler:    handler
  static func any(invocation: XCSourceEditorCommandInvocation, options: xTextMatchOptions, handler: xTextModifyHandler) {
    select(invocation: invocation, pattern: nil, options: options, handler: handler)
  }
  
  /// Select numbers
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter handler:    handler
  static func radix(invocation: XCSourceEditorCommandInvocation, handler: xTextModifyHandler) {
    select(invocation: invocation, pattern: xTextHandlerRadixPattern, handler: handler)
  }
  
  /// Select hex color
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter handler:    handler
  static func hex(invocation: XCSourceEditorCommandInvocation, handler: xTextModifyHandler) {
    select(invocation: invocation, pattern: xTextHandlerHexPattern, handler: handler)
  }
  
  /// Select RGB color
  ///
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter handler:    handler
  static func rgb(invocation: XCSourceEditorCommandInvocation, handler: xTextModifyHandler) {
    select(invocation: invocation, pattern: xTextHandlerRGBPattern, handler: handler)
  }
}
