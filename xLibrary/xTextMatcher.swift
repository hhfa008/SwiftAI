//
//  ██╗  ██╗████████╗███████╗██╗  ██╗████████╗
//  ╚██╗██╔╝╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝
//   ╚███╔╝    ██║   █████╗   ╚███╔╝    ██║
//   ██╔██╗    ██║   ██╔══╝   ██╔██╗    ██║
//  ██╔╝ ██╗   ██║   ███████╗██╔╝ ██╗   ██║
//  ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝
//
//  xTextMatcher.swift
//  xTextHandler (https://github.com/cyanzhong/xTextHandler/)
//
//  Created by cyan on 16/7/4.
//  Copyright © 2016年 cyan. All rights reserved.
//

import XcodeKit
import AppKit

/// Match options
struct xTextMatchOptions: OptionSet {
  let rawValue: Int
  static let selected     = xTextMatchOptions(rawValue: 0)
  static let clipboard    = xTextMatchOptions(rawValue: 1 << 0)
  static let cursor       = xTextMatchOptions(rawValue: 1 << 1)
}

/// Text match result struct
struct xTextMatchResult {
  
  var text: String        // full text
  var range: NSRange      // replace range
  var clipboard: Bool     // is clipboard text or not
  
  /// Result from text & clipped text
  ///
  /// - parameter aText:   full text
  /// - parameter clipped: clipped text
  ///
  /// - returns: xTextMatchResult
  init(aText: String, clipped: String) {
    text = aText
    range = (aText as NSString).range(of: clipped)
    clipboard = false
  }
  
  /// Result from clipboard text
  ///
  /// - returns: xTextMatchResult
  static func clipboardResult() -> xTextMatchResult {
    let text = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string) ?? ""
    var result = xTextMatchResult(aText: text, clipped: text)
    result.clipboard = true
    return result
  }
}

/// Match selected lines
class xTextMatcher {
  typealias xTextSelectionLineHandler = (Int, String, String) -> ()
  
  private static let xTextInvalidLine = -1 // stand for invalid index
  
  /// Enumerate lines in XCSourceEditorCommandInvocation
  ///
  /// - parameter invocation:  XCSourceEditorCommandInvocation
  /// - parameter selection:   XCSourceTextRange
  /// - parameter options:     xTextMatchOptions
  /// - parameter lineHandler: (index, line, clipped)
  static func enumerate(invocation: XCSourceEditorCommandInvocation, selection: XCSourceTextRange, options: xTextMatchOptions, lineHandler: xTextSelectionLineHandler) {
    
    let startLine = selection.start.line
    let startColumn = selection.start.column
    let endLine = selection.end.line
    let endColumn = selection.end.column
    
    if options.contains(.clipboard) { // match clipboard
      lineHandler(xTextInvalidLine, "", "")
      return
    } else if startLine == endLine && startColumn == endColumn { // select nothing
      if options.contains(.cursor) { // match current line
        let text = invocation.buffer.lines[startLine] as! String
        lineHandler(startLine, text, text)
        return
      } else { // match clipboard
        lineHandler(xTextInvalidLine, "", "")
        return
      }
    }
    
    // enumerate lines
    for index in startLine...endLine {
      
      let line = invocation.buffer.lines[index] as! NSString
      var clipped: String
      
      if startLine == endLine { // single line
        clipped = line.substring(with: NSMakeRange(startColumn, endColumn - startColumn))
      } else if index == startLine { // first line
        clipped = line.substring(from: startColumn)
      } else if index == endLine { // last line
        clipped = line.substring(to: endColumn)
      } else { // common line
        clipped = line as String
      }
      
      if clipped.characters.count > 0 {
        lineHandler(index, line as String, clipped)
      }
    }
  }
  
  /// Match texts in XCSourceEditorCommandInvocation with default option
  ///
  /// - parameter selection:  XCSourceTextRange
  /// - parameter invocation: XCSourceEditorCommandInvocation
  ///
  /// - returns: match result
  static func match(selection: XCSourceTextRange, invocation: XCSourceEditorCommandInvocation) -> xTextMatchResult {
    return match(selection: selection, invocation: invocation, options: [.selected])
  }
  
  /// Match texts in XCSourceEditorCommandInvocation
  ///
  /// - parameter selection:  XCSourceTextRange
  /// - parameter invocation: XCSourceEditorCommandInvocation
  /// - parameter options:    xTextMatchOptions
  ///
  /// - returns: match result
  static func match(selection: XCSourceTextRange, invocation: XCSourceEditorCommandInvocation, options: xTextMatchOptions) -> xTextMatchResult {
    
    var lineText = ""
    var clippedText = ""
    var clipboard = false
    
    // enumerate each lines
    enumerate(invocation: invocation, selection: selection, options: options) { index, line, clipped in
      lineText.append(line)
      clippedText.append(clipped)
      clipboard = (index == xTextInvalidLine)
    }
    
    // clipboard result or selected result
    return clipboard ? xTextMatchResult.clipboardResult() : xTextMatchResult(aText: lineText, clipped: clippedText)
  }
}
