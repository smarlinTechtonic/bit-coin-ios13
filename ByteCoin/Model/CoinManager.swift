//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func priceDidChange(bitPrice: String)
    func didThrowError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = baseURL + currency
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let data = data {
                    // Turning data into a printable string
//                    if let strData = String.init(data: data, encoding: .utf8) {
//                        print (strData)
//                    }
                    if let bitCoinPrice = self.parseJSON(data) {
                        let priceString = String(format: "%.2f", bitCoinPrice)
                        self.delegate?.priceDidChange(bitPrice: priceString)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(CoinData.self, from: data)
            return decoded.last
        } catch {
            print(error)
            delegate?.didThrowError(error: error)
            return nil
        }
    }
}
