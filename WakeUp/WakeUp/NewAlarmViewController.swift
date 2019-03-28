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
    
    
    
    
    public var strDate:String = "";
    
    var alarmDescription:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnNewAlarm(_ sender: Any) {
        
        let db = Firestore.firestore()
 
        

        
        let dict : [String : Any] = ["time" : strDate,
                                     "description" : alarmDescription];
        
        db.collection("alarms").addDocument(data: dict)
        
        if(getSettings()) {
            self.performSegue(withIdentifier: "ToAlarmsVC", sender: nil)
        }else {
            print("Fill in all the fields")
        }

    }

    
    @IBAction func dpSelectTime(_ sender: Any) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm";
        
        strDate = timeFormatter.string(from: dpSelectedTime.date);
        // do what you want to do with the string.
    }
    
    
    func getSettings() -> Bool {
        // Require empty handeling
        if txtDescription.text != "" {
            alarmDescription = txtDescription.text!;
            
            
        }
        
        else {
            return false;
        }
        return true;
    }
}
