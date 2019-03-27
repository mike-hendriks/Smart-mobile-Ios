//
//  FirstViewController.swift
//  WakeUp
//
//  Created by Dylano on 21/03/2019.
//  Copyright © 2019 Dylano. All rights reserved.
//

import UIKit

class AlarmsViewController: UIViewController {

    
    @IBOutlet weak var lblAlarm1: UILabel!
    
    @IBOutlet weak var lblCurrentDateTime: UILabel!
    
    var alarm: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCurrentDateTime();
        
//            lblAlarm1.text = alarm;
        
    }
    
    
    func getCurrentDateTime() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long;
        formatter.timeStyle = .short;
        let dateTime: String = formatter.string(from: Date());
        
        lblCurrentDateTime.text = dateTime;
        
        
    }

    
    

}

