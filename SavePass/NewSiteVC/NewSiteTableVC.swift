//
//  NewSiteTableVC.swift
//  Passwd
//
//  Created by Виталий Охрименко on 20/02/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
//print(defaultURL)

import UIKit
import RealmSwift

class NewSiteTableVC: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedSite: SiteList?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var siteImageView: UIImageView!
    @IBOutlet weak var siteName: UITextField!
    @IBOutlet weak var siteAddress: UITextField!
    @IBOutlet weak var siteLogin: UITextField!
    @IBOutlet weak var sitePassword: UITextField!
    
    @IBOutlet weak var copySiteLoginOutlet: UIButton!
    @IBOutlet weak var copySitePasswordOutlet: UIButton!
    @IBOutlet weak var showHidePassword: UIButton!
    @IBOutlet weak var notesOutlet: UITextView!
    
    var isDeletedVisible: Bool!
    var toggle = true
    var imageViewString = String()
    var nameOfSiteString = String()
    var siteAddressString = String()
    
    
    @IBAction func cancelBarButtonItem(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func saveBarButtonItem(_ sender: Any) {
        
        guard let siteNameLabel = siteName.text,
            let siteAddress = siteAddress.text,
            let siteLogin = siteLogin.text,
            let sitePassword = sitePassword.text,
            let imageData = siteImageView.image?.pngData()
            else { return }
        
        let site = SiteList()
        
        if selectedSite == nil {
            site.siteID = DBManager.sharedInstance.getDataFromSiteList().count
        }
        else {
            guard let siteID = selectedSite?.siteID else { return }
            site.siteID = siteID
        }
        site.siteName = siteNameLabel
        site.siteAddress = siteAddress
        site.siteLogin = siteLogin
        site.sitePassword = sitePassword
        site.siteImageView = imageData
        site.notes = notesOutlet.text
        
        DBManager.sharedInstance.addDataSiteList(object: site)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - Copy/Show buttons
    
    @IBAction func loginSiteCopyButton(_ sender: Any) {
        copyTextInTextField(your: siteLogin)
    }
    
    @IBAction func passwordSiteCopyButton(_ sender: Any) {
        copyTextInTextField(your: sitePassword)
    }
    
    @IBAction func showHidePasswd(_ sender: UIButton) {
        switchShowHidePasButton(showHideButton: showHidePassword, securityTextEntry: sitePassword, variable: &toggle)
    }
    
    // MARK: - Dele site from Realm
    @IBAction func deleteSiteData(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Удалить учетные данные", message: "Удаленные данные нельзя восставить.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            
            
            guard let selectSite = self.selectedSite else { return }
            DBManager.sharedInstance.deleteSiteFromDb(object: selectSite)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configStartScreen()
    }
    
    
    
    // MARK: - Configure Start Screen
    private func configStartScreen() {
        
        [siteName, siteAddress, siteLogin, sitePassword].forEach { (textfield) in
            textfield?.addTarget(self, action: #selector(logPasTextFieldDidChanged), for: .editingChanged)
        }
        if selectedSite == nil {
            siteImageView.image = UIImage(named: imageViewString)
            siteName.text = siteAddressString.isEmpty ? "" : nameOfSiteString
            siteAddress.text = siteAddressString
        }
        else {
            enableCopyButton(copyButton: copySiteLoginOutlet, enabled: true)
            enableCopyButton(copyButton: copySitePasswordOutlet, enabled: true)
            enableCopyButton(copyButton: showHidePassword, enabled: true)
            
            
            siteName.text = selectedSite?.siteName
            siteAddress.text = selectedSite?.siteAddress
            siteLogin.text = selectedSite?.siteLogin
            sitePassword.text = selectedSite?.sitePassword
            guard let imageData = selectedSite?.siteImageView else { return }
            siteImageView.image = UIImage(data: imageData)
            notesOutlet.text = selectedSite?.notes
        }
        [siteName, siteAddress, siteLogin, sitePassword].forEach { (textField) in
            textField?.delegate = self
        }
        
    }
    
    @objc private func logPasTextFieldDidChanged() {
        
        guard let login = siteLogin.text else { return }
        if !login.isEmpty {
            enableCopyButton(copyButton: copySiteLoginOutlet, enabled: true)
        }
        else {
            enableCopyButton(copyButton: copySiteLoginOutlet, enabled: false)
        }
        
        guard let password = sitePassword.text else { return }
        if !password.isEmpty {
            enableCopyButton(copyButton: copySitePasswordOutlet, enabled: true)
            enableCopyButton(copyButton: showHidePassword, enabled: true)
        }
        else {
            enableCopyButton(copyButton: copySitePasswordOutlet, enabled: false)
            enableCopyButton(copyButton: showHidePassword, enabled: false)
        }
        guard let siteNameLabel = siteName.text else { return }
        if !login.isEmpty && !password.isEmpty && !siteNameLabel.isEmpty {
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
        
    }
    
    private func enableCopyButton(copyButton: UIButton, enabled: Bool) {
        
        if enabled {
            copyButton.alpha = 0.6
            copyButton.isEnabled = true
            
        } else {
            copyButton.alpha = 0.2
            copyButton.isEnabled = false
        }
    }
}

extension NewSiteTableVC {
    
    // MARK: - Table View data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30.0
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
            return 4
        case 2:
            return 1
        case 3:
            guard let _ = isDeletedVisible else { return 0 }
            return 1
        default:
            break
        }
        return 0
    }
    
    // MARK: - Table View delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NewSiteTableVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case siteName:
            siteAddress.becomeFirstResponder()
        case siteAddress:
            siteLogin.becomeFirstResponder()
        case siteLogin:
            sitePassword.becomeFirstResponder()
        case sitePassword:
            sitePassword.resignFirstResponder()
        default:
            break
        }
        return false
    }
}
