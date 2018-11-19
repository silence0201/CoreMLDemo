//
//  DataSource.swift
//  MarsHabitatPricePredictor
//
//  Created by Silence on 2018/11/18.
//  Copyright © 2018 Silence. All rights reserved.
//

import Foundation

struct SolarPanelsDataSource {
    let values = [1,1,5,2,2.5,3,3.5,4,4.5,5]
    
    func title(for index: Int) -> String? {
        guard index < values.count else {return nil}
        return String(values[index])
    }
    
    func value(for index: Int) -> Double? {
        guard index < values.count else {return nil}
        return Double(values[index])
    }
}

struct GreenhousesDataSource {
    let values = [1,2,3,4,5]
    
    func title(for index: Int) -> String? {
        guard index < values.count else {return nil}
        return String(values[index])
    }
    
    func value(for index: Int) -> Double? {
        guard index < values.count else {return nil}
        return Double(values[index])
    }
}

struct SizeDataSource {
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    let values = [
        750,
        1000,
        1500,
        2000,
        3000,
        4000,
        5000,
        10_000
    ]
    
    func title(for index: Int) -> String? {
        guard index < values.count else { return nil }
        return SizeDataSource.numberFormatter.string(from: NSNumber(value: values[index]))
    }
    
    func value(for index: Int) -> Double? {
        guard index < values.count else { return nil }
        return Double(values[index])
    }
}

