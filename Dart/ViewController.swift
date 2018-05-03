//
//  ViewController.swift
//  Dart
//
//  Created by Ryan Lee on 5/2/18.
//  Copyright © 2018 Samuel Lee. All rights reserved.
//

import UIKit
import SwiftSoup
import SpinWheelControl


class ViewController: UIViewController, SpinWheelControlDataSource, SpinWheelControlDelegate {
    
    
    @IBOutlet weak var result: UILabel!
    
    let colorPalette: [UIColor] = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.green, UIColor.magenta, UIColor.purple, UIColor.cyan, UIColor.orange]
    var dinings = [String]()
    
    func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
        let wedge = SpinWheelWedge()
        
        wedge.shape.fillColor = colorPalette[Int(index)].cgColor
        wedge.label.text = dinings[Int(index)]
        wedge.label.textColor = UIColor.black
        wedge.isOpaque = true
        return wedge
    }
    
    
    var spinWheelControl:SpinWheelControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dinings = getData()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        spinWheelControl = SpinWheelControl(frame: frame)
        spinWheelControl.addTarget(self, action: #selector(spinWheelDidChangeValue), for: UIControlEvents.valueChanged)
        
        spinWheelControl.dataSource = self
        spinWheelControl.reloadData()
        
        spinWheelControl.delegate = self
        
        self.view.addSubview(spinWheelControl)
    }
    
    
    func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt {
        return UInt(getData().count)
    }
    
    
    //Target was added in viewDidLoad for the valueChanged UIControlEvent
    @objc func spinWheelDidChangeValue(sender: AnyObject) {
        print("Value changed to " + String(self.spinWheelControl.selectedIndex))
    }
    
    
    func spinWheelDidEndDecelerating(spinWheel: SpinWheelControl) {
        print("The spin wheel did end decelerating.")
    }
    
    
    func spinWheelDidRotateByRadians(radians: Radians) {
        print("The wheel did rotate this many radians - " + String(describing: radians))
    }
    
    func getData() -> Array<String> {
        let myURLString = "http://menu.dining.ucla.edu"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return [String]()
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            let doc: Document = try! SwiftSoup.parse(myHTMLString)
            let mainContent: Elements = try! doc.select("#main-content").select("div").select("h2 ~ div").select(".half-col,.whole-col")
            
            var food = [String]()
            
            for div: Element in mainContent.array() {
                let p: Elements = try! div.select(".unit-name")
                for thing: Element in p.array() {
                    let name: String = try! thing.text()
                    food.append(name)
                    print(name)
                }
            }
            
            return food
        } catch let error {
            print("Error: \(error)")
        }
        return [String]()
    }
}
