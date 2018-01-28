//
//  CodeFactory.swift
//  SwiftAI
//
//  Created by hhfa on 20/01/2018.
//  Copyright © 2018 hhfa. All rights reserved.
//

import Foundation

struct MemberDefine {
    var name:String
    var type:String
    var prefix:[String] = []
    var getStament:[String] = []
    var setStament:[String] = []
    func code() -> String {
        let define = prefix.joined(separator: "  ") + " " + name + ": " + type
        
        var body = ""
        if getStament.count > 0 {
            
           var bodyLines = [String]()
            if setStament.count > 0 {
                
                bodyLines.append("set(newValue)")
                var setlines = setStament
                CodeFactory.wrap(lines: &setlines)
                bodyLines += setlines
                bodyLines.append("get")
             
                
            }
   
            
                var lines = getStament
                CodeFactory.wrap(lines: &lines)
                bodyLines += lines
            
            if setStament.count > 0
            {
                  CodeFactory.wrap(lines: &bodyLines)
            }
            
            body = bodyLines.joined(separator: "\n")
        }
   
        
        return define + " " + body;
    }
}

class StatementDefine {
    var type:String?
    var statements:[String] = []
    func code() -> String {
        return  statements.joined(separator: "\n")
    }
}

struct MethodsDefine {
    var name:String
    var type:String
    var prefix:[String] = []
    var parameters:[(String,String)] = []
    var statements:[String] = []
    func code() -> String {
        
        let returnstament = type.count > 0 ? "->" + type : ""
        
        var para  = self.parameters
       
        let paraStr = CodeFactory.gen(lines: &para)
        let p = paraStr.joined(separator: ",")
        
        let define = prefix.joined(separator: "  ") + " " + name + "(\(p))" + returnstament
        
        var lines = statements
        CodeFactory.wrap(lines: &lines)
        
        let body = lines.joined(separator: "\n")
        
        return  define + " " + body
    }
}

class StructDefine
{
    var properties:[MemberDefine] = []
    var methods:[MethodsDefine] = []
    var name:String
    var typeName:String {return Keywords.struct.rawValue}
    var parent:StructDefine?
    
    @discardableResult
    func add(_ m:MemberDefine) -> Bool {
        properties.append(m)
        return true
    }
    
    @discardableResult
    func add(_ m:MethodsDefine) -> Bool {
        methods.append(m)
        return true
    }

    init(_ name:String) {
        self.name = name
    }
    
    func code() -> String? {
        var classDefine = typeName + " " + name
        if let parent = self.parent {
             classDefine  = classDefine + ": " + parent.name
        }
        
        let propertylines = CodeFactory.gen(lines: &self.properties)
        let methodslines = CodeFactory.gen(lines: &self.methods)
        var bodyLines = propertylines + methodslines
        CodeFactory.wrap(lines: &bodyLines)
        
       let body = bodyLines.joined(separator: "\n")
        
        return classDefine + " " + body
    }
}

class ClassDefine : StructDefine
{
  
    override var typeName :String {return Keywords.class.rawValue}
    
}

class CodeFactory {
   class func wrap( lines:inout [String]) -> Void{
        lines.append("}")
        lines.insert("{", at: 0)
        return 
    }
    
    class func gen( lines:inout [(String,String)] ) -> [String] {
        return lines.map { (name, type) -> String in
            return name + ":" + type
        }
    }
    
    class func gen( lines:inout [MemberDefine]) -> [String] {
       return lines.map { (member) -> String in
            return member.code()
        }
    }
    
    class func gen( lines:inout [MethodsDefine]) -> [String] {
        return lines.map { (member) -> String in
            return member.code()
        }
    }
}

extension String {
    
}
