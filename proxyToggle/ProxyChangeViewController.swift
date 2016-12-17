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
    
    var myFlags : AuthorizationFlags? = nil
    var authRef: AuthorizationRef? = nil
    var osStatus: OSStatus? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        myFlags = [.partialRights,  .extendRights, .interactionAllowed, .preAuthorize]
        authRef = nil
        osStatus = AuthorizationCreate(nil, nil, myFlags!, &authRef)
    }
    
    @IBOutlet weak var option: NSButton!
    
    
    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
    
    @IBAction func openOption(_ sender: NSButton) {
        
        let frame = sender.frame
        let menuOrigin = NSMakePoint(frame.origin.x + 13, frame.origin.y + 8)
        //        let event = NSApplication.shared().currentEvent!
        //        event.locationInWindow = menuOrigin
        let event = NSEvent.mouseEvent(with: NSEventType.leftMouseDown, location: menuOrigin, modifierFlags: NSEventModifierFlags.deviceIndependentFlagsMask, timestamp: 0, windowNumber: (sender.window?.windowNumber)!, context: sender.window?.graphicsContext, eventNumber: 0, clickCount: 1, pressure: 1)
        
        let menu = NSMenu()
        
        //        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(self.printQuote(sender:)), keyEquivalent: "P"))
        //        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        NSMenu.popUpContextMenu(menu, with: event!, for: option!)
        //        menu.popUp(positioning: nil, at: option.bounds.origin , in: nil)
        //        menu.popUp(positioning: NSMenuItem?, at: <#T##NSPoint#>, in: NSView?)
    }
    
    
    
    
    @IBAction func turnOn(_ sender: Any) {
        toggleProxy(flag: 1)
    }
    @IBAction func turnOff(_ sender: NSButton) {
        toggleProxy(flag: 0)
    }
    
    func toggleProxy(flag: NSNumber) {
        print("tag 1")
        
        
        //        let myFlags : AuthorizationFlags = [.partialRights,  .extendRights, .interactionAllowed, .preAuthorize]
        //        var authRef: AuthorizationRef? = nil
        //        let osStatus = AuthorizationCreate(nil, nil, myFlags, &authRef)
        //        print(osStatus == errAuthorizationInvalidSet)
        
        if(self.osStatus != errAuthorizationSuccess || self.authRef == nil) {
            //            print("fuck")
            
            return
        }
        
        let prefRef = SCPreferencesCreateWithAuthorization(nil, "Oriens" as CFString, nil, self.authRef)!
        let sets = SCPreferencesGetValue(prefRef, kSCPrefNetworkServices)!
        
        print("tag 2")
        
        
        // Proxy Settings
        var proxies = [NSObject: AnyObject]()
        
        //        proxies[kCFNetworkProxiesSOCKSProxy] = "127.0.0.1"//打开 SS 代理
        //        proxies[kCFNetworkProxiesSOCKSPort] = 1080
        //        proxies[kCFNetworkProxiesSOCKSEnable] = 1
        
        print("tag 3")
        
        if(flag == 1) {
            print("true")
            proxies[kCFNetworkProxiesHTTPEnable] = 1 as NSNumber//开启 http 代理
            proxies[kCFNetworkProxiesHTTPSEnable] = 1 as NSNumber
            proxies[kCFNetworkProxiesHTTPProxy] = "172.0.0.1" as AnyObject?
            proxies[kCFNetworkProxiesHTTPPort] = 7777 as NSNumber
            proxies[kCFNetworkProxiesHTTPSProxy] = "172.0.0.1" as AnyObject?
            proxies[kCFNetworkProxiesHTTPSPort] = 7777 as NSNumber
            proxies[kCFNetworkProxiesExcludeSimpleHostnames] = 1 as NSNumber
            //            proxies[kCFNetworkProxiesProxyAutoConfigEnable] = 0
        } else {
            //            print("dfasdfs")
            proxies[kCFNetworkProxiesHTTPEnable] = 0 as NSNumber//关闭 http 代理
            proxies[kCFNetworkProxiesHTTPSEnable] = 0 as NSNumber
            //            proxies[kCFNetworkProxiesProxyAutoConfigEnable] = 0
        }
        
        
        //        print(sets)
        //// 遍历系统中的网络设备列表，设置 AirPort 和 Ethernet 的代理
        sets.allKeys!.forEach { (key) in
            //            print(key)
            let dict = sets.object(forKey: key)!
            
            let hardware = (dict as AnyObject).value(forKeyPath: "Interface.Hardware")
            
            //            let hardware = dict.
            if hardware != nil && ["AirPort","Wi-Fi","Ethernet"].contains(hardware as! String) {
                //                print(hardware as! String)
                //                print(dict)
                //                print("\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)")
                print(SCPreferencesPathSetValue(prefRef, "/\(kSCPrefNetworkServices)/\(key)/\(kSCEntNetProxies)" as CFString, proxies as CFDictionary))//注意这里的路径，一开始少了一个'/'
            }
        }
        
        
        SCPreferencesCommitChanges(prefRef)
        SCPreferencesApplyChanges(prefRef)
        SCPreferencesSynchronize(prefRef)
        //        AuthorizationFree(authRef!, AuthorizationFlags.destroyRights)
    }
    
    
}
