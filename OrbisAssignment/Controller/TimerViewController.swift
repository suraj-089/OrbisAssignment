//
//  TimerViewController.swift
//  OrbisAssignment
//
//  Created by Suraj on 4/5/20.
//  Copyright © 2020 Mobikasa. All rights reserved.
//

import UIKit



class TimerViewController: UIViewController,SetViewControllerIntials {
    
    static var controllerIdentifier: String = Identifiers.timerViewController
    
    //MARK:- Variables
    fileprivate var timer = Timer()
    fileprivate var hrs = 0
    fileprivate var min = 0
    fileprivate var sec = 0
    fileprivate var milliSecs = 0
    fileprivate var diffHrs = 0
    fileprivate var diffMins = 0
    fileprivate var diffSecs = 0
    fileprivate var diffMilliSecs = 0
    fileprivate var otp:String = ""
    fileprivate var hour: Int = 0
    fileprivate var minutes: Int = 0
    fileprivate var seconds: Int = 0
    fileprivate var totalTime:Int = 0
    fileprivate var totalHour:Int = 0
    fileprivate var totalMinutes:Int = 0
    fileprivate var totalSeconds:Int = 0
    fileprivate var calTime:Int = 0
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // ---- Declaring Instance of the current view controler
    static func getInstance()->TimerViewController{
        let storyboard = UIStoryboard(name:StringConstants.main, bundle:nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Identifiers.timerViewController) as! TimerViewController
        return viewController
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        fetchResultsFromApi()
    }
    
    // ----- Setting Up things here ------
    fileprivate func setInitials(){
        resetContent()
        startButton.setCustomButton(button: startButton)
        stopButton.setCustomButton(button: stopButton)
        countDownLabel.text = "\(StringConstants.countdown)\n\(hour) \(StringConstants.hours) \(minutes) \(StringConstants.minutes) \(seconds) \(StringConstants.seconds)"
        pickerView.delegate = self
        // --- Adding observer for the notification when app changes state ------
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK :- Helper Methods
    @objc func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey:StringConstants.savedTime)
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey:StringConstants.savedTime) as? Date {
            (diffHrs, diffMins, diffSecs) = TimerViewController.getTimeDifference(startDate: savedDate)
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
        }
    }
    
    // ----- Updating label from here
    @objc func updateLabels(t: Timer) {
        if(self.milliSecs > 10) {
            self.sec += 1
            calTime = calTime+1
            print("MiliSeconds \(self.sec)")
             print("Calclted timr \(calTime)")
            self.milliSecs = 0
            if (self.sec > 60) {
                self.min += self.sec/60
                self.sec = self.sec % 60
                if (self.min > 60) {
                    self.hrs += self.min/60
                    self.min = self.min % 60
                }
            }
        } else {
            self.milliSecs += 1
        }
        
        if self.sec >= totalTime{
            showSingleBtnAlertWith(title: StringConstants.alert, subTitle: "\(StringConstants.otpMessage) \(otp)", centerBtnAction: {
                self.resetContent()
                self.pickerView.isUserInteractionEnabled = true
            })
        }
        self.timerLabel.text = String(format: "%02d : %02d : %02d", self.hrs, self.min, self.sec)
    }
    
    // ----- Called when user stop the timer
    fileprivate func resetContent() {
        self.removeSavedDate()
        timer.invalidate()
        self.timerLabel.text = "00 : 00 : 00"
        self.milliSecs = 0
        self.calTime = 0
        self.sec = 0
        self.min = 0
        self.hrs = 0
    }
    
    // Time difference to set and retrive from User Defaults
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        //self.hrs += hours
        //self.min += mins
        //self.sec += secs
        var minutes = self.min
        
        if (secs >= 60) {
            minutes += mins + secs/60
            self.sec = secs % 60
        } else {
            self.sec = secs
            minutes += mins
        }
        
        if (minutes >= 60) {
            self.hrs = hours + minutes/60
            self.min = minutes % 60
        } else {
            self.min = minutes
        }
        self.timerLabel.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(TimerViewController.updateLabels(t:))), userInfo: nil, repeats: true)
        
    }
//    fileprivate func refresh (hours: Int, mins: Int, secs: Int) {
//        var minutes = self.min
//        if (secs >= 60) {
//            minutes += mins + secs/60
//            self.sec = secs % 60
//        } else {
//            self.sec = secs
//            calTime = calTime+1
//            minutes += mins
//        }
//        if (minutes >= 60) {
//            self.hrs = hours + minutes/60
//            self.min = minutes % 60
//        } else {
//            self.min = minutes
//        }
//
//        self.timerLabel.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(TimerViewController.updateLabels(t:))), userInfo: nil, repeats: true)
//    }
    
    // --- Removing from User Defaults when the user click stop button -----
    fileprivate func removeSavedDate() {
        if (UserDefaults.standard.object(forKey:StringConstants.savedTime) as? Date) != nil {
            UserDefaults.standard.removeObject(forKey:StringConstants.savedTime)
        }
    }
    
    // MARK: - IBActions
    @IBAction func startBUttonAction(_ sender: Any) {
        self.resetContent()
        totalTime = totalHour+totalMinutes+totalSeconds
        if (totalTime<300) || (totalTime>5400){
            showSingleBtnAlertWith(title:StringConstants.alert, subTitle:StringConstants.validateMessage, centerBtnAction: {
            })
        }
        else{
            self.timer = Timer.scheduledTimer(timeInterval:0.1, target: self, selector: (#selector(TimerViewController.updateLabels(t:))), userInfo: nil, repeats: true)
            pickerView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        showAlertWith(title: StringConstants.alert, subTitle: StringConstants.stopAction, leftBtnTitle:StringConstants.cancel, rightBtnTitle:StringConstants.ok, leftBtnColor: UIColor.gray, rightBtnColor: UIColor.gray, leftBtnAction: {
            self.dismiss(animated: true, completion: nil)
        }, rightBtnAction: {
            self.resetContent()
            self.calTime = 0
            self.pickerView.isUserInteractionEnabled = true
        })
    }
}

//MARK: - PickerView DataSource and Delegate Methods

extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 2:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) hr"
        case 1:
            return "\(row) min"
        case 2:
            return "\(row) sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
            countDownLabel.text = "\(StringConstants.countdown)\n\(hour) \(StringConstants.hours) \(minutes) \(StringConstants.minutes) \(seconds) \(StringConstants.seconds)"
            totalHour = hour*60*60
        case 1:
            minutes = row
            countDownLabel.text = "\(StringConstants.countdown)\n\(hour) \(StringConstants.hours) \(minutes) \(StringConstants.minutes) \(seconds) \(StringConstants.seconds)"
            totalMinutes = minutes*60
        case 2:
            seconds = row
            countDownLabel.text = "\(StringConstants.countdown)\n\(hour) \(StringConstants.hours) \(minutes) \(StringConstants.minutes) \(seconds) \(StringConstants.seconds)"
            totalSeconds = seconds
        default:
            break;
        }
    }
}

//MARK: - API Calling
extension TimerViewController{
    func fetchResultsFromApi() {
        guard let gitUrl = URL(string: StringConstants.url) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            // ---- On Success -----
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Task.self, from: data)
                print(gitData.requests[0].data[6].value )
                self.otp = gitData.requests[0].data[6].value
            }
                // ----- If fails ----
            catch let err {
                print(StringConstants.error, err)
            }
        }.resume()
    }
}
