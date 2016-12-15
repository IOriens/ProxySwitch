//
//  ProxyChangeViewController.swift
//  proxyToggle
//
//  Created by Oriens on 15/12/2016.
//  Copyright © 2016 Oriens. All rights reserved.
//

import Cocoa

class ProxyChangeViewController: NSViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        
    }
    
    @IBOutlet weak var option: NSButton!

    
    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
    
    @IBAction func turnOn(_ sender: Any) {
        print("hello")
    }
    @IBAction func openOption(_ sender: NSButton) {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(self.printQuote(sender:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        NSMenu.popUpContextMenu(menu, with: NSApplication.shared().currentEvent!, for: option!)

    }
    
    
    @IBAction func turnOff(_ sender: NSButton) {
    }
    
    
}
