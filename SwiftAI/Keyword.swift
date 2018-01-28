//
//  Keyword.swift
//  SwiftAI
//
//  Created by hhfa on 22/01/2018.
//  Copyright © 2018 hhfa. All rights reserved.
//

import Foundation
enum Keywords : String {
    case `associatedtype`
    case `class`
    case `deinit`
    case `enum`
    case `extension`
    case `fileprivate`
    case `func`
    case `import`
    case `inout`
    case `internal`
    case `let`
    case `open`
    case `operator`
    case `private`
    case `protocol`
    case `public`
    case `static`
    case `struct`
    case `subscript`
    case `typealias`
    case `var`
    case `break`
    case `case`
    case `continue`
    case `default`
    case `defer`
    case `do`
    case `else`
    case `fallthrough`
    case `for`
    case `guard`
    case `if`
    case `in`
    case `repeat`
    case `return`
    case `switch`
    case `where`
    case `while`
    case `as`
    case `Any`
    case `catch`
    case `false`
    case `is`
    case `nil`
    case `rethrows`
    case `super`
    case `self`
    case `Self`
    case `throw`
    case `throws`
    case `true`
    case `try`
    case `_`
    case `associativity`
    case `convenience`
    case `dynamic`
    case `didSet`
    case `final`
    case `get`
    case `infix`
    case `indirect`
    case `lazy`
    case `left`
    case `mutating`
    case `nonmutating`
    case `optional`
    case `override`
    case `postfix`
    case `precedence`
    case `prefix`
    case `Protocol`
    case `required`
    case `right`
    case `set`
    case `Type`
    case `unowned`
    case `weak`
    case `willSet`
    case `String`
    case `Int`
    case `Double`
    case `Bool`
    case `Data`
    case `CommandLine`
    case `FileHandle`
    case `JSONSerialization`
    case `checkNull`
    case `removeNSNull`
    case `nilToNSNull`
    case `convertArray`
    case `convertOptional`
    case `convertDict`
    case `convertDouble`
    case `jsonString`
    case `jsonData`
}

enum OptionalType {
    case String
    case Int
    case Float
    case Double
    case Array
    case Bool
    case `Any`
    case custom( name :String)
    func name() -> String {
        switch self {
        case .custom(let name):
            return "\(name)?"
        default:
            return "\(self)?"
        }
    }
}

enum TypeDefine {
    case raw(Keywords)
    case optional(OptionalType)
    func code() -> String {
        switch self {
        case .optional(let optional):
            return optional.name()
        case .raw(let raw):
            return raw.rawValue
        }
    }
    
    
}

