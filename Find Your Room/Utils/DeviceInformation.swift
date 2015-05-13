//
//  DeviceInformation.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 25/03/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//


public final class DeviceInformation {
  
  public static func isIphone() -> Bool {
    return UI_USER_INTERFACE_IDIOM() == .Phone
  }
  
  public static func isIphone5OrLess() -> Bool {
    return DeviceInformation.isIphone() && CGRectGetHeight(UIScreen.mainScreen().bounds) <= 568.0
  }
  
  public static func isIphone4SOrLess() -> Bool {
    return DeviceInformation.isIphone() && CGRectGetHeight(UIScreen.mainScreen().bounds) < 568.0
  }
}