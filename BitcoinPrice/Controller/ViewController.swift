//
//  ViewController.swift
//  BitcoinPrice
//
//  Created by Alicja Gruca on 18/07/2022.
//

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
        coinManager.getBitcoinPrice(for: coinManager.currencyArray[0])
    }
}
    
//MARK: - UIPickerViewDataSource
    
extension ViewController: UIPickerViewDataSource {
    //Called by the picker view when it needs the number of components.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    //Called by the picker view when it needs the number of rows for a specified component.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
    
//MARK: - UIPickerViewDelegate
    
extension ViewController: UIPickerViewDelegate {
    //Called by the picker view when it needs the title to use for a given row in a given component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    // This method is triggered whenever the user makes a change to the picker selection.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getBitcoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(bitcoinPriceString: String, currency: String) {
        DispatchQueue.main.sync {
            self.priceLabel.text = bitcoinPriceString
            self.currencyLabel.text = currency
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


