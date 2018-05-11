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
import UIView_Shake
import VariousViewsEffects


class ViewController: UIViewController, SpinWheelControlDataSource, SpinWheelControlDelegate {
    
    
    @IBOutlet weak var internetError: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var viesualView: UIVisualEffectView!
    
    @IBOutlet weak var empty: UILabel!
    
    let colorPalette: [UIColor] = [UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear]
    var dinings = [String]()
    
    func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
        let wedge = SpinWheelWedge()
        
        wedge.shape.fillColor = colorPalette[Int(index)].cgColor
        wedge.label.text = dinings[Int(index)]
        wedge.label.textColor = UIColor.black
        wedge.label.highlightedTextColor = UIColor.black
        wedge.isOpaque = true
        return wedge
    }
    
    
    var spinWheelControl:SpinWheelControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartButton.isHidden = true
        result.isHidden = true
        dinings = getData()
        if (dinings.count == 0) {
            empty.text = "Sorry, either no dining halls are open, OR"
            internetError.text = "You must be connected to the Internet!"
        }
        else {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        spinWheelControl = SpinWheelControl(frame: frame)
        spinWheelControl.addTarget(self, action: #selector(spinWheelDidChangeValue), for: UIControlEvents.valueChanged)
        
        spinWheelControl.dataSource = self
        spinWheelControl.reloadData()
        
        spinWheelControl.delegate = self
        
        self.view.addSubview(spinWheelControl)
        }
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
        self.view.shake(2, withDelta: 8, speed: 0.1)
        print(self.spinWheelControl.selectedIndex)
        result.text = dinings[self.spinWheelControl.selectedIndex] + "!!!"
        result.isHidden = false
        circle.isHidden = true
        spinWheelControl.isHidden = true
        restartButton.isHidden = false
        viesualView.breakGlass()
        
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
            let mainContent: Elements = try! doc.select("#main-content").select("div").select("h2 ~ div").select(".half-col, .full-col, .whole-col")
            
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
    
    @IBAction func reChoose(_ sender: Any) {
        self.viesualView?.alpha = 0
        self.viesualView?.isHidden = false
        
        UIView.animate(withDuration: 1, animations: {
            self.viesualView?.alpha = 1
        })
        circle.isHidden = false
        spinWheelControl.isHidden = false
        
    }
    
    
}
