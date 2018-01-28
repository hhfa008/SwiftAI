//
//  ██╗  ██╗████████╗███████╗██╗  ██╗████████╗
//  ╚██╗██╔╝╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝
//   ╚███╔╝    ██║   █████╗   ╚███╔╝    ██║
//   ██╔██╗    ██║   ██╔══╝   ██╔██╗    ██║
//  ██╔╝ ██╗   ██║   ███████╗██╔╝ ██╗   ██║
//  ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝
//
//  xTextProtocol.swift
//  xTextHandler (https://github.com/cyanzhong/xTextHandler/)
//
//  Created by cyan on 16/7/4.
//  Copyright © 2016年 cyan. All rights reserved.
//

import XcodeKit

/// Modify text using this closure
typealias xTextModifyHandler = (String) -> (String)

/// Text protocol
protocol xTextProtocol: XCSourceEditorCommand {
  
  /// Handlers map
  ///
  /// - returns: [ "commandIdentifier": xTextModifyHandler ]
  func handlers() -> Dictionary<String, xTextModifyHandler>
}
