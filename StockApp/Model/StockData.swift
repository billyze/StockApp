//
//  StockData.swift
//  StockApp
//
//  Created by Field Employee on 12/7/20.
//

import Foundation
import UIKit

typealias Response = [String:stockInfo]

struct stockInfo: Codable {
    let meta: metaData
    let values: [value]
}

struct metaData: Codable {
    let symbol: String
}

struct value: Codable {
    let datetime: String
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
}

struct stockNames: Codable {
    let data: [stockName]
}

struct stockName: Codable {
    let symbol: String
    let instrument_name: String
    let country: String
}

struct StockData5min: Codable {
    let metaData: MetaData
    let timeSeries: [String:TimeSeries]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (5min)"
    }
}

struct StockDataDaily: Codable {
    let metaData: MetaData
    let timeSeries: [String:TimeSeries]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (Daily)"
    }
}

struct StockDataWeekly: Codable {
    let metaData: MetaData
    let timeSeries: [String:TimeSeries]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Weekly Time Series"
    }
}

struct StockDataMonthly: Codable {
    let metaData: MetaData
    let timeSeries: [String:TimeSeries]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Monthly Time Series"
    }
}

struct MetaData: Codable {
    let information: String
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
    }
}

struct TimeSeries: Codable{
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
