//
//  NewCardTableVC.swift
//  SavePass
//
//  Created by Виталий Охрименко on 17/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import RealmSwift

class NewCardTableVC: UITableViewController {

    let realm = try! Realm()
    var selectedCard: CardList?
    let expiryDatePicker = MonthYearPickerView()
    var isDeletedVisible: Bool!
    
    @IBOutlet weak var nameOfCard: UITextField!
    @IBOutlet weak var nameOfOwner: UITextField!
    @IBOutlet weak var numberOfCard: UITextField!
    @IBOutlet weak var dateOfexpiry: UITextField!
    @IBOutlet weak var cvNumber: UITextField!
    @IBOutlet weak var viewForChangeColor: UIView!
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let nameCard = nameOfCard.text,
            let ownerName = nameOfOwner.text,
            let cardNumber = numberOfCard.text,
            let dateExpiry = dateOfexpiry.text,
            let cvNumber = cvNumber.text
            else { return }
        
        let card = CardList()
        
        if selectedCard == nil {
            card.cardID = DBManager.sharedInstance.getDataFromCardList().count
        }
        else {
            guard let cardID = selectedCard?.cardID else { return }
            card.cardID = cardID
        }
        card.cardName = nameCard
        card.ownerName = ownerName
        card.cardNumber = cardNumber
        card.dateExpiry = dateExpiry
        card.cvNumber = cvNumber
        card.cardColor = viewForChangeColor.backgroundColor!.hexString
        
        
        DBManager.sharedInstance.addDataCardList(object: card)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet)
        
        alert.addColorPicker(color: viewForChangeColor.backgroundColor!) { color in Log(color)
            self.viewForChangeColor.backgroundColor = color
        }
        alert.addAction(title: "Отмена", style: .cancel)
        alert.show()
    }
    
    @IBAction func deleteAccountData(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStartScreen()
        self.setupUI()
        self.hideKeyboardWhenTappedAround()
        self.configureTextFields()

    }
    
    private func configureStartScreen() {
        if selectedCard != nil {
            
            nameOfCard.text = selectedCard?.cardName
            nameOfOwner.text = selectedCard?.ownerName
            numberOfCard.text = selectedCard?.cardNumber
            dateOfexpiry.text = selectedCard?.dateExpiry
            cvNumber.text = selectedCard?.cvNumber
            let color = selectedCard?.cardColor
            
            self.viewForChangeColor.backgroundColor = UIColor(hexString: color!)
        }
    }

    
    private func setupUI() {
        viewForChangeColor.layer.cornerRadius = 20
        viewForChangeColor.clipsToBounds = true
    }
    
    private func configureTextFields() {
        // dateOfexpiry
        dateOfexpiry.inputView = expiryDatePicker
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            
            let string = String(format: "%02d/%d", month, year % 100)
            self.dateOfexpiry.text = string
        }
        
        [numberOfCard, cvNumber].forEach { textField in
            textField?.keyboardType = .numberPad
            textField?.delegate = self
        }
    }
}

extension NewCardTableVC {
    
    // MARK: - Table View data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                print ("alala")
            default:
                break
            }
        default:
            break
        }
    }
    
}

extension NewCardTableVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
            
            if numberOfCard == textField {
                textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
                return false
            }
            if cvNumber == textField {
                textField.text = lastText.format("nnn", oldString: text)
                return false
            }
        }
        return true
    }
}


