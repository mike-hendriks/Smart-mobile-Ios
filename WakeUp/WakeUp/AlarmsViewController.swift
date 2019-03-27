//
//  FirstViewController.swift
//  WakeUp
//
//  Created by Dylano on 21/03/2019.
//  Copyright © 2019 Dylano. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var lblCurrentTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getCurrentDateTime();
    }
    
    func getCurrentDateTime() {
        let formatter = DateFormatter()
//        formatter.dateStyle = .long;
        formatter.timeStyle = .short;
        let string = formatter.string(from: Date());
        lblCurrentTime.text = string;
    }


}

