//
//  ViewController.swift
//  AcceptanceMarkDemo
//
//  Created by Andrea Bizzotto on 08/08/2016.
//  Copyright © 2016 musevisions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "md")

        print("\(samplePath)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

