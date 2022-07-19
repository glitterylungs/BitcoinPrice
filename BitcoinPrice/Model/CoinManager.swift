//
//  CoinManager.swift
//  BitcoinPrice
//
//  Created by Alicja Gruca on 18/07/2022.
//

import Foundation

protocol CoinManagerDelegate{
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let bitcoinPricesURL: String = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey: String = "9410D272-55D9-4D5F-8773-6FFC199FA418"
    
    let currencyArray: [String] = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getBitcoinPrice(for currency: String) {
        let urlString = "\(bitcoinPricesURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // 1. Create an URL
        if let url = URL(string: urlString){
            // 2. Create an URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) {data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(safeData)
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ priceData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: priceData)
            let rate = decodedData.rate
            return rate
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
