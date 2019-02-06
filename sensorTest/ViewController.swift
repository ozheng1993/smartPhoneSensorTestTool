//
//  ViewController.swift
//  sensor
//
//  Created by ou zheng on 10/1/18.
//  Copyright © 2018 ou zheng. All rights reserved.
//
var gpsDatas: [String] = []
import UIKit
import CoreMotion
import CoreData
import CoreLocation
var accDatas: [String] = []
var startToSave = false
//var activityActive = false
//var accActive = false
//var gyroActive = false
//var magnActive = false
//var gpsActive = false
//var baroActive = false


var frequency=1.0
var finalData=""
var userMode=""
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
    ///sensor button
    @IBOutlet weak var displayBattery: UILabel!
    @IBAction func actBtn(_ sender: Any) {
        
            if(CMMotionActivityManager.isActivityAvailable())
            {
                //print("act"+String(motionManager.isDeviceMotionActive))
                if(!motionManager.isDeviceMotionActive)
                {
                    displayUserStatus.text="Active"
                    displayUserStatus.textColor = UIColor.green
                    motionManager.startDeviceMotionUpdates()
                    (sender as AnyObject).setTitle("deactive", for: .normal)
                }
                else
                {
                    displayUserStatus.text="inactive"
                    (sender as AnyObject).setTitle("active", for: .normal)
                    displayUserStatus.textColor = UIColor.red
                    motionManager.stopDeviceMotionUpdates()
                    
                }
                
            }
            else
            {
                displayUserStatus.text="Unavaliable"
                displayUserStatus.textColor = UIColor.red
            }
            
        

    
    }
    @IBAction func accBtn(_ sender: Any) {

            if self.motion.isAccelerometerAvailable
            {
                //print("Acc"+String(self.motion.isAccelerometerActive))
                if(!motionManager.isAccelerometerActive)
                {
                    
                displayAccStatus.text="Active"
                (sender as AnyObject).setTitle("deactive", for: .normal)
                displayAccStatus.textColor = UIColor.green
                motionManager.startAccelerometerUpdates()
                }
                else
                {
                    displayAccStatus.text="inactive"
                    (sender as AnyObject).setTitle("active", for: .normal)
                    displayAccStatus.textColor = UIColor.red
                    motionManager.stopAccelerometerUpdates()
                }
            }
            else
            {
                displayAccStatus.text="Unavaliable"
                displayAccStatus.textColor = UIColor.red
                
            }

    }
    @IBAction func gyroBtn(_ sender: Any) {
        
        
        //gyroActive=true
        
        if motionManager.isGyroAvailable
        {
            if(!motionManager.isGyroActive)
            { displayGyroStatus.text="Active"
            displayGyroStatus.textColor = UIColor.green
            (sender as AnyObject).setTitle("deactive", for: .normal)
            motionManager.startGyroUpdates()
            }
            else
            {
                displayGyroStatus.text="inactive"
                displayGyroStatus.textColor = UIColor.red
                (sender as AnyObject).setTitle("active", for: .normal)
                motionManager.stopGyroUpdates()
            }
        }
        else
        {
            displayGyroStatus.text="Unvaliable"
            displayGyroStatus.textColor = UIColor.red
            
        }
        
    }
    @IBAction func magnBtn(_ sender: Any) {
        
       
        //magnActive=true
        
        if self.motion.isMagnetometerAvailable
        {
            if(!motionManager.isMagnetometerActive)
            {
                displayMagnetStatus.text="Active"
                displayMagnetStatus.textColor = UIColor.green
                motionManager.startMagnetometerUpdates()
                (sender as AnyObject).setTitle("deactive", for: .normal)
            }
            else
            {
                displayMagnetStatus.text="inactive"
                displayMagnetStatus.textColor = UIColor.red
                motionManager.stopMagnetometerUpdates()
                (sender as AnyObject).setTitle("active", for: .normal)
            }
            
            
        }
        else
        {
            displayMagnetStatus.text="Unvaliable"
            displayMagnetStatus.textColor = UIColor.red
            
        }
    }
    
    @IBAction func gpsBtn(_ sender: Any) {
       
        
       // gpsActive=true
        
        if CLLocationManager.locationServicesEnabled()
        {
            
            if(displayGpsStatus.text=="inactive")
            {  displayGpsStatus.text="Active"
                displayGpsStatus.textColor = UIColor.green
                manager.startUpdatingLocation()
                 (sender as AnyObject).setTitle("deactive", for: .normal)
            }
            else
            {
                displayGpsStatus.text="inactive"
                displayGpsStatus.textColor = UIColor.red
                manager.stopUpdatingLocation()
                 (sender as AnyObject).setTitle("active", for: .normal)
            }
          
            
        }
        else
        {
            displayGpsStatus.text="Unvaliable"
            displayGpsStatus.textColor = UIColor.red
        }
    }
    @IBAction func baroBtn(_ sender: Any) {
        
        
        //baroActive=true
        if CMAltimeter.isRelativeAltitudeAvailable(){
            
            if(self.displayBaroStatus.text=="inactive")
            {
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.current!, withHandler: { data, error in
                    if !(error != nil) {
                        
                        self.displayBaroStatus.text="Active"
                        self.displayBaroStatus.textColor = UIColor.green
                        (sender as AnyObject).setTitle("deactive", for: .normal)
                    }
                    else{
                        self.displayBaroStatus.text="error"
                        self.displayBaroStatus.textColor = UIColor.red
                        (sender as AnyObject).setTitle("active", for: .normal)
                        
                    }
                })
            }
            else
            {
               altimeter.stopRelativeAltitudeUpdates()
                self.displayBaroStatus.text="inactive"
                self.displayBaroStatus.textColor = UIColor.red
                (sender as AnyObject).setTitle("active", for: .normal)
            }
        }
        else
        {
            displayBaroStatus.text="UnAvaiable"
            displayBaroStatus.textColor = UIColor.red
        }
    }
    ///
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
    @IBAction func stopReocrd(_ sender: Any) {
        if(timer==nil)
        {
            print("stop")
        }
        else{
            altimeter.stopRelativeAltitudeUpdates()
            manager.stopUpdatingLocation()
            //infoDispaly.text="stop access acc data"
            timer.invalidate()
            timer = nil//      freInput.text=String(1000.0)
            //motionManager.stopAccelerometerUpdates()
        }
        
    }
    @IBAction func changeColorButton(_ sender: Any) {
        self.view.backgroundColor = UIColor.white
    }
    @IBAction func changeColorButtonNight(_ sender: Any) {
        self.view.backgroundColor = UIColor.black
    }
    
    @IBAction func updateFreButton(_ sender: Any) {
        
        manager.startUpdatingLocation()
        //infoDispaly.text=self.fileName.text!+" / "+freInput.text!+"sec"
        var text: String = freInput.text!
        frequency=Double(text)!
        timer = Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    @IBAction func saveDataButton(_ sender: Any) {
        startToSave = true
        saveDisplay.text="saving..."
    }
    @IBAction func exportButton(_ sender: Any) {
        startToSave = false
        if accDatas.count>0
        {
            let fileNameString=self.fileName.text
            let fileName = fileNameString!+".csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            var csvText = "Date,accx,accy,accz,gyrox,gryoy,gyroz,magnetx,magnety,magnetz,lon,lan,speed,course,error,air pressure,altitude,batteryLevel,mode\n"
            print(accDatas)
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
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 1.0  // In meters.
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        UIDevice.current.isBatteryMonitoringEnabled = true
        requestTokenCall()
        //manager.allowsBackgroundLocationUpdates
//        print("//////////////////////////////////////////////////////")
////        print("userActive")
////        print(self.motion.isDeviceMotionActive)
//        print("acc")
//        print(motionManager.isAccelerometerActive)
//        print("gyro")
//        print(self.motion.isGyroActive)
//        print("magn")
//        print(self.motion.isMagnetometerActive)
//        print("location")
//        print(CLLocationManager.locationServicesEnabled())
//        print("background location")
//        print(manager.allowsBackgroundLocationUpdates)
//        print("baro")
//        print(CMAltimeter.isRelativeAltitudeAvailable())

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    func requestTokenCall() {
        let url = NSURL(string: "http://157.230.178.76/auth")
        var request = URLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        let dictionary = ["username": "hongbojing", "password": "asdf"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error)                                 // some fundamental network error
                return
            }
            
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                //print(responseObject)
                for item in responseObject {
                    print(item.value)
                }
                
            } catch let jsonError {
                print(jsonError)
                print(String(data: data, encoding: .utf8))   // often the `data` contains informative description of the nature of the error, so let's look at that, too
            }
        }
        task.resume()
    }
    
    
    
    func makePostCall(date:String,
                      accx:String,accy:String,accz:String,
                      gyrox:String,gyroy:String,gyroz:String,
                      magnx:String,magny:String,magnz:String,
                    gpslon:String,gpslan:String,gpsspeed:String,gpscourse:String,
            gpserror:String,airpre:String,alti:String,battry:String,mode:String
        ) {
        print("///////////////")
        print(date)
        print("-----acc-------")
        print(accx)
        print(accy)
        print(accz)
        print("-----gyro-------")
        print(gyrox)
        print(gyroy)
        print(gyroz)
         print("-----magn-------")
        print(magnx)
        print(magny)
        print(magnz)
         print("-----gps-------")
        print(gpslon)
        print(gpslan)
        print(gpsspeed)
        print(gpscourse)
        print(gpserror)
         print("-----baro-------")
        print(airpre)
        print(alti)
         print("-----battry-------")
        print(battry)
        print(mode)
        print("///////////////")

//        let url = NSURL(string: "http://157.230.178.76/item/item_name")
//        var request = URLRequest(url: url! as URL)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
//        //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
//        request.httpMethod = "POST"
//
//        let dictionary = ["username": "hongbojing", "password": "asdf"]
//        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error)                                 // some fundamental network error
//                return
//            }
//
//            do {
//                let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//                //print(responseObject)
//                for item in responseObject {
//                    print(item.value)
//                }
//
//            } catch let jsonError {
//                print(jsonError)
//                print(String(data: data, encoding: .utf8))   // often the `data` contains informative description of the nature of the error, so let's look at that, too
//            }
//        }
//        task.resume()
    }
    
    
    
    
    
    
    @objc func update() {
        var airPressureRawData = ""
        var altitudeRawData = ""
                //acc dat
        var accRawDataX = ""
        var accRawDataY = ""
        var accRawDataZ = ""
                //gyro
                var gyroRawDataX = ""
                var gyroRawDataY = ""
                var gyroRawDataZ = ""
                //magnet
                var magnetRawDataX = ""
                var magnetRawDataY = ""
                var magnetRawDataZ = ""
                //time
        
        
                var gpsRawDataLon = ""
                var gpsRawDataLan = ""
                var gpsRawDataCourse = ""
                var gpsRawDataError = ""
                var gpsRawDataSpeed = ""
                //time
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
        
         if(self.displayBaroStatus.text=="Active")
        {
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                    if (error == nil) {
                        self.displayAirpressure.text="\(data!.pressure)"
                        self.displayAltitude.text="\(data!.relativeAltitude)"
                        
//                        print("////")
//                        print("\(data!.pressure)")
//                         print("\(data!.relativeAltitude)")
//                        print(self.displayAirpressure.text!)
//                        print(self.displayAltitude.text!)
//
//                        print(airPressureRawData)
//                        print(altitudeRawData)
//                        print("////")
                    }
                })
        }
         else{
            self.displayAirpressure.text="NA"
            self.displayAltitude.text="NA"
//            airPressureRawData="NA"
//            altitudeRawData="NA"
        }
        if(motionManager.isDeviceMotionActive)
        {
            //finalData=Data
            activityManager.startActivityUpdates(to: OperationQueue.main) {
                [weak self] (activity: CMMotionActivity?) in
                if activity!.walking  {
                    //                        self!.condifentDisplay.text=deatil
                    self?.walkDispaly.text = "Walking"
                    
                    userMode="walking"
                    
                    
                } else if activity!.stationary {
                    self?.walkDispaly.text = "Stationary"
                    
                    userMode="strationary"
                } else if activity!.running {
                    self?.walkDispaly.text = "Running"
                    
                    userMode="running"
                } else if activity!.automotive {
                    self?.walkDispaly.text = "Automotive"
                    
                    userMode="automotive"
                }
                else if activity!.cycling {
                    self?.walkDispaly.text = "Cycling"
                    
                    userMode="cycling"
                }
                else
                {
                    self?.walkDispaly.text = "undefined"
                    
                    userMode="undefined"
                }
            }
        }
        else
        {
            self.walkDispaly.text = "NA"
            
            userMode="NA"        }
        
        
        if(displayGpsStatus.text=="Active")
        {
            
            
            
            let tmpLon=manager.location?.coordinate.longitude
            
            
            gpsRawDataLon = String(manager.location!.coordinate.longitude)
            gpsRawDataLan = String(manager.location!.coordinate.latitude)
            gpsRawDataCourse = String( manager.location!.course)
            gpsRawDataError = String( manager.location!.horizontalAccuracy)
            gpsRawDataSpeed = String(manager.location!.speed.description)
                        displayGpsDataLon.text="lon: "+gpsRawDataLon
                        displayGpsDataLan.text="lat: "+gpsRawDataLan
                        displayGpsDataSpeed.text="speed: "+gpsRawDataSpeed
                        displayGpsDataHeading.text="course: "+gpsRawDataCourse
                        displayGpsDataError.text="error: "+gpsRawDataError
        }
        else
        {
                gpsRawDataLon = "NA"
                gpsRawDataLan = "NA"
                gpsRawDataCourse = "NA"
                gpsRawDataError = "NA"
                gpsRawDataSpeed = "NA"
                        displayGpsDataLon.text="lon: NA"
                        displayGpsDataLan.text="lat: NA"
                        displayGpsDataSpeed.text="speed: NA"
                        displayGpsDataHeading.text="course: NA"
                        displayGpsDataError.text="error: NA"
        }
                if motionManager.isAccelerometerActive
                {
                    accRawDataX = String(motionManager.accelerometerData!.acceleration.x)
                    accRawDataY = String(motionManager.accelerometerData!.acceleration.y)
                    accRawDataZ = String(motionManager.accelerometerData!.acceleration.z)
                    displayDataX.text="x: "+String(accRawDataX)
                    displayDataY.text="y: "+String(accRawDataY)
                    displayDataZ.text="z: "+String(accRawDataZ)
                }
                else
                {
                            accRawDataX = "NA"
                            accRawDataY = "NA"
                            accRawDataZ = "NA"
      
                    displayDataX.text="x: NA "
                    displayDataY.text="y: NA "
                    displayDataZ.text="z: NA "
                }
        
                if motionManager.isGyroActive
                {
                    gyroRawDataX = String(motionManager.gyroData!.rotationRate.x)
                    gyroRawDataY = String(motionManager.gyroData!.rotationRate.y)
                    gyroRawDataZ = String(motionManager.gyroData!.rotationRate.z)
                    displayGyroDataX.text="x: "+String(gyroRawDataX)
                    displayGyroDataY.text="y: "+String(gyroRawDataY)
                    displayGyroDataZ.text="z: "+String(gyroRawDataZ)
                }
                else
                {
                    gyroRawDataX = "NA"
                    gyroRawDataY = "NA"
                    gyroRawDataZ = "NA"
                    displayGyroDataX.text="x: NA "
                    displayGyroDataY.text="y: NA"
                    displayGyroDataZ.text="z: NA"
                }
        
                if motionManager.isMagnetometerActive
                {
                    magnetRawDataX = String( motionManager.magnetometerData!.magneticField.x)
                    magnetRawDataY = String(motionManager.magnetometerData!.magneticField.y)
                    magnetRawDataZ = String(motionManager.magnetometerData!.magneticField.z)
                    displayMagnetDataX.text="x: "+String(magnetRawDataX)
                    displayMagnetDataY.text="y: "+String(magnetRawDataY)
                    displayMagnetDataZ.text="z: "+String(magnetRawDataZ)
                }
                else
                {
                    magnetRawDataX = "NA"
                    magnetRawDataY = "NA"
                    magnetRawDataZ = "NA"
                    displayMagnetDataX.text="x: NA "
                    displayMagnetDataY.text="y: NA"
                    displayMagnetDataZ.text="z: NA"
                }
        
                   // finalData=Data+userMode
