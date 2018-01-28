//
//  ██╗  ██╗████████╗███████╗██╗  ██╗████████╗
//  ╚██╗██╔╝╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝
//   ╚███╔╝    ██║   █████╗   ╚███╔╝    ██║
//   ██╔██╗    ██║   ██╔══╝   ██╔██╗    ██║
//  ██╔╝ ██╗   ██║   ███████╗██╔╝ ██╗   ██║
//  ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝
//
//  xTextCommand.swift
//  xTextHandler (https://github.com/cyanzhong/xTextHandler/)
//
//  Created by cyan on 16/7/4.
//  Copyright © 2016年 cyan. All rights reserved.
//

import XcodeKit

/// Text command with default implemention
class xTextCommand: NSObject, xTextProtocol {
  
  /// Handlers map
  ///
  /// - returns: implement in subclass
  func handlers() -> Dictionary<String, xTextModifyHandler> {
    return [:]
  }
  
  /// Texts handling method
  /// If you want to match any text, do nothing in subclass
  /// If you want to match text with your pattern, override this method in subclas
  /// - parameter invocation:        XCSourceEditorCommandInvocation
  /// - parameter completionHandler: nil or Error
  func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
    if let handler = handlers()[invocation.commandIdentifier] {
      xTextModifier.any(invocation: invocation, handler: handler)
    }
    completionHandler(nil)
  }
}
