//
//  NetworkManager.swift
//  StockApp
//
//  Created by Field Employee on 12/4/20.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    let session: URLSession
    let key1: String = "915245a034794e28baca3f7fe687212e"
    let key2: String = "VC7B8PM1J1LSTXC7"
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension NetworkManager {
    
    func getStockTableValues(stockList:[String], completion: @escaping ([String]) -> ()) {
        var stockListString: String = ""
        var stockValues: [String] = []
        stockList.forEach{
            stockListString = stockListString + $0 + ","
        }
        stockListString = String(stockListString.dropLast())
        var url: URL
        url = URL(string:"https://api.twelvedata.com/time_series?symbol=\(stockListString)&interval=1day&outputsize=1&apikey=\(key1)")!
        session.dataTask(with: url) { (data,response,error) in
            do{
                let result = try JSONDecoder().decode(Response.self, from: data!)
                let sorted = result.sorted{$0.0 < $1.0}
                sorted.forEach{
                    stockValues.append(String($0.value.values[0].close.dropLast(3)))
                }
                completion(stockValues)
            } catch {
                print(error)
                completion(["Error"])
            }
        }.resume()
    }
    
    func getStockValues(stockSymbol: String, timeSeries:String, completion: @escaping([String:String]) -> ()) {
        var url: URL
        var interval: String = ""
        var stockValues: [String:String] = [:]
        if(timeSeries == "INTRADAY")
        {
            interval = "&interval=5min"
        }
        url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_\(timeSeries)&symbol=\(stockSymbol)\(interval)&apikey=\(key2)")!
        session.dataTask(with: url) { (data,response,error) in
            do{
                switch(timeSeries){
                case("INTRADAY"): let result = try JSONDecoder().decode(StockData5min.self, from: data!)
                    result.timeSeries.forEach{
                        stockValues[$0.key] = $0.value.close
                    }
                    completion(stockValues)
                case("DAILY"): let result = try JSONDecoder().decode(StockDataDaily.self, from: data!)
                    result.timeSeries.forEach{
                        stockValues[$0.key] = $0.value.close
                    }
                    completion(stockValues)
                case("WEEKLY"): let result = try JSONDecoder().decode(StockDataWeekly.self, from: data!)
                    result.timeSeries.forEach{
                        stockValues[$0.key] = $0.value.close
                    }
                    completion(stockValues)
                case("MONTHLY"): let result = try JSONDecoder().decode(StockDataMonthly.self, from: data!)
                    result.timeSeries.forEach{
                        stockValues[$0.key] = $0.value.close
                    }
                    completion(stockValues)
                    default:
                        print("Error")
                    }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchStocks(search: String, completion: @escaping ([String],[String]) -> ()) {
        var nameList: [String] = []
        var companyList: [String] = []
        var count: Int = 0
        var url: URL
        url = URL(string:"https://api.twelvedata.com/symbol_search?symbol=\(search)")!
        session.dataTask(with: url) { (data,response,error) in
            do{
                let result = try JSONDecoder().decode(stockNames.self, from: data!)
                let sorted = result.data.sorted{$0.symbol < $1.symbol}
                sorted.forEach{
                    if($0.country == "United States"){
                        if(count < 30){
                            nameList.append($0.symbol)
                            companyList.append($0.instrument_name)
                            count = count + 1
                        }
                    }
                }
                completion(nameList,companyList)
            } catch {
                print(error)
            }
        }.resume()
    }
}
