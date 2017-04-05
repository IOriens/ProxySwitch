//
//  ProxyChangeViewController.swift
//  proxyToggle
//
//  Created by Oriens on 15/12/2016.
//  Copyright © 2016 Oriens. All rights reserved.
//

import Cocoa
import Foundation
import SystemConfiguration

class ProxyChangeViewController: NSViewController {
    
    var authFlags : AuthorizationFlags? = nil
    var authRef: AuthorizationRef? = nil
    var osStatus: OSStatus? = nil
    
    @IBOutlet weak var option: NSButton!
    
    
    /*
     * Init
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        authFlags = [.partialRights,  .extendRights, .interactionAllowed, .preAuthorize]
        authRef = nil
        
        // Authorization
        osStatus = AuthorizationCreate(nil, nil, authFlags!, &authRef)
    }
    
    
    /*
     * Listeners
     */
    // Turn on Proxy
    @IBAction func turnOn(_ sender: Any) {
        toggleProxy(flag: 1)
    }
    
    // Turn off Proxy
    @IBAction func turnOff(_ sender: NSButton) {
        toggleProxy(flag: 0)
    }
    
    // Context Menu
    @IBAction func openOption(_ sender: NSButton) {
        
        // Setting Context Menu
        let frame = sender.frame
        let menuOrigin = NSMakePoint(frame.origin.x + 13, frame.origin.y + 8)
        let event = NSEvent.mouseEvent(with: NSEventType.leftMouseDown, location: menuOrigin, modifierFlags: NSEventModifierFlags.deviceIndependentFlagsMask, timestamp: 0, windowNumber: (sender.window?.windowNumber)!, context: sender.window?.graphicsContext, eventNumber: 0, clickCount: 1, pressure: 1)
        let menu = NSMenu()
        // Quit the app
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        // Popup Context Menu
        NSMenu.popUpContextMenu(menu, with: event!, for: option!)
        
    }
    
    
    /*
     * Logics
     */
    
    func toggleProxy(flag: NSNumber) {
        
        if(self.osStatus != errAuthorizationSuccess || self.authRef == nil) {
            return
        }
        
        let prefRef = SCPreferencesCreateWithAuthorization(nil, "Oriens" as CFString, nil, self.authRef)!
        let sets = SCPreferencesGetValue(prefRef, kSCPrefNetworkServices)!
        
        // Proxy Settings
        var proxies = [NSObject: AnyObject]()
        if(flag == 1) {
            proxies[kCFNetworkProxiesHTTPEnable] = 1 as NSNumber //Turn on http proxy
            proxies[kCFNetworkProxiesHTTPSEnable] = 1 as NSNumber
            proxies[kCFNetworkProxiesHTTPProxy] = "127.0.0.1" as AnyObject?
            proxies[kCFNetworkProxiesHTTPPort] = 7777 as NSNumber
            proxies[kCFNetworkProxiesHTTPSProxy] = "127.0.0.1" as AnyObject?
            proxies[kCFNetworkProxiesHTTPSPort] = 7777 as NSNumber
            proxies[kCFNetworkProxiesExcludeSimpleHostnames] = 1 as NSNumber
        } else {
            proxies[kCFNetworkProxiesHTTPEnable] = 0 as NSNumber //Turn off http proxy
            proxies[kCFNetworkProxiesHTTPSEnable] = 0 as NSNumber
        }
        
        // Traverse hardware list and set proxy for AirPort and Ethernet
        sets.allKeys!.forEach { (key) in
            let dict = sets.object(forKey: key)!
            
            let hardware = (dict as AnyObject).value(forKeyPath: "Interface.Hardware")
            
            if hardware != nil && ["AirPort","Wi-Fi","Ethernet"].contains(hardware as! String) {
                print(SCPreferencesPathSetValue(prefRef,
                 "/\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)" as CFString, 
                 proxies as CFDictionary))
            }
        }
        
        // Apply Changes
        SCPreferencesCommitChanges(prefRef)
        SCPreferencesApplyChanges(prefRef)
        SCPreferencesSynchronize(prefRef)
        // AuthorizationFree(authRef!, AuthorizationFlags.destroyRights)
    }
    
    
}
