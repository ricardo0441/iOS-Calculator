//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Ricardo Rodriguez on 10/6/23.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Outles
    
//    Result
    @IBOutlet weak var ResultLabel: UILabel!
    
//    Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
//    Operators
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    @IBOutlet weak var operatorAdditions: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    
    //MARK: - Variables
    private var total: Double = 0                     //total
    private var temp: Double = 0                     // valor por pantalla
    private var operating = false                   // Indicar si se ha seleccionado un indicador
    private var decimal = false                     // Indicar si el valor es decimal
    private var operation: OperationType = .none    // Opeacion actual
    
    //MARK: - Constantes
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    
    private let kTotal = "total"
    
    private enum OperationType {
        case none, addition, substraction, multiplication, division, percent
    }
    
//    Formateo de valores auxiliares
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let local =  Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = local.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        
        return formatter
    }()
    
    //    Formateo de valores Totales auxiliares
        private let auxTotalFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.groupingSeparator = ""
            formatter.decimalSeparator = ""
            formatter.numberStyle = .decimal
            formatter.maximumIntegerDigits = 100
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 100
            
            
            return formatter
        }()
    
//    formateo de valores por patalla por defecto
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale =  Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumIntegerDigits = 0
        formatter.maximumFractionDigits = 8
        
        return formatter
    }()
    
//    Formateo de valores por pantalla en formato cientifico
    private let printScientificFormatter: NumberFormatter  = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        
        return formatter
    }()
    
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        UI
                number0.round()
                number1.round()
                number2.round()
                number3.round()
                number4.round()
                number5.round()
                number6.round()
                number7.round()
                number8.round()
                number9.round()
                numberDecimal.round()
                
                operatorAC.round()
                operatorPlusMinus.round()
                operatorPercent.round()
                operatorResult.round()
                operatorMultiplication.round()
                operatorDivision.round()
                operatorAdditions.round()
                operatorSubstraction.round()
    }
    
    //MARK: - Button Actions
    
    @IBAction func operationACAction(_ sender: UIButton) {
        
        clear()
        
        sender.shine()
        
    }
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        
        temp *= (-1)
        ResultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
        
    }
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        
        if !(operation == .percent) {
            result()
            
        }
        operating = true
        operation = .percent
        result()
        sender.shine()
        
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        
        result()
        sender.shine()
        
    }
    @IBAction func operatorAdditionsAction(_ sender: UIButton) {
        
        if !(operation == .none) {
            result()
        }

        operating = true
        operation = .addition
        sender.selectedOperation(true)
        
        sender.shine()
        
    }
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        
        if !(operation == .none) {
            result()
        }
        
        operating = true
        operation = .substraction
        sender.selectedOperation(true)
        
        sender.shine()
        
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        
        if !(operation == .none) {
            result()
        }
        
        operating = true
        operation = .multiplication
        sender.selectedOperation(true)
        
        sender.shine()
        
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        
        if !(operation == .none) {
            result()
        }
        
        operating = true
        operation = .division
        sender.selectedOperation(true)
        
        sender.shine()
        
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        
        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        ResultLabel.text = ResultLabel.text! + kDecimalSeparator
        decimal = true
        
        selectVisualOperation()
        
        sender.shine()
        
    }
    
    @IBAction func numberActions(_ sender: UIButton) {
        
        operatorAC.setTitle("C", for: .normal)
        
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!

        if !operating && currentTemp.count >= kMaxLength {
            return
        }
        
//        validar si se esta  operando
        if operating {
            total = total == 0 ? temp : total
            ResultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
//        hemos seleccionado decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        ResultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        
        sender.shine()
    }
    
//    Limpia los valores
    private func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if !(temp == 0) {
            temp = 0
            ResultLabel.text = "0"
            
        } else {
            total = 0
            result()
        }
    }
    
//    Obtiene el resultado final
    private func result() {
        
        switch operation {
        case .none:
//            No se realizada ninguna operacion
           
            break
        case .addition:
            
            total += temp
            break
        case .substraction:
            
            total -= temp
            break
        case .multiplication:
            
            total *= temp
            break
        case .division:
            
            total /= temp
            
            if String(total) == "nan" {
                total = 0
            }
            
            break
        case .percent:
            
            temp = temp / 100
            total = temp
            
            break
        }
        
//        Formateo en pantalla
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            ResultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            ResultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL -> \(total)")
    }
    
//    Muestra de forma visual la operacion realizada
    private func selectVisualOperation() {
        if !operating {
            
//            Sin operar
            
            operatorAdditions.selectedOperation(false)
            operatorSubstraction.selectedOperation(false)
            operatorMultiplication.selectedOperation(false)
            operatorDivision.selectedOperation(false)
            
        } else {
            
//            Operando
            
            switch operation {
            case .none, .percent:
                
                operatorAdditions.selectedOperation(false)
                operatorSubstraction.selectedOperation(false)
                operatorMultiplication.selectedOperation(false)
                operatorDivision.selectedOperation(false)
                
                break
            case .addition:
                
                operatorAdditions.selectedOperation(true)
                operatorSubstraction.selectedOperation(false)
                operatorMultiplication.selectedOperation(false)
                operatorDivision.selectedOperation(false)
                
                break
            case .substraction:
                
                operatorAdditions.selectedOperation(false)
                operatorSubstraction.selectedOperation(true)
                operatorMultiplication.selectedOperation(false)
                operatorDivision.selectedOperation(false)
                
                break
            case .multiplication:
                
                operatorAdditions.selectedOperation(false)
                operatorSubstraction.selectedOperation(false)
                operatorMultiplication.selectedOperation(true)
                operatorDivision.selectedOperation(false)
                
                break
            case .division:
                
                operatorAdditions.selectedOperation(false)
                operatorSubstraction.selectedOperation(false)
                operatorMultiplication.selectedOperation(false)
                operatorDivision.selectedOperation(true)
                
                break
            }
        }
    }

}
