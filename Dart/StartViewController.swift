//
//  StartViewController.swift
//  DartIt!
//
//  Created by Samuel J. Lee on 5/12/18.
//  Copyright © 2018 Samuel Lee. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var one: UITextField!
    @IBOutlet weak var two: UITextField!
    @IBOutlet weak var three: UITextField!
    @IBOutlet weak var four: UITextField!
    @IBOutlet weak var five: UITextField!
    @IBOutlet weak var six: UITextField!
    @IBOutlet weak var seven: UITextField!
    @IBOutlet weak var eight: UITextField!
    
    var arr = [String]()
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        checkString(str: one.text!)
        checkString(str: two.text!)
        checkString(str: three.text!)
        checkString(str: four.text!)
        checkString(str: five.text!)
        checkString(str: six.text!)
        checkString(str: seven.text!)
        checkString(str: eight.text!)
        let defaults = UserDefaults.standard
        defaults.set(arr, forKey: "key1")
        print("hello")
    }
    @IBAction func startButton(_ sender: Any) {
        print("start")
    }
    
    func checkString(str: String) {
        if(str != ""){
            arr.append(str)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
