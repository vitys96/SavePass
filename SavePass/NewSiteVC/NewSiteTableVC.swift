//
//  NewSiteTableVC.swift
//  Passwd
//
//  Created by Виталий Охрименко on 20/02/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import RealmSwift

class NewSiteTableVC: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedSite: SiteList?
    
    @IBOutlet weak var siteImageView: UIImageView!
    
    @IBOutlet weak var siteName: UITextField!
    
    @IBOutlet weak var siteAddress: UITextField!
    
    @IBOutlet weak var siteLogin: UITextField!
    
    @IBOutlet weak var sitePassword: UITextField!
    
    @IBOutlet weak var copySiteLoginOutlet: UIButton!
    @IBOutlet weak var copySitePasswordOutlet: UIButton!
    @IBOutlet weak var showHidePassword: UIButton!
    
    var isDeletedVisible: Bool!
    var toggle = true
    
    var imageViewString = ""
    
    
    @IBAction func cancelBarButtonItem(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func saveBarButtonItem(_ sender: Any) {
        
        guard let siteNameLabel = siteName.text, !siteNameLabel.isEmpty else { return }
        guard let siteAddress = siteAddress.text, !siteNameLabel.isEmpty else { return }
        guard let siteLogin = siteLogin.text, !siteLogin.isEmpty else { return }
        guard let sitePassword = sitePassword.text, !sitePassword.isEmpty else { return }
        
        if selectedSite == nil {
            do {
                let all = SiteList(value: [siteNameLabel, siteAddress, siteLogin, sitePassword ])
                try realm.write {
                    realm.add(all)
                }
            }
            catch {
                print ("alert")
            }
        }
        else {
            let sites = realm.objects(SiteList.self)
            try! realm.write {
                sites.setValue(siteNameLabel, forKey: "siteName")
                sites.setValue(siteAddress, forKey: "siteAddress")
                sites.setValue(siteLogin, forKey: "siteLogin")
                sites.setValue(sitePassword, forKey: "sitePassword")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func LoginSiteCopyButton(_ sender: Any) {
        copyTextInTextField(your: siteLogin)
    }
    
    @IBAction func PasswordSiteCopyButton(_ sender: Any) {
        copyTextInTextField(your: sitePassword)
    }
    @IBAction func showHidePasswd(_ sender: UIButton) {
        
        switchShowHidePasButton(showHideButton: showHidePassword, variable: &toggle)
    }
    
    
    @IBAction func DeleteSiteData(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Удалить учетные данные", message: "Удаленные данные нельзя восставить.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            
            try! self.realm.write {
                self.realm.delete(self.selectedSite!)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        siteImageView.image = UIImage(named: imageViewString)
        
        siteName.text = selectedSite?.siteName
        siteAddress.text = selectedSite?.siteAddress
        siteLogin.text = selectedSite?.siteLogin
        sitePassword.text = selectedSite?.sitePassword
        
        siteLogin.addTarget(self, action: #selector(logPasTextFieldDidChanged), for: .editingChanged)
        sitePassword.addTarget(self, action: #selector(logPasTextFieldDidChanged), for: .editingChanged)
        
    }
    
    @objc private func logPasTextFieldDidChanged() {
        
        guard let login = siteLogin.text else { return }
        if !(login.isEmpty) {
            enableCopyButton(copyButton: copySiteLoginOutlet, enabled: true)
        }
        else {
            enableCopyButton(copyButton: copySiteLoginOutlet, enabled: false)
        }
        
        guard let password = sitePassword.text else { return }
        if !(password.isEmpty) {
            enableCopyButton(copyButton: copySitePasswordOutlet, enabled: true)
            enableCopyButton(copyButton: showHidePassword, enabled: true)
        }
        else {
            enableCopyButton(copyButton: copySitePasswordOutlet, enabled: false)
            enableCopyButton(copyButton: showHidePassword, enabled: false)
        }
    }
    
    private func enableCopyButton(copyButton: UIButton, enabled: Bool) {
        
        if enabled {
            copyButton.alpha = 1.0
            copyButton.isEnabled = true
            
        } else {
            copyButton.alpha = 0.2
            copyButton.isEnabled = false
        }
    }
    
    private func switchShowHidePasButton(showHideButton: UIButton, variable: inout Bool){

        if variable {
            showHideButton.setImage(UIImage(named: "invisible"), for: .normal)
            showHideButton.setTitleColor(.blue, for: .normal)
            sitePassword.isSecureTextEntry = false
        }

        else {
            showHideButton.setImage(UIImage(named: "visible"), for: .normal)
            sitePassword.isSecureTextEntry = true
        }
        variable = !variable
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let label = UILabel()
    //        label.backgroundColor = UIColor(hexValue: "#e0e0e0", alpha: 1.0)
    //        label.text = sections[section]
    //
    //        return label
    //    }
    //
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 60
    //    }
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
