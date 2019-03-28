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

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var titleCurrentDateTime: UINavigationItem!
    
    
    
    var arrTime : [String] = [];
    
    var arrDescription : [String] = [];
    
    
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
                    if let description = document.data()["description"] as? String {
                        self.arrDescription.append(description);
                        
                        if let time = document.data()["time"] as? String  {
                            self.arrTime.append(time);


                            //                        print(self.arrTime)
                            self.collectionView.reloadData()
                        }
                       
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
        
        titleCurrentDateTime.title = dateTime;
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTime.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
//        cell.lblAlarmDescription.text
        
        cell.lblAlarmTime.text = arrTime[indexPath.item];
        
        cell.lblAlarmDescription.text = arrDescription[indexPath.item];
        
        
        
        
//        print (arrTime[indexPath.item]);
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.item)
    }
    

}

