//
//  LineChart.swift
//  BitTracker
//
//  Created by Rauan on 10/4/19.
//  Copyright © 2019 Rauan. All rights reserved.
//

import UIKit


// Я решил написать линейный график самостоятельно без сторонних библиотек, но он был создан на скорую руку и исключетельно под мои задачи(вышло так себе)
class LineChart : UIView {
    
   public var timeFilter : TimeFilter = .week {
        didSet {
            setupCoordinates()
            NotificationCenter.default.post(name: .hideInfo, object: nil)
        }
    }
    public var currencyValue : CurrencyValue = .KZT
    public var coordinates : [CGPoint] = []
    public var currencies : [Double] = [0,0,0,0,0,0,0]
    public var highestCurrency = 0.0
    private var lineView = UIView()
    private var xAxis = UIView()
    private var yAxis = UIView()
    private var shapeLayer : CALayer?
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = false
        setupView()
        setupCoordinates()
    }
    
    // Из данных по курсу валют создаем массив координат 
    func setupCoordinates() {
        coordinates = []
        for view in self.subviews {
            if view.frame.width == 10 {
            view.removeFromSuperview()
            }
        }
        let height = Double(self.frame.height)
        let yCoordinate = height / highestCurrency * 0.8
        switch timeFilter {
        case .week:
            let xCoordinate = (UIScreen.main.bounds.width - 30) / 7
            for i in 0...6 {
                coordinates.append(CGPoint(x: Double(xCoordinate) * Double(i) + 10, y: currencies.count == 7 ? (height - currencies[i] * yCoordinate) : -5))
                self.addDotView(point: CGPoint(x: Double(xCoordinate) * Double(i) + 10, y: currencies.count == 7 ? (height - currencies[i] * yCoordinate) : -5))
            }
            self.addLine()
           return
        case .month:
            let xCoordinate = (UIScreen.main.bounds.width - 30) / 4
             for i in 0...3 {
                coordinates.append(CGPoint(x: Double(xCoordinate) * Double(i) + 10, y: currencies.count == 4 ? (height - currencies[i] * yCoordinate) : -5))
                self.addDotView(point: CGPoint(x: Double(xCoordinate) * Double(i) + 10, y: currencies.count == 4 ? (height - currencies[i] * yCoordinate) : -5))
             }
             self.addLine()
            return
        case .year:
            let xCoordinate = (UIScreen.main.bounds.width - 30) / 12
             for i in 0...11 {
                 coordinates.append(CGPoint(x: Double(xCoordinate) * Double(i) + 10, y: currencies.count == 12 ? (height - currencies[i] * yCoordinate) : -5))
                self.addDotView(point: CGPoint(x: Double(xCoordinate) * Double(i) + 10, y: currencies.count == 12 ? (height - currencies[i] * yCoordinate) : -5))
             }
             self.addLine()
            return
        }
    }
    // Добавляем второстепенный UI, а также gestureRegognizers, для манипуляции с линейкой(lineView)
    func setupView() {
        lineView.frame = CGRect(x: self.frame.width / 2 - 1, y: 0, width: 1, height: self.frame.height)
        lineView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        xAxis.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
        yAxis.frame = CGRect(x: 0, y: self.bounds.maxY - 1, width: self.frame.width, height: 1)
        xAxis.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        yAxis.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.addSubview(xAxis)
        self.addSubview(yAxis)
        self.addSubview(lineView)
        self.layoutIfNeeded()
        self.layoutSubviews()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(lineViewMoved(gesture:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(lineViewMoved(gesture:)))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(panGesture)
    }
    // Добавляем точки для отображения данных на графике
    func addDotView(point: CGPoint) {
        let dotView = UIView()
        dotView.frame.origin.x = point.x - 5
        dotView.frame.origin.y = point.y - 5
        dotView.frame.size = CGSize(width: 10, height: 10)
        dotView.layer.cornerRadius = 5
        dotView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        dotView.layer.borderWidth = 0.5
        dotView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.addSubview(dotView)
    }
    // Добавляем линию графика как subLayer
    func addLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = currencyValue == .KZT ? UIColor(patternImage: #imageLiteral(resourceName: "024 Near Moon-1")).cgColor : currencyValue == .USD ? UIColor(patternImage: #imageLiteral(resourceName: "147 Smart Indigo")).cgColor : UIColor(patternImage: #imageLiteral(resourceName: "132 Solid Stone")).cgColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.lineWidth = 2.0
        
                if let oldShapeLayer = self.shapeLayer {
                    self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
                } else {
                    self.layer.addSublayer(shapeLayer)
                }
        layoutIfNeeded()
        layoutSubviews()
                self.shapeLayer = shapeLayer
    }
    // Создаем путь для линий графика
    func createPath() -> CGPath {
        let path = UIBezierPath()
        
        for (index, coordinate) in coordinates.enumerated() {
            if index == 0 {
                path.move(to: coordinate)
            } else {
                path.addLine(to: coordinate)
            }
        }
        path.stroke()
        return path.cgPath
    }
    
    
    // Отправляем нотификации если линия будет в зоне точек для отображения информации
    @objc func lineViewMoved(gesture: UIPanGestureRecognizer) {
        if gesture.location(in: self).x > 0 && gesture.location(in: self).x < self.frame.width {
        lineView.frame.origin.x = gesture.location(in: self).x
            for (index,coord) in coordinates.enumerated() {
                if coord.x  + 7 > lineView.frame.origin.x && coord.x - 7 < lineView.frame.origin.x {
                    NotificationCenter.default.post(name: .showInfo, object: index)
                    break
                } else {
                    NotificationCenter.default.post(name: .hideInfo, object: nil)
                }
            }
        }
    }
    
    
}
