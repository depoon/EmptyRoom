//
//  PGBeaconManager.swift
//  Test360
//
//  Created by Kenneth Poon on 26/4/17.
//  Copyright © 2017 Kenneth Poon. All rights reserved.
//

import Foundation
import AudioToolbox


class PGBeaconManager: NSObject {
    public static let sharedInstance: PGBeaconManager = PGBeaconManager()
    let beaconManager = ESTBeaconManager()
    var delegate: PGBeaconManagerDelegate?
    var uuidToImageFileDictionary = [String: String]()
    
    private override init(){
        
    }
    
    func setupBeacons(){
        beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        self.loadIBeacons()

    }
    
    func loadIBeacons(){
        
        if let path = Bundle.main.path(forResource: "iBeacon", ofType: "plist") {
            if let _dict = NSDictionary(contentsOfFile: path) as? [String : Any] {
                //iBeaconDictionary = _dict
                if let beaconArray = _dict["Beacons"] as? [[String: Any]] {
                    for beaconDictionary in beaconArray {
                        
                        guard let enabled = beaconDictionary["enabled"] as? Bool else { continue }
                        guard enabled else { continue } 
                        
                        guard let name = beaconDictionary["Name"] as? String else { continue }
                        guard let uuid = beaconDictionary["UUID"] as? String else { continue }
                        
                        guard let major = beaconDictionary["major"] as? NSNumber else { continue }
                        guard let minor = beaconDictionary["minor"] as? NSNumber else { continue }
                        guard let imageFile = beaconDictionary["imageFile"] as? String else { continue }
                        
                        let aBeaconRegion = CLBeaconRegion(
                            proximityUUID: UUID(uuidString: uuid)!,
                            major: major.uint16Value, minor: minor.uint16Value, identifier: name)
                        
                        self.uuidToImageFileDictionary[uuid] = imageFile
                        self.beaconManager.startRangingBeacons(in: aBeaconRegion)
                    }
                }
            }
        }
    }
}

extension PGBeaconManager : ESTBeaconManagerDelegate {
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let firstBeacon = beacons.first {
            if firstBeacon.accuracy <= 1{
                if let imageFile = self.uuidToImageFileDictionary[firstBeacon.proximityUUID.uuidString] {                    
                    self.delegate?.didReceiveBeaconImage(imageName: imageFile)
                }  
            } 

        }
    }
    
    
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {}    
    func beaconManager(_ manager: Any, didFailWithError error: Error) {}    
    func beaconManager(_ manager: Any, didStartMonitoringFor region: CLBeaconRegion) {}    
    func beaconManagerDidStartAdvertising(_ manager: Any, error: Error?) {}
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {}
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {}    
}


protocol PGBeaconManagerDelegate {
    func didReceiveBeaconImage(imageName: String)
}
