//
//  TickerCell.swift
//  TickerFetch
//
//  Created by Anton Novoselov on 15/03/2018.
//  Copyright © 2018 Anton Novoselov. All rights reserved.
//

import UIKit

class TickerCell: UITableViewCell {
    
    // MARK: - PROPERTIES
    private var nameLabel = UILabel()
    private var lastPriceLabel = UILabel()
    private var highestBidLabel = UILabel()
    private var percentChangeLabel = UILabel()
    private var highestBidTagLabel = UILabel()

    private var hightstBidLabelConstraintToNameLabel: NSLayoutConstraint!
    private var hightstBidLabelConstraintToCenter: NSLayoutConstraint!

    // MARK: - INIT
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLeadingConstraint()
    }
    
    // MARK: - HELPER METHODS
    func createUI() {
        let lastPriceTagLabel = UILabel()
        lastPriceTagLabel.attributedText = NSAttributedString(string: "Last:", attributes:[NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue-Light", size:13.0)!])
        
        highestBidTagLabel.attributedText = NSAttributedString(string: "Highest bid:", attributes:[NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue-Light", size:13.0)!])
        
        [lastPriceTagLabel, highestBidTagLabel, nameLabel, lastPriceLabel, highestBidLabel, percentChangeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        nameLabel.widthAnchor.constraint(equalToConstant: TickersPricesObserver.sharedObserver.maxNameLength).isActive = true
        
        hightstBidLabelConstraintToNameLabel = highestBidTagLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8)
        hightstBidLabelConstraintToCenter = highestBidTagLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        updateLeadingConstraint()
        
        highestBidTagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true

        lastPriceTagLabel.trailingAnchor.constraint(equalTo: highestBidTagLabel.trailingAnchor, constant: 0).isActive = true
        lastPriceTagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        lastPriceTagLabel.bottomAnchor.constraint(equalTo: highestBidTagLabel.topAnchor, constant: -8).isActive = true
        
        lastPriceLabel.centerYAnchor.constraint(equalTo: lastPriceTagLabel.centerYAnchor).isActive = true
        lastPriceLabel.leadingAnchor.constraint(equalTo: lastPriceTagLabel.trailingAnchor, constant: 4).isActive = true
        
        highestBidLabel.centerYAnchor.constraint(equalTo: highestBidTagLabel.centerYAnchor).isActive = true
        highestBidLabel.leadingAnchor.constraint(equalTo: highestBidTagLabel.trailingAnchor, constant: 4).isActive = true
        
        percentChangeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        percentChangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with ticker: Ticker) {
        
        let tickerColor: UIColor
        
        let tickerPercentChange = (Double(ticker.percentChange) ?? 0) * 100.0
        
        if tickerPercentChange < 0 {
            tickerColor = .red
        } else {
            tickerColor = UIColor(red:0.093, green:0.649, blue:0.091, alpha:1.0)
        }
        
        if let tickerStateChange = ticker.stateChange {
            
            switch tickerStateChange {
            case .grow:
                animateSplashCell(withColor: UIColor(red:0.093, green:0.649, blue:0.091, alpha:1.0))
                
            case .fall:
                animateSplashCell(withColor: .red)
                
            case .equal:
                break
            }
        }
        
        let nameAttrString = NSAttributedString(string: ticker.name, attributes:[NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue-Bold", size:18.0)!])
        
        nameLabel.attributedText = nameAttrString
        
        lastPriceLabel.attributedText = NSAttributedString(string: ticker.lastPrice, attributes:[NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue", size:14.0)!])
        
        highestBidLabel.attributedText = NSAttributedString(string: ticker.highestBid, attributes:[NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue", size:14.0)!])
        
        percentChangeLabel.attributedText = NSAttributedString(string: String(format: "%.2f%@", tickerPercentChange, "%"), attributes:[NSAttributedStringKey.foregroundColor:tickerColor,NSAttributedStringKey.font:UIFont(name:"HelveticaNeue-Medium", size:18.0)!])
    }
    
    
    private func updateLeadingConstraint() {
        let narrowScreen = self.frame.size.width < 500
        
        hightstBidLabelConstraintToNameLabel.isActive = narrowScreen
        hightstBidLabelConstraintToCenter.isActive = !narrowScreen
    }
    
    private func animateSplashCell(withColor color: UIColor) {
        UIView.transition(with: contentView, duration: 0.2, options: .curveEaseIn, animations: { [weak self] in
            self?.contentView.backgroundColor = color
            }, completion: { [weak self] (finished) in
                
                UIView.transition(with: (self?.contentView)!, duration: 0.3, options: .curveEaseInOut, animations: { [weak self] in
                    self?.contentView.backgroundColor = .white
                    }, completion: nil)
        })
    }
}
