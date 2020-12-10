//
//  stockInfoViewController.swift
//  StockApp
//
//  Created by Field Employee on 12/8/20.
//

import UIKit
import Charts

class stockInfoViewController: UIViewController, ChartViewDelegate {

    var symbol: String = ""
    var companyName: String = ""
    var favoriteList: [String:String] = [:]
    var stockValues5min: [String:String] = [:]
    var stockValuesDaily: [String:String] = [:]
    var stockValuesWeekly: [String:String] = [:]
    var stockValuesMonthly: [String:String] = [:]
    var isFavorite: Bool = false
    var favoriteCount: Int = 0
    var lineChart = LineChartView()
    var length: CGFloat = 0.0
    
    @IBOutlet weak var stockSymbolLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var intradayBtn: UIButton!
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        self.favorite()
        self.getData()
        stockSymbolLbl.text = symbol
        companyNameLbl.text = companyName
        if(self.view.frame.size.width > self.view.frame.size.height)
        {
            self.length = self.view.frame.size.height
        }
        else
        {
            self.length = self.view.frame.size.width
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = (self.navigationController?.navigationBar.frame.size.height)! + 10
        lineChart.frame = CGRect(x:0, y:height, width: length, height: length)
        view.addSubview(lineChart)
    }
    
    @IBAction func favoriteBtnTap(_ sender: Any) {
        if(self.isFavorite){
            self.favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            FirebaseManager.shared.removeFromFavorites(symbol: self.symbol, companyName: self.companyName)
            favoriteCount = favoriteCount - 1
            self.isFavorite = false
        }
        else{
            if(favoriteCount < 4)
            {
                self.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                FirebaseManager.shared.addToFavorites(symbol: self.symbol, companyName: self.companyName)
                self.isFavorite = true
            }
            else{
                let errorAlert = UIAlertController(title: "Error", message: "Too many favorites \nYou can only have 4 at a time", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated:true)
            }
        }
    }
    
    @IBAction func intradayBtnTap(_ sender: Any) {
        let sorted = self.stockValues5min.sorted{$0.0 < $1.0}
        self.chartData(data: sorted)
    }
    
    @IBAction func dailyBtnTap(_ sender: Any) {
        let sorted = self.stockValuesDaily.sorted{$0.0 < $1.0}
        self.chartData(data: sorted)
    }
    
    @IBAction func weeklyBtnTap(_ sender: Any) {
        let sorted = self.stockValuesWeekly.sorted{$0.0 < $1.0}
        self.chartData(data: sorted)
    }
    
    @IBAction func monthlyBtnTap(_ sender: Any) {
        let sorted = self.stockValuesMonthly.sorted{$0.0 < $1.0}
        self.chartData(data: sorted)
    }
}

extension stockInfoViewController {
    
    func getData(){
        NetworkManager.shared.getStockValues(stockSymbol: symbol, timeSeries: "INTRADAY") {values in
            self.stockValues5min = values
            let sorted = self.stockValues5min.sorted{$0.0 < $1.0}
            self.chartData(data: sorted)
        }
        NetworkManager.shared.getStockValues(stockSymbol: symbol, timeSeries: "DAILY") {values in
            self.stockValuesDaily = values
        }
        NetworkManager.shared.getStockValues(stockSymbol: symbol, timeSeries: "WEEKLY") {values in
            self.stockValuesWeekly = values
        }
        NetworkManager.shared.getStockValues(stockSymbol: symbol, timeSeries: "MONTHLY") {values in
            self.stockValuesMonthly = values
        }
    }
    
    func favorite(){
        FirebaseManager.shared.favoriteStockList{favorites in
            self.favoriteList = favorites
            self.favoriteCount = favorites.count
            if(self.favoriteList.keys.contains(self.symbol))
            {
                self.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.isFavorite = true
            }
        }
    }
    
    func chartData(data: [(String,String)]) {
        DispatchQueue.main.async {
            var entries = [ChartDataEntry]()
            for x in 0..<data.count {
                entries.append(ChartDataEntry(x: Double(x), y: Double(data[x].1) ?? 0))
            }
            
            let set = LineChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.material()
            set.circleHoleRadius = 0
            set.circleRadius = 2.2
            
            let data = LineChartData(dataSet: set)
            self.lineChart.data = data
        }
    }
}