//        //motion
//        if(!motionManager.isDeviceMotionActive)
//        {
//            displayUserStatus.text="Active"
//            displayUserStatus.textColor = UIColor.green
//            motionManager.startDeviceMotionUpdates()
//            (sender as AnyObject).setTitle("deactive", for: .normal)
//        }
//        else
//        {
//            displayUserStatus.text="inactive"
//            (sender as AnyObject).setTitle("active", for: .normal)
//            displayUserStatus.textColor = UIColor.red
//            motionManager.stopDeviceMotionUpdates()
//
//        }
//        print(self.displayAirpressure.text!)
//        print(self.displayAltitude.text!)
        airPressureRawData = self.displayAirpressure.text!
        altitudeRawData = self.displayAltitude.text!
        let battery=String(UIDevice.current.batteryLevel)
        displayBattery.text="battery: "+battery+"%"
        makePostCall(date: dateString,accx: accRawDataX,accy: accRawDataY,accz: accRawDataZ, gyrox:gyroRawDataX,gyroy: gyroRawDataY,gyroz: gyroRawDataZ,magnx: magnetRawDataX,magny: magnetRawDataY,magnz: magnetRawDataZ,gpslon: gpsRawDataLon,gpslan: gpsRawDataLan,gpsspeed: gpsRawDataSpeed,gpscourse: gpsRawDataCourse,gpserror: gpsRawDataError,airpre: airPressureRawData,alti: altitudeRawData,battry: battery,mode: userMode)
        let Data=dateString+","+accRawDataX+","+accRawDataY+","+accRawDataZ+","+gyroRawDataX+","+gyroRawDataY+","+gyroRawDataZ+","+magnetRawDataX+","+magnetRawDataY+","+magnetRawDataZ+","+gpsRawDataLon+","+gpsRawDataLan+","+gpsRawDataSpeed+","+gpsRawDataCourse+","+gpsRawDataError+","+airPressureRawData+","+altitudeRawData+","+battery+","+userMode+"\n"

        
            if startToSave
            {
                accDatas.append(Data)
                //print(finalData)
                countDisplay.text="saved : "+String(accDatas.count);
               
//                let defaults = UserDefaults.standard
//
//                // Store
//                defaults.set(Data, forKey: "username")
//
//                // Receive
//                if let name = defaults.string(forKey: "username") {
//                    //print(name)
//                    // Will output "theGreatestName"
//                }
//                guard let appDelegate =
//                    UIApplication.shared.delegate as? AppDelegate else {
//                        return
//                }
//
//                // 1
//                let managedContext =
//                    appDelegate.persistentContainer.viewContext
//
//                // 2
//                let entity =
//                    NSEntityDescription.entity(forEntityName: "Sensor",
//                                               in: managedContext)!
//
//                let sensor = NSManagedObject(entity: entity,
//                                             insertInto: managedContext)
//
//                // 3
//                sensor.setValue(Data, forKeyPath: "data")
//
//                 //4
//                do {
//                    try managedContext.save()
//                    //                people.append(person)
//                } catch let error as NSError {
//                    print("Could not save. \(error), \(error.userInfo)")
//                }
                
                
                
                
                
                
                
                
            }
        }


   
}
