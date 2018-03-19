//
//  Ticker.swift
//  TickerFetch
//
//  Created by Anton Novoselov on 15/03/2018.
//  Copyright © 2018 Anton Novoselov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Ticker {
    
    // MARK: - PROPERTIES
    var id: Int
    var name: String
    
    var lastPrice: String
    var highestBid: String
    var percentChange: String
    
    var stateChange: PriceChangeState?
    
    enum PriceChangeState {
        case grow, fall, equal
    }
    
    // MARK: - INIT
    init(tickerName: String, responseObject: JSON) {
        self.name = tickerName
        self.id = responseObject["id"].intValue
        
        self.lastPrice = responseObject["last"].stringValue
        
        if let previousLastPrice = TickersPricesObserver.sharedObserver.tickersLastPricesDict[tickerName] {
            
            let currentLastPrice = Double(self.lastPrice) ?? 0
            
            if currentLastPrice < previousLastPrice {
                stateChange = .fall
            } else if currentLastPrice > previousLastPrice {
                stateChange = .grow
            } else {
                stateChange = .equal
            }
        }
        TickersPricesObserver.sharedObserver.tickersLastPricesDict[tickerName] = Double(self.lastPrice)
        
        self.highestBid = responseObject["highestBid"].stringValue
        self.percentChange = responseObject["percentChange"].stringValue
    }
}
