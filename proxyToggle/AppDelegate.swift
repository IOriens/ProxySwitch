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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(self.togglePopover(sender:))
        }
        
        //        let menu = NSMenu()
        //
        //        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(self.printQuote(sender:)), keyEquivalent: "P"))
        //        menu.addItem(NSMenuItem.separator())
        //        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        //
        //        statusItem.menu = menu
        
        popover.contentViewController = ProxyChangeViewController(nibName: "ProxyChangeViewController", bundle: nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(sender: AnyObject) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: AnyObject) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
    
}

