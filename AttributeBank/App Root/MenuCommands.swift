//
//  MenuCommands.swift
//  AttributeBank
//
//  Created by Brielle Harrison on 6/18/24.
//

import SwiftUI


public struct SceneBuilder<MenuCommands: Commands>: NSViewRepresentable {
  public func makeNSView(context: Context) -> NSView {
    NSHostingView(rootView: view)
  }
  
  public func updateNSView(_ nsView: NSView, context: Context) {
    
  }
  
  public typealias NSViewType = NSView
  
  let menuCommands: MenuCommands
  let contentView: AnyView
  let windowGroupBuilder: (_ contentView: AnyView) -> WindowGroup<AnyView>
  let commandApplier: (
    _ windowGroup: WindowGroup<AnyView>,
    _ menuCommands: MenuCommands
  ) -> any Scene
  let windowGroup: WindowGroup<AnyView>
   
  init(
    menuCommands: MenuCommands,
    contentView: some View = EmptyView(),
    windowGroupBuilder: @escaping (_ contentView: AnyView) -> WindowGroup<AnyView> = {contentView in 
      WindowGroup { contentView }
    },
    commandApplier: @escaping (_: WindowGroup<AnyView>, _: MenuCommands) -> any Scene
  ) {
    self.menuCommands = menuCommands
    self.windowGroupBuilder = windowGroupBuilder
    self.commandApplier = commandApplier
    self.contentView = AnyView(contentView)
    self.windowGroup = windowGroupBuilder(AnyView(contentView))
  }
  
  var scene: any Scene {
    commandApplier(windowGroupBuilder(AnyView(contentView)), menuCommands)
  }
  var view: some View { contentView }
  
  public static func kBareCommandsScene(
    menuCommands: MenuCommands,
    contentView: some View = EmptyView(),
    commandApplier: ((_: WindowGroup<AnyView>, _: MenuCommands) -> any Scene)? = nil
  ) -> SceneBuilder<MenuCommands> {
    SceneBuilder(
      menuCommands: menuCommands,
      windowGroupBuilder: { contentView in WindowGroup { AnyView(contentView) } },
      commandApplier: commandApplier ?? {
        (winGroup: WindowGroup<AnyView>, menuCommands: MenuCommands) in
        winGroup.commandsReplaced(content: { menuCommands })
      }
    )
  }
  
  public static func kMoreCommandsScene(
    menuCommands: MenuCommands,
    contentView: some View = EmptyView(),
    commandApplier: ((_: WindowGroup<AnyView>, _: MenuCommands) -> any SwiftUI.Scene)? = nil
  ) -> SceneBuilder<MenuCommands> {
    SceneBuilder(
      menuCommands: menuCommands,
      windowGroupBuilder: { contentView in WindowGroup { AnyView(contentView) } },
      commandApplier: commandApplier ?? {
        (winGroup: WindowGroup<AnyView>, menuCommands: MenuCommands) in
        winGroup.commandsReplaced(content: { menuCommands })
      }
    )
  }
}

struct MenuCommands: Commands {
  var body: some Commands {
    CommandMenu("AttributeBank") {
      self.attrBankFileCreate().button
      self.attrBankFileCapture().button.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
      
      Divider()
      
      self.attrBankFileSave().button.disabled(true)
    }
  }
  
  func attrBankFileCreate() -> CommandData {
    return .init(
      action: {
        print("attribute.bank.create.library")
      },
      text: "Create Library"
    )
  }
  
  func attrBankFileCapture() -> CommandData {
    return .init(
      action: {
        print("attribute.bank.capture")
      },
      text: "Capture New File"
    )
  }
  
  func attrBankFileSave() -> CommandData {
    return .init(
      action: {
        print("attribute.bank.save.changes")
      },
      text: "Save Changes"
    )
  }
}

