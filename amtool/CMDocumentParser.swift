//
//  CMDocumentParser.swift
//  AcceptanceMark
//
//  Created by Andrea Bizzotto on 11/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import Cocoa

class CMDocumentParser: NSObject {

    class func parse(data: Data, inputFilePath: String) {
        guard let document = CMDocument(data: data, options: .sourcepos) else {
            print("Could not parse Markdown for file at path: \(inputFilePath)")
            exit(0)
        }
        
        // none, done, enter, exit
        document.rootNode.iterator().enumerate { node, eventType, _ in
            if let node = node, let value = node.stringValue {
                
                print("\(node.headerLevel), \(node.title), \(node.humanReadableType)")
                //        let _ = node.headerLevel
                //        let _ = node.title
                //        let _ = node.type
                //        let _ = node.humanReadableType
                print("\(value)")
            }
        }
        

    }
}
