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
var finalData=""
let motionManager = CMMotionManager()
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: context)
let newSensor = NSManagedObject(entity: entity!, insertInto: context)
var manager:CLLocationManager = CLLocationManager()
class ViewController: UIViewController ,UITextFieldDelegate,CLLocationManagerDelegate{
    let motion = CMMotionManager()
    let altimeter = CMAltimeter()
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
    
    
    
    @IBOutlet weak var displayUserStatus: UILabel!
    
    @IBOutlet weak var displayAccStatus: UILabel!
    
    @IBOutlet weak var displayGyroStatus: UILabel!
    
    @IBOutlet weak var displayMagnetStatus: UILabel!
    
    @IBOutlet weak var displayGpsStatus: UILabel!
    
    @IBOutlet weak var displayBaroStatus: UILabel!
    
    
    
    
    
    @IBOutlet weak var displayAirpressure: UILabel!
    
    
    
    
    @IBOutlet weak var displayAltitude: UILabel!
    
    
    
    
//    @IBAction func getFileName(_ sender: Any) {
//        diaplyFileName.text=fileName.text
//
//
//    }
    @IBAction func stopReocrd(_ sender: Any) {
        //infoDispaly.text="stop access acc data"
        timer.invalidate()
        timer = nil//      freInput.text=String(1000.0)
        motionManager.stopAccelerometerUpdates()
    }
    
