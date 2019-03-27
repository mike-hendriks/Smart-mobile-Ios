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
    
    
    
    
    
    public var strDate:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier ==  "toAlarmViewController"){
//            let alarmViewController = segue.destination as!
//            AlarmsViewController;
//
//            alarmViewController.alarm = "sad";
//
//
//
//        }
//    }
    

    @IBAction func btnAddAlarm(_ sender: Any) {

        let db = Firestore.firestore()
        lblSelectedTime.text = strDate;
        
        let dict : [String : Any] = ["time" : strDate];
        
        db.collection("alarms").addDocument(data: dict)

        //alarmsVC.alarm = strDate;

    }
    
    @IBAction func dpSelectTime(_ sender: Any) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        strDate = timeFormatter.string(from: dpSelectedTime.date);
        // do what you want to do with the string.
    }
}
