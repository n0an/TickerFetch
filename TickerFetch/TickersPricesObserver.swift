//
//  TickersPricesObserver.swift
//  TickerFetch
//
//  Created by Anton Novoselov on 15/03/2018.
//  Copyright © 2018 Anton Novoselov. All rights reserved.
//

import UIKit

class TickersPricesObserver {
    
    static let sharedObserver = TickersPricesObserver()
    
    // MARK: - PROPERTIES
    var tickersLastPricesDict = [String: Double]()
    
    var maxNameLength: CGFloat {
        if _maxNameLength == nil {
            _maxNameLength = calculateMaxLength()
        }
        return _maxNameLength!
    }
    
    private var _maxNameLength: CGFloat?
    
    private func calculateMaxLength() -> CGFloat {
        let lsortedKeys = tickersLastPricesDict.keys.sorted {$1.count < $0.count}
        
        var maxLength: CGFloat = 0.0
        
        for index in 0 ..< lsortedKeys.count/3 {
            let nameAttrString = NSAttributedString(string: lsortedKeys[index], attributes:[NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue-Bold", size:18.0)!])
            
            let rect = nameAttrString.boundingRect(with: CGSize(width: 300, height: 20), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            
            maxLength = max(maxLength, rect.width)
        }
        
        return maxLength + 4.0
    }
}
