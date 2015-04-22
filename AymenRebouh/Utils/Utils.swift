//
//  Utils.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 22/04/15.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

//  ## To use everywhere ###

public func doInMainQueueAfter(#seconds: Float, completionHandler: () -> Void) {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((seconds * Float(NSEC_PER_SEC)))), dispatch_get_main_queue()) {
    completionHandler()
  }
}