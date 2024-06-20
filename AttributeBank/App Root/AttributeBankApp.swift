//
//  AttributeBankApp.swift
//  AttributeBank
//
//  Created by Brielle Harrison on 6/18/24.
//

import SwiftUI
import AppKit

@main
struct AttributeBankApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .commands(content: {
      
      MenuCommands()
    })
  }
}