    @IBAction func updateFreButton(_ sender: Any) {
        
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
      
        //infoDispaly.text=self.fileName.text!+" / "+freInput.text!+"sec"
        var text: String = freInput.text!
        frequency=Double(text)!
        print(frequency)
        manager.startUpdatingLocation()
        print(manager.location)
        timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    @IBAction func saveDataButton(_ sender: Any) {
         startToSave = true
        saveDisplay.text="saving..."
 
    }
    
    @IBAction func exportButton(_ sender: Any) {
        
        if accDatas.count>0
        {
            let fileNameString=self.fileName.text
            let fileName = fileNameString!+".csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            var csvText = "Date,accx,accy,accz,gyrox,gryoy,gyroz,magnetx,magnety,magnetz,lon,lan,speed,course,error,air pressure,altitude,mode\n"
            for task in accDatas {
                let newLine = task
                csvText.append(newLine)
            }
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                //self.exportDisplay.text="exported to : "+fileName
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
        saveDisplay.text="stop saving"
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
        
    }
    
    
//    func getAirPressure(pressure: Double, alt: Double) -> Double {
//
//
//        if CMAltimeter.isRelativeAltitudeAvailable() {
//            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
//                if (error == nil) {
//
//                    pressure+=Double(data!.pressure)
//                    return pressure
//                }
//            })
//
//
//
//        return
//    }
//
    
    
    
//
//    func getAirPressure()-> Double{
//
////        var airpressure=0.0
////        var altitude=0.0
//        if CMAltimeter.isRelativeAltitudeAvailable() {
//            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
//                if (error == nil) {
////                    //                    var pressure=data?.pressure
////                    //                    var altitude=data?.relativeAltitude
////                    self.displayAirpressure.text="ais pressure: \(data!.pressure)"
//////                    self.displayAltitude.text="altitude: \(data!.relativeAltitude)"
////                    airpressure=Double(data!.pressure)
//
//
//                    return data!.pressure
//                }
//            })
////            //
////            //            print("dat2"+String(\(airPressureRawData)))
////            //            print("dat2"+String(\(altitudeRawData)))
////            displayBaroStatus.text="Avaiable"
////            displayBaroStatus.textColor = UIColor.green
////            print("true")
////        }
//
//    }
    
    @objc func update() {
        
        
        
         let airPressure = motionManager.accelerometerData!.acceleration.x
        
        
        
//
//        let airPressure = CMAltitudeData
//        print(airPressure)
//
//        var airPressureRawData:Double!
//        var altitudeRawData:Double!
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                if (error == nil) {
//                   airPressureRawData=0.0
//                    altitudeRawData=0.0
                    self.displayAirpressure.text="\(data!.pressure)"
                    self.displayAltitude.text="\(data!.relativeAltitude)"
//                    airPressureRawData=Double("\(data!.pressure)")!
//                    altitudeRawData=Double("\(data!.relativeAltitude)")!
//                    print("dat"+String(airPressureRawData!))
//                    print("dat"+String(altitudeRawData!))

                }
            })

            displayBaroStatus.text="Avaiable"
            displayBaroStatus.textColor = UIColor.green
            print("true")
        }
        else
        {
            displayBaroStatus.text="UnAvaiable"
            displayBaroStatus.textColor = UIColor.red
             print("false")
        }
        let airPressureRawData: String = self.displayAirpressure.text!
        let altitudeRawData: String = self.displayAltitude.text!
//        let test=airPressureRawData!
//         let test2=altitudeRawData!
        print(airPressureRawData)
        print(altitudeRawData)
        if(CMMotionActivityManager.isActivityAvailable())
        {
            //print("available")
            displayUserStatus.text="Avaliable"
            displayUserStatus.textColor = UIColor.green
                activityManager.startActivityUpdates(to: OperationQueue.main) {
                    [weak self] (activity: CMMotionActivity?) in
 
                }
            
            }
        else
        {
            displayUserStatus.text="Unavaliable"
            displayUserStatus.textColor = UIColor.red
            
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

//        var airPressureRawData=self.displayAirpressure.text
//        var altitudeRawData=self.displayAltitude.text
        print(airPressureRawData)
        print(altitudeRawData)
//
        if (manager.location != nil)
        {
            displayGpsStatus.text="Avaliable"
            displayGpsStatus.textColor = UIColor.green
            displayGpsDataLon.text="lon: "+String(gpsRawDataLon!)
            displayGpsDataLan.text="lat: "+String(gpsRawDataLan!)
            displayGpsDataSpeed.text="speed: "+String(gpsRawDataSpeed!)
            displayGpsDataHeading.text="course: "+String(gpsRawDataCourse!)
            displayGpsDataError.text="error: "+String(gpsRawDataError!)
        }
        else
        {
            displayGpsStatus.text="Unvaliable"
            displayGpsStatus.textColor = UIColor.red
            displayGpsDataLon.text="lon: nil"
            displayGpsDataLan.text="lat: nil"
            displayGpsDataSpeed.text="speed: nil"
            displayGpsDataHeading.text="course: nil"
            displayGpsDataError.text="error: nil"
        }

        
        
        
        
        if motionManager.isAccelerometerActive
        {
            displayAccStatus.text="Avaliable"
            displayAccStatus.textColor = UIColor.green
            displayDataX.text="x: "+String(accRawDataX)
            displayDataY.text="y: "+String(accRawDataY)
            displayDataZ.text="z: "+String(accRawDataZ)
        }
        else
        {
            displayAccStatus.text="Unvaliable"
            displayAccStatus.textColor = UIColor.red
            displayDataX.text="x: nil "
            displayDataY.text="y: nil "
            displayDataZ.text="z: nil "
        }
        
        if motionManager.isGyroActive
        {
            displayGyroStatus.text="Avaliable"
            displayGyroStatus.textColor = UIColor.green
            displayGyroDataX.text="x: "+String(gyroRawDataX)
            displayGyroDataY.text="y: "+String(gyroRawDataY)
            displayGyroDataZ.text="z: "+String(gyroRawDataZ)
        }
        else
        {
            displayGyroStatus.text="Unvaliable"
            displayGyroStatus.textColor = UIColor.red
            displayGyroDataX.text="x: nil "
            displayGyroDataY.text="y: nil"
            displayGyroDataZ.text="z: nil"
        }
        
        if motionManager.isMagnetometerActive
        {
            displayMagnetStatus.text="Avaliable"
            displayMagnetStatus.textColor = UIColor.green
            displayMagnetDataX.text="x: "+String(magnetRawDataX)
            displayMagnetDataY.text="y: "+String(magnetRawDataY)
            displayMagnetDataZ.text="z: "+String(magnetRawDataZ)
        }
        else
        {
            displayMagnetStatus.text="Unvaliable"
            displayMagnetStatus.textColor = UIColor.red
            displayMagnetDataX.text="x: nil "
            displayMagnetDataY.text="y: nil"
            displayMagnetDataZ.text="z: nil"
        }
        
        
        
        
        
        
        
        
//
//            displayDataX.text="x: "+String(accRawDataX)
//            displayDataY.text="y: "+String(accRawDataY)
//            displayDataZ.text="z: "+String(accRawDataZ)
        
        
        
        
        
        
        
//            displayGyroDataX.text="x: "+String(gyroRawDataX)
//            displayGyroDataY.text="y: "+String(gyroRawDataY)
//            displayGyroDataZ.text="z: "+String(gyroRawDataZ)
     
//            displayMagnetDataX.text="x: "+String(magnetRawDataX)
//            displayMagnetDataY.text="y: "+String(magnetRawDataY)
//            displayMagnetDataZ.text="z: "+String(magnetRawDataZ)
//
        //gps
            displayGpsDataLon.text="lon: "+String(gpsRawDataLon!)
            displayGpsDataLan.text="lat: "+String(gpsRawDataLan!)
            displayGpsDataSpeed.text="speed: "+String(gpsRawDataSpeed!)
            displayGpsDataHeading.text="course: "+String(gpsRawDataCourse!)
            displayGpsDataError.text="error: "+String(gpsRawDataError!)


        
           let Data=String(dateString)+","+String(accRawDataX)+","+String(accRawDataY)+","+String(accRawDataZ)+","+String(gyroRawDataX)+","+String(gyroRawDataY)+","+String(gyroRawDataZ)+","+String(magnetRawDataX)+","+String(magnetRawDataY)+","+String(magnetRawDataZ)+","+String(gpsRawDataLon!)+","+String(gpsRawDataLan!)+","+String(gpsRawDataSpeed!)+","+String(gpsRawDataCourse!)+","+String(gpsRawDataError!)+","+String(airPressureRawData)+","+String(altitudeRawData)

        
            activityManager.startActivityUpdates(to: OperationQueue.main) {
                [weak self] (activity: CMMotionActivity?) in
            if activity!.walking  {
                //                        self!.condifentDisplay.text=deatil
                self?.walkDispaly.text = "Walking"
                
                finalData=Data+",walking"+"\n"
                
                
            } else if activity!.stationary {
                self?.walkDispaly.text = "Stationary"
                
                finalData=Data+",strationary"+"\n"
            } else if activity!.running {
                self?.walkDispaly.text = "Running"
                
                finalData=Data+",running"+"\n"
            } else if activity!.automotive {
                self?.walkDispaly.text = "Automotive"
               
                finalData=Data+",automotive"+"\n"
            }
            else if activity!.cycling {
                self?.walkDispaly.text = "Cycling"
               
                finalData=Data+",cycling"+"\n"
            }
                else
            {
                self?.walkDispaly.text = "undefined"
                
                finalData=Data+",undefined"+"\n"
                }
            }
     
//            let accData=String(dateString)+","+String(accRawDataX)+","+String(accRawDataY)+","+String(accRawDataZ)+","+String(activityMode)
//
//            let accGyroData=accData+","+String(gyroRawDataX)+","+String(gyroRawDataY)+","+String(gyroRawDataZ)
//
//            let accGyroMagnetData=accGyroData+","+String(magnetRawDataX)+","+String(magnetRawDataY)+","+String(magnetRawDataZ)
//            let accGyroMagnetGpsData=accGyroMagnetData+","+String(gpsRawDataLon)+","+String(gpsRawDataLan)+","+String(gpsRawDataSpeed+","+String(gpsRawDataCourse)+","+String(gpsRawDataError)+"\n"
//
           // print(finalData)
            
            
            if startToSave
            {
                accDatas.append(finalData)
                countDisplay.text="saved : "+String(accDatas.count);
                let defaults = UserDefaults.standard

                // Store
                defaults.set(Data, forKey: "username")

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
                sensor.setValue(Data, forKeyPath: "data")

                 //4
                do {
                    try managedContext.save()
                    //                people.append(person)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
            
          
          
    
            
        }


   
}
