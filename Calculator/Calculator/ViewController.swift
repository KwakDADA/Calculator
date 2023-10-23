//
//  ViewController.swift
//  Calculator
//
//  Created by 곽다은 on 10/22/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var display: UILabel!
    var currNum = "0"
    var savedNum = "0"
    var currOperation = ""
    var prevOperation = ""
    
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var sumButton: UIButton!
    @IBOutlet var subButton: UIButton!
    @IBOutlet var mulButton: UIButton!
    @IBOutlet var divButton: UIButton!
    @IBOutlet var eqButton: UIButton!
    
    var startOver = true
    var equalSignTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }
    
    func digit(num: String) {
        guard !num.contains(".") && num.count > 3 else {
            display.text = num
            return
        }
        var temp = ""
        let numberOfTop = num.count % 3
        for i in 0..<num.count {
            let c = Array(num)[i]
            if c.isNumber {
                temp.append(c)
            } else { continue }
            
            if i+1 == numberOfTop || ((i+1) % 3 == numberOfTop && i != num.count-1) {
                temp += ","
            }
        }
        display.text = temp
    }
    
    func calcButtonInit() {
        sumButton.backgroundColor = .systemOrange
        subButton.backgroundColor = .systemOrange
        mulButton.backgroundColor = .systemOrange
        divButton.backgroundColor = .systemOrange
        
        sumButton.titleLabel?.tintColor = .white
        subButton.titleLabel?.tintColor = .white
        mulButton.titleLabel?.tintColor = .white
        divButton.titleLabel?.tintColor = .white
    }
    
    func buttonSelected(button: UIButton) {
        button.backgroundColor = .white
        button.titleLabel?.tintColor = .orange
    }
    
    func allClear() {
        startOver = true
        equalSignTapped = false
        currNum = "0"
        display.text = "0"
        prevOperation = ""
        savedNum = "0"
        calcButtonInit()
    }
    
    @IBAction func numericButtonTapped(_ sender: UIButton) {
        clearButton.setTitle("C", for: .normal)
        calcButtonInit()
        if equalSignTapped { allClear() }
        guard currNum.filter({$0.isNumber}).count < 9 else { return }
        
        if currNum == "0" {
            currNum = (sender.titleLabel?.text)!
        } else {
            currNum.append((sender.titleLabel?.text)!)
        }
        digit(num: currNum)
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        if currNum != "0" {
            clearButton.setTitle("AC", for: .normal)
            currNum = "0"
            digit(num: currNum)
            switch currOperation {
            case "+": buttonSelected(button: sumButton)
            case "-": buttonSelected(button: subButton)
            case "×": buttonSelected(button: mulButton)
            case "÷": buttonSelected(button: divButton)
            default: break
            }
        } else {
            allClear()
        }
    }
    
    @IBAction func positiveNegativeButtonTapped(_ sender: UIButton) {
        if currNum.contains(".") {
            currNum = String(Double(currNum)! * (-1))
        } else {
            currNum = String(Int(currNum)! * (-1))
        }
        digit(num: currNum)
    }
    
    @IBAction func percentButtonTapped(_ sender: UIButton) {
        currNum = String(Double(currNum)! / 100)
        digit(num: currNum)
    }
    
    
    func operate(num1: String, num2: String, op: String) {
        var ans = 0.0
        switch op {
        case "+": ans = Double(num1)! + Double(num2)!
        case "-": ans = Double(num1)! - Double(num2)!
        case "×": ans = Double(num1)! * Double(num2)!
        case "÷": ans = Double(num1)! / Double(num2)!
        default: break
        }
        savedNum = ans == Double(Int(ans)) ? String(Int(ans)) : String(round(ans*100000000)/100000000)
    }
    
    @IBAction func calcButtonTapped(_ sender: UIButton) {
        calcButtonInit()
        buttonSelected(button: sender)
        
        currOperation = sender.titleLabel!.text!
        
//        guard currNum != "0" else {
//            prevOperation = currOperation
//            return
//        }
        
        if startOver {
            startOver = false
        } else {
            operate(num1: savedNum, num2: currNum, op: prevOperation)
        }
        
        prevOperation = currOperation
        if savedNum == "0" {
            savedNum = currNum
            digit(num: currNum)
        } else {
            digit(num: savedNum)
        }
        currNum = "0"
    }
    
    @IBAction func eqButtonTapped(_ sender: UIButton) {
        print(savedNum, currNum, prevOperation, currOperation)
        calcButtonInit()
        equalSignTapped = true
        guard savedNum != "0" || prevOperation != "" else { return }
        
        if currNum == "0" {
            currNum = savedNum
            operate(num1: currNum, num2: currNum, op: prevOperation)
        } else {
            operate(num1: savedNum, num2: currNum, op: prevOperation)
        }
        
        print(savedNum, currNum)
        digit(num: savedNum)
    }
}
