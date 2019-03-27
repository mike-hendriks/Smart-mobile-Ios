//
//  FirstViewController.swift
//  WakeUp
//
//  Created by Dylano on 21/03/2019.
//  Copyright © 2019 Dylano. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AlarmsViewController: UIViewController {

    
    @IBOutlet weak var lblAlarm1: UILabel!
    
    @IBOutlet weak var lblCurrentDateTime: UILabel!
    
    var alarm: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCurrentDateTime();
        
        let db = Firestore.firestore();
        db.collection("alarms").getDocuments{(snapshot, error) in
            if error != nil {
                print(error!)
            }
            else {
                for document in (snapshot?.documents)! {
                    if let time = document.data()["time"] as? String {
//                        self.lblAlarm1.text = time;
                        print(time);
                    }
                }
            }
        }
    }
    
    
    func getCurrentDateTime() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long;
        formatter.timeStyle = .short;
        let dateTime: String = formatter.string(from: Date());
        
        lblCurrentDateTime.text = dateTime;
        
        
    }

    
    

}

