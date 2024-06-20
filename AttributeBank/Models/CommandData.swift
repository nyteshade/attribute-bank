//
//  CommandData.swift
//  AttributeBank
//
//  Created by Brielle Harrison on 6/19/24.
//

import SwiftUI

struct CommandData {
  var action: () -> Void
  var text: String
  let state = NSMutableDictionary()
  
  var button: some View {
    Button(action: self.action, label: { Text(self.text) })
  }
}

