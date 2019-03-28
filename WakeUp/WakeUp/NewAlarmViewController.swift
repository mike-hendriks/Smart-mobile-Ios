//
//  NewAlarmViewController.swift
//  WakeUp
//
//  Created by Dylano on 22/03/2019.
//  Copyright © 2019 Dylano. All rights reserved.
//

import UIKit
import FirebaseFirestore


class NewAlarmViewController: UIViewController {
    
    
    
    @IBOutlet weak var dpSelectedTime: UIDatePicker!
    
    @IBOutlet weak var lblSelectedTime: UILabel!
    
    @IBOutlet weak var txtDescription: UITextField!
    
    
    
    
    public var strDate:String = "";
    
    var alarmDescription:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnNewAlarm(_ sender: Any) {
        
        let db = Firestore.firestore()
        lblSelectedTime.text = strDate;
        
        getSettings();
        
        let dict : [String : Any] = ["time" : strDate,              "description" : alarmDescription];
        
        db.collection("alarms").addDocument(data: dict)
        
        self.performSegue(withIdentifier: "ToAlarmsVC", sender: nil)
        //alarmsVC.alarm = strDate;
    }

    
    @IBAction func dpSelectTime(_ sender: Any) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        strDate = timeFormatter.string(from: dpSelectedTime.date);
        // do what you want to do with the string.
    }
    
    
    func getSettings() {
        // Require empty handeling
        alarmDescription = txtDescription.text!;
    }
}
