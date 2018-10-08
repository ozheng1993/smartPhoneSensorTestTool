//
//  ViewController.swift
//  sensor
//
//  Created by ou zheng on 10/1/18.
//  Copyright © 2018 ou zheng. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData
import CoreLocation
var accDatas: [String] = []
var startToSave = false
var frequency=1.0
let motionManager = CMMotionManager()
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: context)
let newSensor = NSManagedObject(entity: entity!, insertInto: context)
var manager:CLLocationManager = CLLocationManager()
class ViewController: UIViewController ,UITextFieldDelegate,CLLocationManagerDelegate{
    let motion = CMMotionManager()
    var timer: Timer!
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    @IBOutlet weak var walkDispaly: UILabel!
    @IBOutlet weak var condifentDisplay: UILabel!
    @IBOutlet weak var infoDispaly: UILabel!
    @IBOutlet weak var freInput: UITextField!
    @IBOutlet weak var exportDisplay: UILabel!
    @IBOutlet weak var countDisplay: UILabel!
    @IBOutlet weak var saveDisplay: UILabel!
    @IBOutlet weak var displayDataX: UILabel!
    @IBOutlet weak var displayDataY: UILabel!
    @IBOutlet weak var displayDataZ: UILabel!
    @IBOutlet weak var fileName: UITextField!
    @IBOutlet weak var diaplyFileName: UILabel!
    
    
    @IBOutlet weak var displayGyroDataX: UILabel!
    @IBOutlet weak var displayGyroDataY: UILabel!
    @IBOutlet weak var displayGyroDataZ: UILabel!
    
    @IBOutlet weak var displayMagnetDataX: UILabel!
    @IBOutlet weak var displayMagnetDataY: UILabel!
    @IBOutlet weak var displayMagnetDataZ: UILabel!
    
    
    @IBOutlet weak var displayGpsDataLon: UILabel!
    @IBOutlet weak var displayGpsDataLan: UILabel!
    @IBOutlet weak var displayGpsDataSpeed: UILabel!
    @IBOutlet weak var displayGpsDataHeading: UILabel!
    @IBOutlet weak var displayGpsDataError: UILabel!
    
    
    @IBAction func getFileName(_ sender: Any) {
        diaplyFileName.text=fileName.text
        
        
    }
    @IBAction func stopReocrd(_ sender: Any) {
        infoDispaly.text="stop access acc data"
        timer.invalidate()
        timer = nil//      freInput.text=String(1000.0)
        motionManager.stopAccelerometerUpdates()
    }
    
