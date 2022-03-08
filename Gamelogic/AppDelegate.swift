//
//  AppDelegate.swift
//  Plantinhas
//
//  Created by Bruno Imai on 26/01/22.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FBLPromises
import AppTrackingTransparency
import AdSupport
import FirebaseAnalytics
import FBAudienceNetwork
import Firebase
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if(UserDefaults.standard.bool(forKey: "notFirstInApp") == false){
            UserDefaults.standard.set(true, forKey: "notFirstInApp")
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Onboarding")
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "GameViewController")
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        GameManager.shared.newPlantVC =  storyboard.instantiateViewController(withIdentifier: "popUpNewPlantVC") as? NewPlantPopUpViewController
        
        ApplicationDelegate.shared.application(
                            application,
                            didFinishLaunchingWithOptions: launchOptions)

        FBAudienceNetworkAds.initialize(with: nil, completionHandler: nil)

            // Pass user's consent after acquiring it. For sample app purposes, this is set to YES.
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        GameManager.shared.saveGame()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        requestDataPermission()
    }

    func application(
                _ app: UIApplication,
                open url: URL,
                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
            ) -> Bool {
                ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
        }
    
    func requestDataPermission() {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                     
                        FBAdSettings.setAdvertiserTrackingEnabled(true)
                        Settings.shared.isAutoLogAppEventsEnabled = true
                        Settings.shared.isAdvertiserIDCollectionEnabled = true
                        Analytics.setUserProperty("true",
    forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
                        Analytics.setAnalyticsCollectionEnabled(true)
                        print("Authorized")
                    case .denied:
                 
                        FBAdSettings.setAdvertiserTrackingEnabled(false)
                        Settings.shared.isAutoLogAppEventsEnabled = false
                        Settings.shared.isAdvertiserIDCollectionEnabled = false
                                            Analytics.setUserProperty("false",
    forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
                        Analytics.setAnalyticsCollectionEnabled(false)
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                })
            } else {
                //you got permission to track, iOS 14 is not yet installed
            }
        }
    
    
}

