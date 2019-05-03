//
//  StatisticsViewController.swift
//  MainCode
//
//  Created by Apple on 4/26/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var segmentsView: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var totalDistanceView: UIView!
    @IBOutlet weak var totalTimeView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalDistanceSquareView: UIView!
    @IBOutlet weak var averageSpeedSquareView: UIView!
    @IBOutlet weak var totalTimeSquareView: UIView!
    @IBOutlet weak var averageTimeSquareView: UIView!
    @IBOutlet weak var outOfRouteView: UIView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var realChart: LineChartView!
    @IBOutlet weak var realChartMonthly: LineChartView!
    
    
    var yNumbersOfAverageDistance: [Double] = [300,300,700,0,500,500,100,100,300,100,300]
    var yNumbersOfAverageTime: [Double] = [100,50,300,100,300,300,300,700,100,100,1000]
    
    var yNumbersOfAverageDistanceMonthly: [Double] = [300,300,700,0,500,500,100,100,300,100,300]
    var yNumbersOfAverageTimeMonthly: [Double] = [100,50,300,100,300,300,300,700,100,100,1000]
    
    var line1ChartEntry = [ChartDataEntry]()
    var line2ChartEntry = [ChartDataEntry]()
    
    var line1ChartEntryMonthly = [ChartDataEntry]()
    var line2ChartEntryMonthly = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realChart.chartDescription?.text = ""
        
        //Weekly Chart
        for i in 0..<yNumbersOfAverageDistance.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageDistance[i])
            line1ChartEntry.append(value)
        }
        
        for i in 0..<yNumbersOfAverageTime.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageTime[i])
            line2ChartEntry.append(value)
        }
        
        //Monthly Chart
        
        for i in 0..<yNumbersOfAverageDistanceMonthly.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageDistanceMonthly[i])
            line1ChartEntryMonthly.append(value)
        }
        
        for i in 0..<yNumbersOfAverageTimeMonthly.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageTimeMonthly[i])
            line2ChartEntryMonthly.append(value)
        }
        
        updateGraph()
        
    }
    
    func updateGraph() {
        //Weekly Chart
        let line1 = LineChartDataSet(entries: line1ChartEntry, label: "Average Distance")
        line1.colors = [NSUIColor(red: CGFloat(124)/255.0, green: CGFloat(205)/255.0, blue: CGFloat(209)/255.0, alpha: 1)]
        let line2 = LineChartDataSet(entries: line2ChartEntry, label: "Average Time")
        line2.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        realChart.data = data
        realChart.xAxis.drawAxisLineEnabled = false
        realChart.xAxis.drawGridLinesEnabled = false
        realChart.leftAxis.drawAxisLineEnabled = false
        realChart.leftAxis.drawGridLinesEnabled = false
        realChart.rightAxis.drawAxisLineEnabled = false
        realChart.rightAxis.drawGridLinesEnabled = false
        
        //Monthly Chart
        let line1Monthly = LineChartDataSet(entries: line1ChartEntryMonthly, label: "Average Distance")
        line1Monthly.colors = [NSUIColor(red: CGFloat(124)/255.0, green: CGFloat(205)/255.0, blue: CGFloat(209)/255.0, alpha: 1)]
        let line2Monthly = LineChartDataSet(entries: line2ChartEntryMonthly, label: "Average Time")
        line2Monthly.colors = [NSUIColor.blue]
        let dataMonthly = LineChartData()
        dataMonthly.addDataSet(line1Monthly)
        dataMonthly.addDataSet(line2Monthly)
        realChartMonthly.data = dataMonthly
    }
    
    //test
    
    @IBAction func segmentsAction(_ sender: UISegmentedControl) {
        if segmentsView.selectedSegmentIndex == 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if segmentsView.selectedSegmentIndex == 1 {
            scrollView.setContentOffset(CGPoint(x: 414, y: 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let w = scrollView.frame.size.width
        let page = scrollView.contentOffset.x / w
        //        print("\(page)")
        segmentsView.selectedSegmentIndex = Int(page)
        
//        let mainH = mainScrollView.frame.size.height
//        let mainPage = mainScrollView.contentOffset.y / mainH
//        print("\(mainPage)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.frame.origin.x += self.view.frame.size.width
        
//        compareView.frame.origin.x -= compareView.frame.origin.x
//        self.totalDistanceView.frame.origin.x -= self.view.frame.size.width
//        self.totalTimeView.frame.origin.x += self.view.frame.size.width
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Fire Animation
        showStatisticsView()
        showCompareView()
        showTotalDistanceView()
        showTotalTimeView()
        showDateLabel()
        showTotalDistanceAndTotalTime()
        showAverageSpeedAndAverageTime()
        showOutOfRouteView()
        showChartView()
    }
    
    func showStatisticsView() {
        UIView.animate(withDuration: 0.1) {
//            self.view.alpha = 1
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
    func showCompareView() {
        self.compareView.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.compareView.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showTotalDistanceView() {
        self.totalDistanceView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.totalDistanceView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showTotalTimeView() {
        self.totalTimeView.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.totalTimeView.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showDateLabel() {
        self.dateLabel.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.dateLabel.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showTotalDistanceAndTotalTime() {
        self.totalDistanceSquareView.frame.origin.x -= self.view.frame.size.width
        self.totalTimeSquareView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.totalDistanceSquareView.frame.origin.x += self.view.frame.size.width
            self.totalTimeSquareView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showAverageSpeedAndAverageTime() {
        self.averageSpeedSquareView.frame.origin.x -= self.view.frame.size.width
        self.averageTimeSquareView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.averageSpeedSquareView.frame.origin.x += self.view.frame.size.width
            self.averageTimeSquareView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showOutOfRouteView() {
        self.outOfRouteView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.outOfRouteView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showChartView() {
        self.chartView.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.9, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.chartView.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
