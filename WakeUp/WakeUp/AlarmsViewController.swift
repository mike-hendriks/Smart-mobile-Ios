//
//  FirstViewController.swift
//  WakeUp
//
//  Created by Dylano on 21/03/2019.
//  Copyright © 2019 Dylano. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AlarmsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var lblAlarm1: UILabel!
    
    @IBOutlet weak var lblCurrentDateTime: UILabel!
    
    var alarm: String = "";
    
    var alarmArray : [String] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCurrentDateTime();
        getAlarmsFromDB();

    }
    
    func getAlarmsFromDB() {
        let db = Firestore.firestore();
        db.collection("alarms").getDocuments{(snapshot, error) in
            if error != nil {
                print(error!)
            }
            else {
                for document in (snapshot?.documents)! {
                    if let time = document.data()["time"] as? String {
                        //                        self.lblAlarm1.text = time;
                        self.alarmArray.append(time);
                        print(self.alarmArray)
                        
                        
                    }
                }
            }
        }
        
        
        print(alarmArray)
    }
    
    
    func getCurrentDateTime() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long;
        formatter.timeStyle = .short;
        let dateTime: String = formatter.string(from: Date());
        
        lblCurrentDateTime.text = dateTime;
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alarmArray.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.lblCollectionItem.text = alarmArray[indexPath.item];
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.item)
    }
    

}

