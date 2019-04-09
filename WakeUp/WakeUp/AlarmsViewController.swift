//
//  FirstViewController.swift
//  WakeUp
//
//  Created by Dylano on 21/03/2019.
//  Copyright © 2019 Dylano. All rights reserved.
//

import UIKit
import FirebaseFirestore
import AVFoundation

class AlarmsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var titleCurrentDateTime: UINavigationItem!
    
    var currentTime : String = ""
    
    var timer = Timer()
    
    var convertedDate:Date?
    
    var audioPlayer : AVAudioPlayer?
    
    var arrTime : [String] = []
    
    var arrDescription : [String] = []
    
    let calender = Calendar.current

    var timeData : Date?
    
    var arrStationFrom : [String] = []
    
    var arrStationTo : [String] = []
    
    var arrTimesMinus30 : [String] = []
    
    var minus30Time : Date?;
    
    var is30minEarlier : Bool = false;

 
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCurrentDateTime();
        scheduledTimerWithTimeInterval();
        getAlarmsFromDB();

    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
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
                            
                            let stringToDateConverter = DateFormatter();
                            stringToDateConverter.dateFormat = "HH:mm";
                            self.timeData = stringToDateConverter.date(from: String(time))!;
                            print(self.timeData!)
                            
                            self.minus30Time = self.calender.date(byAdding: .minute, value: -30, to: self.timeData!)

                            
                            
                            if let offset = document.data()["timeOffset"] as? String {
                                
//                                if offset == "-30 min" {
//
//
//                                }
//                                if offset == "Default alarm" {
//                                    let stringToDateConverter = DateFormatter();
//                                    stringToDateConverter.dateFormat = "HH:mm";
//                                    let timeData : Date;
//                                    timeData = stringToDateConverter.date(from: String(time))!;
////                                    print(timeData); print("Default value")
//
//
//                                }
//                                if offset == "+30 min" {
//                                    let stringToDateConverter = DateFormatter();
//                                    stringToDateConverter.dateFormat = "HH:mm";
//                                    let timeData : Date;
//                                    timeData = stringToDateConverter.date(from: String(time))!;
//                                    print(timeData)
//
//                                    let add30Time = self.calender.date(byAdding: .minute, value: 30, to: timeData);
////                                    print(add30Time!); print("Time added")
//
//                                }
                                
                                if let stationFrom = document.data()["stationFrom"] as? String {
                                    self.arrStationFrom.append(stationFrom);
                                }
                                
                                if let stationTo = document.data()["stationTo"] as? String {
                                    self.arrStationFrom.append(stationTo);
                                }
                                
                                self.collectionView.reloadData()
                            }
                            
                        }
                       
                    }

                }
            }
        }
        
        
       
    }
    
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getCurrentDateTime), userInfo: nil, repeats: true)
    }
    
    
    @objc func getCurrentDateTime() {
        let currentDateToStringConverter = DateFormatter()
        currentDateToStringConverter.dateFormat = "HH:mm"
        let dateTime: String = currentDateToStringConverter.string(from: Date());
        
        
        
        currentTime = dateTime;
        
        titleCurrentDateTime.title = currentTime;
        
//        print("timer called!")
        
        CheckIfCurrentTimeIsInArray();
        
    }
    
    func CheckIfCurrentTimeIsInArray() {
//        Check if alarm should go off
        
        for time in arrTime {
            if currentTime == time {
                playSound();
                
            }
        }
        
//        Check half hour before alarm if train has a disruption
        for (index, time) in arrTimesMinus30.enumerated() {
            let stationFrom:String = arrStationFrom[index]
            let stationTo:String = arrStationTo[index]
            
            if currentTime == time {
                print(checkJourney(stationFrom: stationFrom, stationTo: stationTo))
            }
        }
    }
    
    func playSound() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        
        guard let soundURL = Bundle.main.url(forResource: "ding", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
//    func convertTime(time:String) {
//
//
//    }
    
//
//    func call30minBefore() {
//        if is30minEarlier {
//        }
//
//    }
//
    
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
    
    
    func checkJourney(stationFrom:String, stationTo:String) -> String{
        var status : String = ""
        
        Ns.route(parameters: "fromStation=" + stationFrom + "&toStation=" + stationTo) { (results:[Ns]) in
//          3th item in array to make a delay (You won't make the train within 5
            status = results[3].status
        }
        
        sleep(1)
        
        return status
    }
    

}

