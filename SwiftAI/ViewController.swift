//
//  ViewController.swift
//  SwiftAI
//
//  Created by hhfa on 22/01/2018.
//  Copyright © 2018 hhfa. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftyJSON


class ViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {
    

    @IBOutlet weak var seachBt: NSButtonCell!
    
    
    @IBOutlet weak var jsonSrc: NSTextField!
    @IBOutlet weak var destPath: NSTextField!
    @IBOutlet weak var classNameText: NSTextField!
    @IBOutlet weak var baseClassNameText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        destPath.placeholderString = NSLocalizedString("ModelDest", comment: "")
        jsonSrc.placeholderString = NSLocalizedString("JSONSrc", comment: "")
        classNameText.placeholderString = NSLocalizedString("ClassName", comment: "")
        
    }
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func genCode(_ sender: Any) {
        let model = ModelFactory(base:baseClassNameText.stringValue,name:classNameText.stringValue)
        model.genModel(src: jsonSrc.stringValue,dest:destPath.stringValue);
    }
    
    
    
    @IBAction func selectDest(_ sender: Any) {
        
        let openPanel = NSOpenPanel();
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles = false;
        if(openPanel.runModal() == NSApplication.ModalResponse.OK) {
            //print(openPanel.url?.absoluteString)
            let path = openPanel.url?.absoluteString
            print("选择文件夹路径: \(String(describing: path))")
            destPath.stringValue = path!
            
        }
    }
    
    
    @IBAction func selectSrc(_ sender: Any) {
        let openPanel = NSOpenPanel();
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        if(openPanel.runModal() == NSApplication.ModalResponse.OK) {
            //print(openPanel.url?.absoluteString)
            let path = openPanel.url?.absoluteString
            print("选择文件夹路径: \(path)")
            jsonSrc.stringValue = path!
        }
        
        
    }
    
}

