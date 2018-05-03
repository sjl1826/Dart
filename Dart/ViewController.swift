//
//  ViewController.swift
//  Dart
//
//  Created by Ryan Lee on 5/2/18.
//  Copyright © 2018 Samuel Lee. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    var dininghalls: [String]?
    @IBOutlet weak var answer: UILabel!
    
    @IBAction func chooseHall(_ sender: UIButton) {
        let random = Int(arc4random_uniform(UInt32(dininghalls!.count)))
        answer.text = "You should eat at " + dininghalls![random]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dininghalls = getData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
