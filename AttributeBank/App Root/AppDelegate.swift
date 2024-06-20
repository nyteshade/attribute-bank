//
//  AppDelegate.swift
//  AttributeBank
//
//  Created by Brielle Harrison on 6/19/24.
//

import AppKit
import SwiftUI
import OrderedCollections

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
  var window: NSWindow!
  var token: NSKeyValueObservation?
  var menuDict: MenuDictionary?

  func applicationDidFinishLaunching(_ notification: Notification) {
    if let menuDict = modifyMenus(["File", "Edit", "View", "Help", "Window"]) {
      self.menuDict = menuDict
    }
  }
  
  func applicationDidUnhide(_ notification: Notification) {
    print("Here")
  }
  
  func applicationDidHide(_ notification: Notification) {
    print("Hiding")
  }
  
  
  @discardableResult
  func modifyMenus(_ killList: [String] = []) -> MenuDictionary? {
    guard let mainMenu = NSApp.mainMenu else { return nil }
    
    let menuDict = MenuDictionary(mainMenu: mainMenu)

    for menu in mainMenu.items {
      let menuTitle = menu.title
            
      if let subMenu = menu.submenu, menu.hasSubmenu {
        menuDict.menu(named: subMenu.title, menu: subMenu)
        
        for menuItem in subMenu.items {
          if menu.title.count == 0 || menuItem.title.count == 0 { continue }
                    
          let title = menuItem.title
                  
          menuDict.submenuItem(menuName: menuTitle, itemName: title, menuItem: menuItem)
          
          if killList.firstIndex(of: title) != nil {
            subMenu.removeItem(menuItem)
          }
        }
        
        if killList.firstIndex(of: menuTitle) != nil {
          mainMenu.removeItem(menu)
        }
      }
    }
    
    // Must remove after every time SwiftUI re adds
    token = NSApp.observe(\.mainMenu, options: .new) { (app, change) in
      self.modifyMenus(killList)
    }
    
    return menuDict
  }
}

