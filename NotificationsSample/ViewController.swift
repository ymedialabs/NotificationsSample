//
//  ViewController.swift
//  NotificatiojnsSample
//
//  Created by Prianka Liz Kariat on 10/20/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
  
  var videoPlayer: VideoPlayer!
  var notificationBodyString: String = "We are testing notifications."
  
  @IBOutlet weak var notificationBodyField: UITextField!

  @IBOutlet weak var removeButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    removeButton.isEnabled = false
    
    notificationBodyField.delegate = self
    
    requestPermissionsWithCompletionHandler { (granted) -> (Void) in
      
      DispatchQueue.main.async {
        if granted {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
  }
  
  private func requestPermissionsWithCompletionHandler(completion: ((Bool) -> (Void))? ) {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) {[weak self] (granted, error) in
  
      guard error == nil else {
        
        completion?(false)
        return
      }
      
      if granted {
        
        UNUserNotificationCenter.current().delegate = self
        self?.setNotificationCategories()

      }
      
      completion?(granted)
    }
  }
 
  private func setNotificationCategories() {
    
    let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
    let replyAction = UNNotificationAction(identifier: "reply", title: "Reply", options: [])
    let archiveAction = UNNotificationAction(identifier: "archive", title: "Archive", options: [])
    let  ccommentAction = UNTextInputNotificationAction(identifier: "comment", title: "Comment", options: [])
    
    
    let localCat =  UNNotificationCategory(identifier: "local", actions: [likeAction], intentIdentifiers: [], options: [])
    
    let customCat =  UNNotificationCategory(identifier: "recipe", actions: [likeAction,ccommentAction], intentIdentifiers: [], options: [])
    
    let emailCat =  UNNotificationCategory(identifier: "email", actions: [replyAction, archiveAction], intentIdentifiers: [], options: [])
    
    UNUserNotificationCenter.current().setNotificationCategories([localCat, customCat, emailCat])

  }
  

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onClickSendNotification(_ sender: AnyObject) {
    
    notificationBodyField.resignFirstResponder()
    
    let content = UNMutableNotificationContent()
    content.title = "Local Notifications"
    content.subtitle =  "Good Morning"
    
    if  let characters = notificationBodyField.text?.characters, let text = notificationBodyField.text , characters.count > 0 {
      
      content.body = text
    }
    else {
      content.body = notificationBodyString
    }
   
    content.categoryIdentifier = "local"
    
    let url = Bundle.main.url(forResource: "gm", withExtension: "jpg")
    
    let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
    content.attachments = [attachment]
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) {[weak self] (error) in
      
      guard error == nil else {
        
        return
      }
      self?.removeButton.isEnabled = true
    }
    
  }
  
  @IBAction func onClickRemoveNotification(_ sender: AnyObject) {
    
    removeButton.isEnabled = false
    
    UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
      
      let isLocal = notifications.contains(where: { (notification) -> Bool in
        
        return notification.request.identifier == "localNotification"
        
      })
      
      if isLocal {
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:  ["localNotification"])
      }
      else
      {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notificationRequests) in
          
          let isLocal = notificationRequests.contains(where: { (request) -> Bool in
            
            return request.identifier == "localNotification"
          })
          
          if isLocal {
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["localNotification"])
          }
        })
        
      }
    }
  }
}


extension ViewController : UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
      completionHandler([.alert, .sound, .badge])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    if response.notification.request.identifier == "localNotification" {
      
      removeButton.isEnabled = true
      completionHandler()
    }

  }
}


extension ViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()

    return true
  }
  
}
