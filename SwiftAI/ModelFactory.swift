//
//  ModelFactory.swift
//  SwiftAI
//
//  Created by hhfa on 22/01/2018.
//  Copyright © 2018 hhfa. All rights reserved.
//

import Foundation
import SwiftyJSON

let modelSubFix = "Model"
let viewModelSubfix = "VM"

extension Type {
    func rawType(key:String) -> String {
        switch self {
        case .array:
            return "[\(key)]"
        case .dictionary:
            return key
        case.bool:
            return Keywords.Bool.rawValue
        case.number:
            return Keywords.Int.rawValue
        case.string:
            return Keywords.String.rawValue
        default:
            return "Any"
        }
    }
    
    func optionalType(key:String) -> String {
        switch self {
        case .array:
            let code = TypeDefine.optional(.custom(name: key)).code()
            return "[\(code)]"
        case .dictionary:
            return key
        case.bool:
            return TypeDefine.optional(.Bool).code()
        case.number:
            return TypeDefine.optional(.Int).code()
        case.string:
            return TypeDefine.optional(.String).code()
        default:
            return TypeDefine.optional(.Any).code()
        }
    }
}

class ModelFactory: ClassFactory  {
    var vm: ClassDefine?
    var nestClass:[String] = []
    
    init(base:StructDefine, name:String) {
        self.vm = ClassDefine(name + viewModelSubfix)
        super.init()
        self.baseClass = base
        
        self.this = StructDefine(name + modelSubFix)
        self.this?.parent = base
        let m = MemberDefine(name:"model" ,type: (self.this?.name)!, prefix:[Keywords.var.rawValue],getStament:[],setStament:[])
        self.vm?.add(m)
    }
    
    convenience init(base:String, name:String) {
        self.init(base:StructDefine(base),name:name)
    }
    
    fileprivate func visit(_ json: JSON, nestkey:String? = nil) {

        switch json.type {
        case .dictionary:
            
            if let nestkey = nestkey {
                let model = ModelFactory(base:baseClass!,name:nestkey)
                let modelCode  = model.genModel(json:json)
                nestClass.append(modelCode)
                return
            }
            
            for (key, value) in json.dictionary!
            {
                
                let property = MemberDefine(name:key ,type: value.type.optionalType(key: key + modelSubFix), prefix:["    ",Keywords.var.rawValue], getStament: [], setStament: [])
                
                let getStament = MemberDefine(name:key ,type: value.type.optionalType(key: key), prefix:[Keywords.var.rawValue], getStament: ["return model.\(key)"], setStament: [/*" model.\(key) = newValue"*/])
        
                vm?.add(getStament)

                
                this?.add(property)
                print(key)
                visit(value,nestkey: key)
            }
        case .array:
            if let nestkey = nestkey {
                
                if let value = json.array?.first
                {
                
                let model = ModelFactory(base:baseClass!,name:nestkey)
                let modelCode  = model.genModel(json:value)
                nestClass.append(modelCode)
                    }
            }

        default:
            print("-\(json.type)--\(json)")
        }
    }
    
    func genModel(src:String, dest:String) {
        //        let fileManager = FileManager.default;
        guard let fileUrl = URL(string:src) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            
            let json = try JSON(data: data)
            visit(json)
        } catch (let e)
        {
            print(e)
        }
        let r = this?.code()
        
        
        
        let fileUrl1 = URL(string:   dest + (self.this?.name)!  + ".swift")
        
        
        
        try? r?.write(to: fileUrl1!, atomically: true, encoding: String.Encoding.utf8)
        
        var initFunc = MethodsDefine(name:"init" ,type:"", prefix:[], parameters: [("model",(self.this?.name)!)], statements: [])
        initFunc.statements.append("self.model = model")
        self.vm?.add(initFunc)
        let vmcode = self.vm?.code()
        
        let fileUrlvm = URL(string:    dest + (self.vm?.name)!  + ".swift")
        try? vmcode?.write(to: fileUrlvm!, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func genModel(src:String, needViewModel:Bool = false ) ->String {
        
        let json = JSON( parseJSON:src)
        
       return genModel(json:json,needViewModel:needViewModel)
    }
    
    func genModel(json:JSON, needViewModel:Bool = false ) ->String {
        visit(json)
        
        let code = this?.code()
        let codes = [code!] + nestClass
        let allcode = codes.joined(separator: "\n")

        if needViewModel {
            var initFunc = MethodsDefine(name:"init" ,type:"", prefix:[], parameters: [("model",(self.this?.name)!)], statements: [])
            initFunc.statements.append("self.model = model")
            self.vm?.add(initFunc)
            let vmcode = self.vm?.code()
            return allcode + " \n" + vmcode!
        }
        
        return allcode
    }
}

