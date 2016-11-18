//
//  PlayerView.swift
//  360VideoPlayer
//
//  Created by Prianka Liz Kariat on 9/22/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    override class var layerClass: AnyClass  {
    
    get {
      return AVPlayerLayer.self
    }
  }

}
