//
//  ViewController.swift
//  TeachMeShapes
//
//  Created by Shikhar Shah on 2019-11-04.
//  Copyright © 2019 Lambton. All rights reserved.
//

import UIKit
import Particle_SDK

class ViewController: UIViewController {

    
    var myPhoton : ParticleDevice?
    var username:String = "sshikharshah@gmail.com"
    var password:String = "Particle_2022"
    var DEVICE_ID:String = "3e0031001447363333343437"

    var flag: String = ""
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelLog: UILabel!
    var randomInt:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ParticleCloud.init()
        loginInParticle()
        getDeviceFromCloud()
        showRandomShape()
        // Do any additional setup after loading the view.
    }
    @IBAction func tryAnotherShape(_ sender: Any) {
        showRandomShape()

    }
    
    func showRandomShape(){
        var images = ["square","triangle"]
         self.randomInt = Int.random(in: 0..<2)
        print("Random Value: \(randomInt)")
        imageview.image = UIImage(named: images[randomInt])
        }
    func loginInParticle(){
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.username, password: self.password) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")
            }
        }
    }
    func getDeviceFromCloud() {
        labelLog.text = "How many sides does this shape have?"
        ParticleCloud.sharedInstance().getDevice(self.DEVICE_ID) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon: \(device?.id)")
                self.myPhoton = device
                self.subscribeToParticleEvents()

            }
            
        } 
    }
    
    func subscribeToParticleEvents() {
        var handler : Any?
        handler = ParticleCloud.sharedInstance().subscribeToDeviceEvents(
            withPrefix: "playerChoice",
            deviceID:self.DEVICE_ID,
            handler: {
                (event :ParticleEvent?, error : Error?) in
                
                if let _ = error {
                    print("could not subscribe to events")
                } else {
                    print("got event with data \(event?.data)!")
                    let choice = (event?.data)!
                    if  choice == "3" {
                        if self.randomInt == 1 {
                            DispatchQueue.main.async {
                                self.labelLog.text = "CORRECT!"
                            }
                            self.flag = "CORRECT!"
                        }
                        else{
                        DispatchQueue.main.async {
                            self.labelLog.text = "INCCORRECT!"
                        }
                        }
                    }
                    else if choice == "4" {
                        if self.randomInt == 0 {
                            print("CORRECT!")
                            self.flag = "CORRECT!"
                            DispatchQueue.main.async {
                                self.labelLog.text = "CORRECT!"
                            }
                        }
                        else{
                            print("INCORRECT!")
                            self.flag = "INCORRECT!"
                            DispatchQueue.main.async {
                                     self.labelLog.text = "INCCORRECT!"
                            }
                        }
//                        self.turnParticleRed()
                    }
                }
        })
    }
    

}

