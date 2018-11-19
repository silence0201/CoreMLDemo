//
//  ViewController.swift
//  MarsHabitatPricePredictor
//
//  Created by Silence on 2018/11/18.
//  Copyright © 2018 Silence. All rights reserved.
//

import UIKit
import CoreML

enum Feature: Int {
    case solarPanels = 0,greenhouses,size
}

class ViewController: UIViewController {
    
    // 数据源对象
    let solarPanelsDataSource = SolarPanelsDataSource()
    let greenhousesDataSource = GreenhousesDataSource()
    let sizeDataSource = SizeDataSource()
    
    func title(for row: Int, feature: Feature) -> String? {
        switch feature {
        case .solarPanels:return solarPanelsDataSource.title(for: row)
        case .greenhouses:return greenhousesDataSource.title(for: row)
        case .size:return sizeDataSource.title(for: row)
        }
    }
    
    func value(for row: Int, feature: Feature) -> Double {
        let value: Double?
        
        switch feature {
        case .solarPanels:      value = solarPanelsDataSource.value(for: row)
        case .greenhouses:      value = greenhousesDataSource.value(for: row)
        case .size:             value = sizeDataSource.value(for: row)
        }
        
        return value!
    }

    // 模型对象
    let model = MarsHabitatPricer()
    
    let priceFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale.current
        return formatter
    }()
    
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            let features: [Feature] = [.solarPanels,.greenhouses,.size]
            for feature in features {
                pickerView.selectRow(2, inComponent: feature.rawValue, animated: false)
            }
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePredictedPrice()
    }
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Feature(rawValue: component)! {
            case .solarPanels:  return solarPanelsDataSource.values.count
            case .greenhouses:  return greenhousesDataSource.values.count
            case .size:         return sizeDataSource.values.count
        }
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updatePredictedPrice()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let feature = Feature(rawValue: component) else {
            fatalError("Invalid component \(component) found to represent a \(Feature.self). This should not happen based on the configuration set in the storyboard.")
        }
        
        return title(for: row, feature: feature)
    }
}

// 使用模型预测
extension ViewController {
    func selectedRow(for feature: Feature) -> Int {
        return pickerView.selectedRow(inComponent: feature.rawValue)
    }
    
    func updatePredictedPrice() {
        let solarPanel = value(for: selectedRow(for: .solarPanels), feature: .solarPanels)
        let greenhouse = value(for: selectedRow(for: .greenhouses), feature: .greenhouses)
        let size = value(for: selectedRow(for: .size), feature: .size)
        
        guard let marsHabitatPricerOutput = try? model.prediction(solarPanels: solarPanel, greenhouses: greenhouse, size: size) else {
            fatalError("Unexpect runtime error")
        }
        
        let price = marsHabitatPricerOutput.price
        priceLabel.text = priceFormatter.string(for: price)
    }
}


