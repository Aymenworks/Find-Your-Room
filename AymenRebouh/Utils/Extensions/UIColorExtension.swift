//
//  UIColorExtension.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 18/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import UIKit.UIColor

typealias ColorTuple = (red: CGFloat, green: CGFloat, blue: CGFloat)

extension UIColor {
  
  static func randomFlatColor() -> UIColor {
    struct RandomColors {
      static let colors: [ColorTuple] = [
        (red: 210/255, green: 77/255,  blue: 87/255),
        (red: 217/255, green: 30/255,  blue: 24/255),
        (red: 150/255, green: 40/255,  blue: 27/255),
        (red: 220/255, green: 198/255, blue: 224/255),
        (red: 103/255, green: 65/255,  blue: 114/255),
        (red: 68/255,  green: 108/255, blue: 179/255),
        (red: 210/255, green: 77/255,  blue: 87/255),
        (red: 228/255, green: 241/255, blue: 254/255),
        (red: 65/255,  green: 131/255, blue: 215/255),
        (red: 89/255,  green: 171/255, blue: 227/255),
        (red: 129/255, green: 207/255, blue: 224/255),
        (red: 82/255,  green: 179/255, blue: 217/255),
        (red: 197/255, green: 239/255, blue: 247/255),
        (red: 52/255,  green: 152/255, blue: 219/255),
        (red: 44/255,  green: 62/255,  blue: 80/255),
        (red: 51/255,  green: 110/255, blue: 123/255),
        (red: 34/255,  green: 49/255,  blue: 63/255),
        (red: 30/255,  green: 139/255, blue: 195/255),
        (red: 58/255,  green: 83/255,  blue: 155/255),
        (red: 52/255,  green: 73/255,  blue: 94/255),
        (red: 103/255, green: 128/255, blue: 159/255),
        (red: 37/255,  green: 116/255, blue: 169/255),
        (red: 31/255,  green: 58/255,  blue: 147/255),
        (red: 137/255, green: 196/255, blue: 244/255),
        (red: 75/255,  green: 119/255, blue: 190/255),
        (red: 92/255,  green: 151/255, blue: 191/255),
        (red: 78/255,  green: 205/255, blue: 196/255),
        (red: 162/255, green: 222/255, blue: 208/255),
        (red: 144/255, green: 198/255, blue: 149/255),
        (red: 3/255,   green: 201/255, blue: 169/255),
        (red: 104/255, green: 195/255, blue: 163/255),
        (red: 101/255, green: 198/255, blue: 187/255),
        (red: 27/255,  green: 188/255, blue: 155/255),
        (red: 27/255,  green: 163/255, blue: 156/255),
        (red: 102/255, green: 204/255, blue: 153/255),
        (red: 54/255,  green: 215/255, blue: 183/255),
        (red: 200/255, green: 247/255, blue: 197/255),
        (red: 134/255, green: 226/255, blue: 213/255),
        (red: 22/255,  green: 160/255, blue: 133/255),
        (red: 63/255,  green: 195/255, blue: 128/255),
        (red: 1/255,   green: 152/255, blue: 117/255),
        (red: 3/255,   green: 166/255, blue: 120/255),
        (red: 77/255,  green: 175/255, blue: 124/255),
        (red: 42/255,  green: 187/255, blue: 155/255),
        (red: 0/255,   green: 177/255, blue: 106/255),
        (red: 30/255,  green: 130/255, blue: 76/255),
        (red: 4/255,   green: 147/255, blue: 114/255),
        (red: 38/255,  green: 194/255, blue: 129/255),
        (red: 253/255, green: 227/255, blue: 167/255),
        (red: 235/255, green: 149/255, blue: 50/255),
        (red: 232/255, green: 126/255, blue: 4/255),
        (red: 244/255, green: 178/255, blue: 80/255),
        (red: 242/255, green: 120/255, blue: 75/255),
        (red: 235/255, green: 151/255, blue: 78/255),
        (red: 254/255, green: 171/255, blue: 53/255),
        (red: 211/255, green: 84/255,  blue: 0/255),
        (red: 242/255, green: 121/255, blue: 53/255),
        (red: 230/255, green: 126/255, blue: 34/255),
        (red: 108/255, green: 122/255, blue: 137/255),
        (red: 210/255, green: 215/255, blue: 211/255)
      ]
    }
    
    let colorTuple = RandomColors.colors[Int(arc4random_uniform(UInt32(RandomColors.colors.count)))]
    return UIColor(red: colorTuple.red, green: colorTuple.green, blue: colorTuple.blue, alpha: 1.0)
  }
}