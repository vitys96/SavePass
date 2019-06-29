//
//  NewCardTableVC.swift
//  SavePass
//
//  Created by Виталий Охрименко on 17/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import RealmSwift
import PayCardsRecognizer

class NewCardTableVC: UITableViewController {

    let realm = try! Realm()
    var selectedCard: CardList?
    let expiryDatePicker = MonthYearPickerView()
    var isDeletedVisible: Bool!
    var result: PayCardsRecognizerResult?
    
    @IBOutlet weak var saveCardButton: UIBarButtonItem!
    
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
    @IBAction func deleteAccountData(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Удалить учетные данные", message: "Удаленные данные нельзя восставить.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            
            guard let selectCard = self.selectedCard else { return }
            DBManager.sharedInstance.deleteCardFromDb(object: selectCard)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        self.colorPicker()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameOfOwner.text = result?.recognizedHolderName
        numberOfCard.text = result?.recognizedNumber?.format("nnnn nnnn nnnn nnnn", oldString: "")
        if let month = result?.recognizedExpireDateMonth, let year = result?.recognizedExpireDateYear {
            dateOfexpiry.text = String(format: "%@/%@", month, year)
        }
        
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
        
        [nameOfCard, nameOfOwner].forEach { (textField) in
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        [dateOfexpiry, numberOfCard, cvNumber].forEach { (textField) in
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewForChangeColorTapped))
        tap.numberOfTapsRequired = 1
        viewForChangeColor.addGestureRecognizer(tap)
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
        
        
        [numberOfCard, cvNumber, nameOfCard, nameOfOwner].forEach { textField in
            textField?.delegate = self
        }
        numberOfCard.keyboardType = .numberPad
        cvNumber.keyboardType = .numberPad
    }
    
    private func colorPicker() {
        let alert = UIAlertController(style: .actionSheet)
        
        alert.addColorPicker(color: viewForChangeColor.backgroundColor!) { color in Log(color)
            self.viewForChangeColor.backgroundColor = color
            self.saveCardButton.isEnabled = true
        }
        alert.addAction(title: "Отмена", style: .cancel)
        alert.show()
    }
    
    @objc private func viewForChangeColorTapped() {
        self.colorPicker()
    }
    
    @objc private func textFieldDidChange() {
        guard
            let cardName = nameOfCard.text,
            let ownerName = nameOfOwner.text,
            let numberCard = numberOfCard.text,
            let dateExp = dateOfexpiry.text,
            let cv = cvNumber.text
            
            else { return }
        
        if !cardName.isEmpty && !ownerName.isEmpty && !numberCard.isEmpty && !dateExp.isEmpty && !cv.isEmpty {
            self.saveCardButton.isEnabled = true
        } else {
            self.saveCardButton.isEnabled = false
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
            return selectedCard == nil ? 0 : 1
        default:
            return 0
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
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                
                return updatedText.count <= 3
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.nameOfCard.resignFirstResponder()
        self.nameOfOwner.resignFirstResponder()
        return true;
    }
}


