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
    @IBOutlet var posNegButton: UIButton!
    @IBOutlet var percentButton: UIButton!
    @IBOutlet var sumButton: UIButton!
    @IBOutlet var subButton: UIButton!
    @IBOutlet var mulButton: UIButton!
    @IBOutlet var divButton: UIButton!
    @IBOutlet var eqButton: UIButton!
    @IBOutlet var oneButton: UIButton!
    @IBOutlet var twoButton: UIButton!
    @IBOutlet var threeButton: UIButton!
    @IBOutlet var fourButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    @IBOutlet var sixButton: UIButton!
    @IBOutlet var sevenButton: UIButton!
    @IBOutlet var eightButton: UIButton!
    @IBOutlet var nineButton: UIButton!
    @IBOutlet var zeroButton: UIButton!
    @IBOutlet var dotButton: UIButton!
    
    var startOver = true
    var equalSignTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        // make the button shape rounded
        clearButton.layer.cornerRadius = 37.5
        posNegButton.layer.cornerRadius = 37.5
        percentButton.layer.cornerRadius = 37.5
        sumButton.layer.cornerRadius = 37.5
        subButton.layer.cornerRadius = 37.5
        mulButton.layer.cornerRadius = 37.5
        divButton.layer.cornerRadius = 37.5
        eqButton.layer.cornerRadius = 37.5
        oneButton.layer.cornerRadius = 37.5
        twoButton.layer.cornerRadius = 37.5
        threeButton.layer.cornerRadius = 37.5
        fourButton.layer.cornerRadius = 37.5
        fiveButton.layer.cornerRadius = 37.5
        sixButton.layer.cornerRadius = 37.5
        sevenButton.layer.cornerRadius = 37.5
        eightButton.layer.cornerRadius = 37.5
        nineButton.layer.cornerRadius = 37.5
        zeroButton.layer.cornerRadius = 37.5
        dotButton.layer.cornerRadius = 37.5
    }
    
    func digit(num: String) {
        guard num != "오류" else {
            display.text = "오류"
            return
        }
        
        let integer = num.split(separator: ".")[0]
        var pointNumber: String?
        if num.split(separator: ".").count > 1 {
            pointNumber = "." + num.split(separator: ".")[1]
        } else if num.contains(".") {
            pointNumber = "."
        }
        
        var temp = ""
        let numberOfTop = integer.count % 3
        for i in 0..<integer.count {
            let c = Array(integer)[i]
            if c.isNumber || c == "-" {
                temp.append(c)
            } else { continue }
            
            if integer.count > 3 && (i+1 == numberOfTop || ((i+1) % 3 == numberOfTop && i != integer.count-1)) {
                temp += ","
            }
        }
        display.text = temp + (pointNumber ?? "")
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
        clearButton.titleLabel!.text = "C"
        clearButton.titleLabel?.textAlignment = .center
        calcButtonInit()
        if equalSignTapped { allClear() }
        guard currNum.filter({$0.isNumber}).count < 9 else { return }
        
        if currNum == "0" && sender != dotButton {
            currNum = (sender.titleLabel?.text)!
        } else {
            currNum.append((sender.titleLabel?.text)!)
        }
        digit(num: currNum)
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        if currNum != "0" {
            clearButton.titleLabel!.text = "AC"
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
        print(num1, op, num2)
        if num1 == "오류" || (op == "÷" && num2 == "0") {
            savedNum = "오류"
            return
        }
        
        var ans = 0.0
        switch op {
        case "+": 
            ans = Double(num1)! + Double(num2)!
        case "-":
            ans = Double(num1)! - Double(num2)!
        case "×":
            ans = Double(num1)! * Double(num2)!
        case "÷":
            guard num2 != "0" else {
                savedNum = "오류"
                return
            }
            ans = Double(num1)! / Double(num2)!
        default: break
        }
        savedNum = ans == Double(Int(ans)) ? String(Int(ans)) : String(round(ans*100000000)/100000000)
    }
    
    @IBAction func calcButtonTapped(_ sender: UIButton) {
        calcButtonInit()
        buttonSelected(button: sender)
        
        currOperation = sender.titleLabel!.text!
        
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
        calcButtonInit()
        equalSignTapped = true
        guard savedNum != "0" || prevOperation != "" else { return }
        
        if currNum == "0" && display.text != "0" {
            currNum = savedNum
        }
        
        operate(num1: savedNum, num2: currNum, op: prevOperation)
        digit(num: savedNum)
    }
}
