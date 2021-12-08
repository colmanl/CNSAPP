//
//  AppDelegate.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 10/5/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import SwiftUI
import UserNotifications
import SafariServices

enum Identifiers {
  static let viewAction = "VIEW_IDENTIFIER"
  static let newsCategory = "NEWS_CATEGORY"
}
struct Payload: Decodable {
    let aps: APS
    let acme1: String?
    let acme2: [String]?
}

struct APS: Decodable {
    let alert: Alert
    let badge: Int?
}

struct Alert: Decodable {
    let title: String
    let body: String?
    let action: String?
}
@main
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

let gcmMessageIDKey = "CNUCap.me"
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        registerForPushNotifications()


        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
        
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            print("Remote FCM registration token: \(token)")
          }
        }
       let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if let notification = notificationOption as? [String: AnyObject],
          let aps = notification["aps"] as? [String: AnyObject] {
          // 2
      //    NewsItem.makeNewsItem(aps)
        let main = window?.rootViewController as! AnnouncementsTableViewController
          // 3
       //  (window?.rootViewController as? UITabBarController)?.selectedIndex = 5
        }
        
            /*  let notificationOption = launchOptions?[.remoteNotification]
               if let notification = notificationOption as? [String: AnyObject],
                   let aps = notification["aps"] as? [String: AnyObject] {
                   // Process remote notification in the view
                   let main = window?.rootViewController as! AnnouncementsTableViewController
                //   main.initialieNotification = aps
               }*/
               

      //  FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    
      // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
        
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        let title = alert?["title"]
        let body = alert?["body"]
        print(title ?? "nil")
        print(body ?? "nil")
        
        
     /*   guard let aps = userInfo["aps"] as? [String: AnyObject] else {
         //   completionHandler(.failed)
            return
          }*/
        if let title = title , let body = body {
            NewsItem.makeNewsItem(title: title, body: body)
        }
       //  completionHandler(.newData)
       // print(String(describing: v))

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // ...

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([[.banner, .list, .sound]])
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
       // let userInfo = response.notification.request.content.userInfo

          let userInfo = response.notification.request.content.userInfo
      /*    let aps = userInfo["aps"] as! [String:AnyObject]
          
          if let newsItem = NewsItem.makeNewsItem(aps) {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 4
            
          /*  if response.actionIdentifier == viewAction,
              let url = URL(string: newsItem.link) {
              let safari = SFSafariViewController(url: url)
              window?.rootViewController?.present(safari, animated: true, completion: nil)
            }*/
          }*/
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)

        completionHandler()
      }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
       guard let aps = userInfo["aps"] as? [String: AnyObject] else {
           completionHandler(.failed)
           return
         }
       //  NewsItem.makeNewsItem(aps)
        completionHandler(.newData)

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
          print("Permission granted: \(granted)")
          guard granted else { return }
          let viewAction = UNNotificationAction(
            identifier: Identifiers.viewAction,
            title: "View",
            options: [.foreground])
          let newsCategory = UNNotificationCategory(
            identifier: Identifiers.newsCategory,
            actions: [viewAction],
            intentIdentifiers: [],
            options: []
          )
          UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
          self?.getNotificationSettings()
        }
    }

    

}
/*extension AppDelegate{
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    let userInfo = response.notification.request.content.userInfo
    let aps = userInfo["aps"] as! [String:AnyObject]
    
    if let newsItem = NewsItem.makeNewsItem(aps) {
      (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
      
    /*  if response.actionIdentifier == viewAction,
        let url = URL(string: newsItem.link) {
        let safari = SFSafariViewController(url: url)
        window?.rootViewController?.present(safari, animated: true, completion: nil)
      }*/
    }
    
    completionHandler()
  }
  
}
*/
