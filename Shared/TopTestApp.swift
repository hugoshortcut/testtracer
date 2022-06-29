//
//  TopTestApp.swift
//  Shared
//
//  Created by Hugo Diaz on 2022-06-28.
//

//  'TopTestApp' launches and gets App Delegate & Scene Delegate
//  to be able to use them from SwiftUI code when needed.
//  I generally like to show a splashscreen animation and that is why I use this pattern.
//  ----------------------------------------------------

import SwiftUI

// MARK: - Application Launch
@main
struct TopTestApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if !current.isSkippingInitialScene {
                LoginView()
                    .environmentObject(AuthorizeViewModel())
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("scene is now active…")
            case .inactive:
                print("…scene is now inactive")
            case .background:
                print("scene is now in the background")
            @unknown default:
                print("No idea where scene is right now.")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure initial view controller here.
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = DefaultSceneDelegate.self
        return sceneConfig
    }
}

// MARK: - Scene Delegate
class DefaultSceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    @EnvironmentObject private var appDelegate: AppDelegate
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard current.isSkippingInitialScene, let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let newWindow = UIWindow(windowScene: windowScene)
        // Make a struct view into a viewController to show onscreen.
        newWindow.rootViewController = UIHostingController(rootView: current.initialViewTested)
        self.window = newWindow
        newWindow.makeKeyAndVisible()

        // Create new UIWindow, a view hierarchy, set root view controller with our view controller.
    }
}
