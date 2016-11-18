//
//  NotificationViewController.swift
//  CustomUI
//
//  Created by Prianka Liz Kariat on 11/3/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  var videoPlayer: VideoPlayer!
  private lazy var urlSession: URLSession = URLSession()
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var playerView: UIView!
  @IBOutlet weak var coverImageView: UIImageView!
  @IBOutlet var label: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any required interface initialization here.
  }
  
  func didReceive(_ notification: UNNotification) {
    bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
    
    
    if let bestAttemptContent = bestAttemptContent {
      
      titleLabel.text = bestAttemptContent.title
      subtitleLabel.text = bestAttemptContent.subtitle
      descriptionLabel.text = bestAttemptContent.body
      
      let attachment = bestAttemptContent.attachments[0]
      
      self.videoPlayer = VideoPlayer(url: attachment.url)
      self.videoPlayer.setUpPlayerInView(view: self.playerView)
      self.videoPlayer.play()
      
      descriptionLabel.text = bestAttemptContent.body
    }
    
  }
  
  func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
    
    if response.actionIdentifier == "comment" {
      
      completion(.dismiss)
    }
  }
  
}