    @IBAction func updateFreButton(_ sender: Any) {
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        infoDispaly.text=self.fileName.text!+" / "+freInput.text!+"sec"
        var text: String = freInput.text!
        frequency=Double(text)!
        print(frequency)
        timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    @IBAction func saveDataButton(_ sender: Any) {
         startToSave = true
            saveDisplay.text=String(startToSave)
  

       
    }
    
    @IBAction func exportButton(_ sender: Any) {
        
        if accDatas.count>0
        {
            let fileNameString=self.fileName.text
            let fileName = fileNameString!+".csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            var csvText = "Date,x,y,z,mode\n"
            for task in accDatas {
                let newLine = task
                csvText.append(newLine)
            }
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                self.exportDisplay.text="export to : "+fileName
                let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToTwitter,
                    UIActivity.ActivityType.postToFacebook,
                    UIActivity.ActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)

            } catch {
                print("Failed to create file")
                print("\(error)")
                self.exportDisplay.text="\(error)"
            }

            print(accDatas)
            
            
        }
        else
        {
            print("error exproting")
        }
        
    }
    @IBAction func stopButton(_ sender: Any) {
        startToSave = false
        saveDisplay.text=String(startToSave)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()

        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .restricted,.denied,.notDetermined:
            // report error, do something
            print("error")
        default:
            // location si allowed, start monitoring
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        // do something with the error
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last {
//            if locationObj.horizontalAccuracy < minAllowedAccuracy {
//                manager.stopUpdatingLocation()
//                // report location somewhere else
//            }
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
        
    }
    
    @objc func update() {
        
        var activityMode=0
        if(CMMotionActivityManager.isActivityAvailable())
        {
            //print("available")
                activityManager.startActivityUpdates(to: OperationQueue.main) {
                    [weak self] (activity: CMMotionActivity?) in
 
                }
            
            }
        
        //acc dat
        let accRawDataX = motionManager.accelerometerData!.acceleration.x
        let accRawDataY = motionManager.accelerometerData!.acceleration.y
        let accRawDataZ = motionManager.accelerometerData!.acceleration.z
        //gyro
        let gyroRawDataX = motionManager.gyroData!.rotationRate.x
        let gyroRawDataY = motionManager.gyroData!.rotationRate.y
        let gyroRawDataZ = motionManager.gyroData!.rotationRate.z
        //magnet
        let magnetRawDataX = motionManager.magnetometerData!.magneticField.x
        let magnetRawDataY = motionManager.magnetometerData!.magneticField.y
        let magnetRawDataZ = motionManager.magnetometerData!.magneticField.z
        //time
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)

        let gpsRawDataLon = manager.location?.coordinate.longitude
        let gpsRawDataLan = manager.location?.coordinate.latitude
        let gpsRawDataCourse = manager.location?.course
        let gpsRawDataError = manager.location?.horizontalAccuracy
        let gpsRawDataSpeed = manager.location?.speed.description
//
//        func startReceivingLocationChanges() {
//            let authorizationStatus = CLLocationManager.authorizationStatus()
//            if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
//                // User has not authorized access to location information.
//                return
//            }
//            // Do not start services that aren't available.
//            if !CLLocationManager.locationServicesEnabled() {
//                // Location services is not available.
//                return
//            }
//            // Configure and start the service.
//            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//            locationManager.distanceFilter = 100.0  // In meters.
//            locationManager.delegate = self as! CLLocationManagerDelegate
//            locationManager.startUpdatingLocation()
//
//            print(locationManager.delegate)
//        }
        
            displayDataX.text="x: "+String(accRawDataX)
            displayDataY.text="y: "+String(accRawDataY)
            displayDataZ.text="z: "+String(accRawDataZ)
        
            displayGyroDataX.text="x: "+String(gyroRawDataX)
            displayGyroDataY.text="y: "+String(gyroRawDataY)
            displayGyroDataZ.text="z: "+String(gyroRawDataZ)
     
            displayMagnetDataX.text="x: "+String(magnetRawDataX)
            displayMagnetDataY.text="y: "+String(magnetRawDataY)
            displayMagnetDataZ.text="z: "+String(magnetRawDataZ)
        
      
            displayGpsDataLon.text="lon: "+String(gpsRawDataLon!)
            displayGpsDataLan.text="lan: "+String(gpsRawDataLan!)
            displayGpsDataSpeed.text="speed: "+String(gpsRawDataSpeed!)
            displayGpsDataHeading.text="speed: "+String(gpsRawDataCourse!)
            displayGpsDataError.text="speed: "+String(gpsRawDataError!)
        
        
        
        
            activityManager.startActivityUpdates(to: OperationQueue.main) {
                [weak self] (activity: CMMotionActivity?) in
            if activity!.walking  {
                //                        self!.condifentDisplay.text=deatil
                self?.walkDispaly.text = "Walking"
                activityMode=1
                
                
            } else if activity!.stationary {
                self?.walkDispaly.text = "Stationary"
                activityMode=2
            } else if activity!.running {
                self?.walkDispaly.text = "Running"
                activityMode=3
            } else if activity!.automotive {
                self?.walkDispaly.text = "Automotive"
                activityMode=4
            }
            else if activity!.cycling {
                self?.walkDispaly.text = "Cycling"
                activityMode=5
            }
                else
            {
                self?.walkDispaly.text = "undifine"
                activityMode=6
                }
            }
            
            let accData=String(dateString)+","+String(accRawDataX)+","+String(accRawDataY)+","+String(accRawDataZ)+","+String(activityMode)+"\n"
            //print(accData)
            
            
            if startToSave
            {
                accDatas.append(accData)
                countDisplay.text="saved : "+String(accDatas.count);
                let defaults = UserDefaults.standard
                
                // Store
                defaults.set(accData, forKey: "username")
                
                // Receive
                if let name = defaults.string(forKey: "username") {
                    print(name)
                    // Will output "theGreatestName"
                }
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                // 1
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                // 2
                let entity =
                    NSEntityDescription.entity(forEntityName: "Sensor",
                                               in: managedContext)!
                
                let sensor = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
                
                // 3
                sensor.setValue(accData, forKeyPath: "data")
                
                // 4
                do {
                    try managedContext.save()
                    //                people.append(person)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
            
          
          
    
            
        }


   
}
