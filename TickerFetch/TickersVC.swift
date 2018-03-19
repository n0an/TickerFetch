//
//  TickersVC.swift
//  TickerFetch
//
//  Created by Anton Novoselov on 15/03/2018.
//  Copyright © 2018 Anton Novoselov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class TickersVC: UIViewController {
    
    // MARK: - PROPERTIES
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellIdentifier = "TickerCell"
    var disposeBag = DisposeBag()
    let isRunning = Variable(true)
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TickersFetch"
        self.view.backgroundColor = .white
        
        createUI()
        bindElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isRunning.value = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isRunning.value = false
    }
    
    // MARK: - HELPER METHODS
    func bindElements() {
        
        let tickersObservable = isRunning.asObservable()
            //            .debug("isRunning")
            .flatMapLatest { (isRunning) in
                isRunning ? Observable<Int>.interval(updateInterval, scheduler: MainScheduler.instance) : .empty()
            }
            .enumerated().flatMap({ (num, index) -> Observable<[Ticker]> in
                
                var tickersArray = [Ticker]()
                
                return URLSession.shared.rx.json(url: URL(string: tickersURL)!).map {
                    
                    let json = JSON($0)
                    
                    let tickersDict = json.dictionaryValue
                    
                    for tickerName in tickersDict.keys {
                        
                        let ticker = Ticker(tickerName: tickerName, responseObject: tickersDict[tickerName]!)
                        
                        
                        tickersArray.append(ticker)
                    }
                    
                    return tickersArray
                }
            })
        //            .debug("timer")
        
        tickersObservable.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: TickerCell.self)) {
            (row, ticker: Ticker, cell: TickerCell) in
            
            cell.configure(with: ticker)
            
            }.disposed(by: disposeBag)
    }
    
    func createUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        tableView.register(TickerCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let tableViewConstraints: [NSLayoutConstraint]
        
        if #available(iOS 11.0, *) {
            tableViewConstraints = [
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
            
        } else {
            tableViewConstraints = [
                tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
}

// MARK: - UITableViewDelegate
extension TickersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
