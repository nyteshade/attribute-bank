//
//  MenuDictionary.swift
//  AttributeBank
//
//  Created by Brielle Harrison on 6/19/24.
//

import AppKit
import OrderedCollections
import SwiftUI

public typealias MenuDict = OrderedDictionary<String, NSMenu>
public typealias MenuItemDict = OrderedDictionary<String, OrderedDictionary<String, NSMenuItem>>

public class MenuDictionary {
  var mainMenu: NSMenu
  var appTitle: String
  
  var menus: MenuDict
  var menuItems: MenuItemDict
  
  init(mainMenu: NSMenu) {
    self.mainMenu = mainMenu
    self.appTitle = mainMenu.item(at: 0)?.title ?? ""
    
    self.menus = .init()
    self.menuItems = .init()
  }
  
  @discardableResult
  func hasMenu(named: String) -> Bool {
    menus[named] != nil
  }
  
  @discardableResult
  func menu(named: String, menu: NSMenu? = nil) -> NSMenu? {
    if let menu = menu {
      menus.updateValue(menu, forKey: named)
      return menu
    }
    
    return menus[named]
  }
  
  @discardableResult
  func hasSubmenuItem(menuName: String, itemName: String) -> Bool {
    menuItems[menuName]?.elements.first(where: { key, _ in key == menuName }) != nil
  }
  
  @discardableResult
  func submenuItem(menuName: String, itemName: String, menuItem: NSMenuItem? = nil) -> NSMenuItem? {
    if let menuItem = menuItem {
      if menuItems[menuName] == nil {
        menuItems.updateValue(.init(), forKey: menuName)
      }
      
      menuItems[menuName]?.updateValue(menuItem, forKey: itemName)
      
      return menuItem
    }
    
    return menuItems[menuName]?.first(where: { key, value in key == itemName })?.value
  }
}
