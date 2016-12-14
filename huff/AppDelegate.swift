//
//  AppDelegate.swift
//  huff
//
//  Created by Xing Hui Lu on 11/22/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuthUI
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // assign global appearance options
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "RobotoMono-Regular", size:10)!], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "RobotoMono-Bold", size:17)!,
                                                             NSForegroundColorAttributeName: UIColor.white], for: .normal)
        UIApplication.shared.statusBarStyle = .lightContent
        
        // configure firebase
        FIRApp.configure()
        
        
        // configure the authorization
        configureAuth()

        
        // configure facebook login for the native fb app
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // configure google login
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)

        
        return googleDidHandle || facebookDidHandle
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        FIRAuth.auth()?.removeStateDidChangeListener(authHandle)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "huff")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate {
    // MARK: - firebase account state listener
    
    func configureAuth() {
        self.authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            // check if there's a user
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    
                    // home view controller will be the first screen the user sees
                    let homeTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? UITabBarController

                    DispatchQueue.main.async {
                        self.deallocCurrentAndDisplayNew(vc: homeTabController!)
                    }
                }
            } else {
                // if no user - present the login home
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginHome") as? UINavigationController
                DispatchQueue.main.async {
                    self.deallocCurrentAndDisplayNew(vc: loginVC!)
                }
            }
        })
    }
    
    // MARK: - helper method
    
    func deallocCurrentAndDisplayNew(vc: UIViewController) {
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

