//
//  StringExtension.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 08/02/2015.
//  Copyright (c) 2015 Rebouh Aymen. All rights reserved.
//

import Security

extension String {

    /**
    From http://stackoverflow.com/questions/24123518/how-to-use-cc-md5-method-in-swift-language
    
    :returns: The string hashed
    */
    public func md5() -> String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(format: hash)
    }
    
    
    /**
    <#Description#>
    
    :returns: <#return value description#>
    */
    public func encodeBase64() -> String {
        return (self as NSString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
    }
}
