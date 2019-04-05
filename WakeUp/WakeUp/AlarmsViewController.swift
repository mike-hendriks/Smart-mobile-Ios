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
    
    var currentTime : String = "";
    
    var timer = Timer();
    
    var convertedDate:Date?;
    
    var audioPlayer : AVAudioPlayer?;
    
    var arrTime : [String] = [];
    
    var arrDescription : [String] = [];
    
    var arrStationFrom : [String] = [];
    
    var arrStationTo : [String] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        getCurrentDateTime();
        scheduledTimerWithTimeInterval();
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
                            
                            if let offset = document.data()["timeOffset"] as? String {
                                self.convertTime(time: time)
                                if offset == "-30 min" {
//                                    checkDisruption();
                                }
                                
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
        
        print("timer called!")
        
        CheckIfCurrentTimeIsInArray();
        
    }
    
    func CheckIfCurrentTimeIsInArray() {
        for time in arrTime {
            if currentTime == time {
                print("je moeder")
                playSound();
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
    
    func convertTime(time:String) {
        let stringToDateConverter = DateFormatter();
        stringToDateConverter.dateFormat = "HH:mm";
        convertedDate = stringToDateConverter.date(from: time);
        print(convertedDate);
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
    
    
    func checkJourney(stationFrom:String, stationTo:String) -> String{
        var status:String = "";
        Ns.route(parameters: "fromStation=" + stationFrom + "&toStation=" + stationTo) { (results:[Ns]) in
            
            status = results[0].status
            
        }
        
        return status
    }
    

}

