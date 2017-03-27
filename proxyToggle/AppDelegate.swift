//
//  AppDelegate.swift
//  proxyToggle
//
//  Created by Oriens on 15/12/2016.
//  Copyright © 2016 Oriens. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var popoverTransiencyMonitor: Any? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "Rocket")
            button.action = #selector(self.togglePopover(sender:))
        }
        
        popover.behavior = NSPopoverBehavior.transient
        popover.contentViewController = ProxyChangeViewController(nibName: "ProxyChangeViewController", bundle: nil)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(sender: AnyObject) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            if(popoverTransiencyMonitor == nil) { // Close Popover when clicking elements outside the popover
                popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown] as NSEventMask, handler: {event in
                    self.closePopover()
                })
            }
        }
    }
    
    
    
    func closePopover() {
        if(popoverTransiencyMonitor != nil){
            NSEvent.removeMonitor(popoverTransiencyMonitor!)
            popoverTransiencyMonitor = nil;
        }
        popover.close()
    }
    
    func togglePopover(sender: AnyObject) {
        if popover.isShown {
            closePopover()
        } else {
            showPopover(sender: sender)
        }
    }
    
    
}

