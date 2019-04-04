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
    
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var txtStationFrom: UITextField!
    
    @IBOutlet weak var txtStationTo: UITextField!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    
    public var strDate:String = "";
    
    var alarmDescription:String = "";
    
    var timeOffset:String = "";
    
    var stationFrom:String = "";
    var stationTo:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnNewAlarm(_ sender: Any) {
        

        
        if(getSettings()) {
            let db = Firestore.firestore()
            
            
            
            
            let dict : [String : Any] = ["time" : strDate,
                                         "description" : alarmDescription,
                                         "timeOffset" : timeOffset,
                                         "stationFrom" : stationFrom,
                                         "stationTo" : stationTo
            ];
            
            db.collection("alarms").addDocument(data: dict)
            
            self.performSegue(withIdentifier: "ToAlarmsVC", sender: nil)
        }else {
            print("Fill in all the fields")
        }

    }

    
    @IBAction func dpSelectTime(_ sender: Any) {
        
        let dateToStringConverter = DateFormatter()
        dateToStringConverter.dateFormat = "HH:mm";
        
        strDate = dateToStringConverter.string(from: dpSelectedTime.date);
        // do what you want to do with the string.
    }
    
    
    func getSettings() -> Bool {
        // Require empty handeling
        if txtDescription.text != "" {
            alarmDescription = txtDescription.text!;
            
            timeOffset = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!;
            
            stationFrom = txtStationFrom.text!;
            stationTo = txtStationTo.text!;
            
            
        }
        
        else {
            return false;
        }
        return true;
    }
}
