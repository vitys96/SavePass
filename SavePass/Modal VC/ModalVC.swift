import UIKit
import SPStorkController
import SparrowKit
import RealmSwift

protocol ModalVCDelegate {
    func didChangeInfo()
    func reloadData()
}

class ModalVC: UIViewController {
    
    let realm = try! Realm()
    
    var selectedSite: SiteList?
    
    var delegate: ModalVCDelegate?
    var loginLabel = ""
    var passwordLabel = ""
    var titleLabelModal = String()
    var toggle = true
    
    let navBar = SPFakeBarView(style: .stork)
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    
    lazy var loginLabelText: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var siteLoginTextField: UITextField = {
        let siteLabel = UITextField()
        siteLabel.isEnabled = false
        siteLabel.textColor = .black
        siteLabel.text = loginLabel
        return siteLabel
    }()
    
    lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hexValue: "#dbdbdb", alpha: 1.0)
        return separator
    }()
    
    lazy var passwordLabelText: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy var sitePasswordTextField: UITextField = {
        let passwdLabel = UITextField()
        passwdLabel.isEnabled = false
        passwdLabel.isSecureTextEntry = true
        passwdLabel.textColor = .black
        passwdLabel.text = passwordLabel
        return passwdLabel
    }()
    
    lazy var separatorTwo: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hexValue: "#dbdbdb", alpha: 1.0)
        return separator
    }()
    
    lazy var copyButton: UIButton = {
        let copy = UIButton()
        copy.setBackgroundImage(UIImage(named: "copyImage"), for: .normal)
        copy.contentMode = .scaleAspectFit
        copy.addTarget(self, action: #selector(copyLoginText), for: .touchUpInside)
        
        return copy
    }()
    
    lazy var copyButtonTwo: UIButton = {
        let copy = UIButton()
        copy.setBackgroundImage(UIImage(named: "copyImage"), for: .normal)
        copy.contentMode = .scaleAspectFit
        copy.addTarget(self, action: #selector(copyPasswordText), for: .touchUpInside)
        
        return copy
    }()
    
    lazy var showPassword: UIButton = {
        let copy = UIButton()
        copy.setBackgroundImage(UIImage(named: "visible"), for: .normal)
        copy.contentMode = .scaleAspectFit
        copy.addTarget(self, action: #selector(showHidePasswd), for: .touchUpInside)
        return copy
    }()
    
    var presentControllerButton = UIButton.init(type: UIButton.ButtonType.system)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.navBar.leftButton.setTitle("Удалить", for: .normal)
        self.navBar.leftButton.setTitleColor(.red, for: .normal)
        self.navBar.leftButton.addTarget(self, action: #selector(self.deleteSite), for: .touchUpInside)
        
        self.navBar.rightButton.setTitle("Изменить", for: .normal)
        self.navBar.rightButton.addTarget(self, action: #selector(changeInfo), for: .touchUpInside)

        
        [navBar, siteLoginTextField, sitePasswordTextField, loginLabelText, passwordLabelText, separator, separatorTwo, copyButton, copyButtonTwo, showPassword].forEach(view.addSubview)
        
        
    }
    
    @objc func copyLoginText() {
        copyTextInTextField(your: siteLoginTextField)
    }
    
    @objc func copyPasswordText() {
        copyTextInTextField(your: sitePasswordTextField)
    }
    
    
    @objc func changeInfo() {
        self.delegate?.didChangeInfo()
    }
    
    @objc func deleteSite() {
        let alertController = UIAlertController(title: "Удалить учетные данные", message: "Удаленные данные нельзя восставить.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            
            try! self.realm.write {
                self.realm.delete(self.selectedSite!)
                self.delegate?.reloadData()
            }
        }
        alertController.addAction(deleteAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func showHidePasswd() {
        switchShowHidePasButton(showHideButton: showPassword, securityTextEntry: sitePasswordTextField, variable: &toggle)
    }
    
    
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    @available(iOS 11.0, *)
    override public func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        self.updateLayout(with: self.view.frame.size)
    }
    
    func updateLayout(with size: CGSize) {
        
        self.separator.frame = CGRect(x: 0, y: 0, width: size.width / 1.4, height: 2)
        self.separator.center.x = size.width / 2
        self.separator.center.y = size.height / 2
        
        self.loginLabelText.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        self.loginLabelText.anchor(top: nil, left: siteLoginTextField.leftAnchor , bottom: siteLoginTextField.topAnchor, right: siteLoginTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
//        self.siteLoginTextField.frame = CGRect(x: 0, y: 0, width: size.width / 1.5, height: 40)
//        self.siteLoginTextField.center.x = size.width / 2
//        self.siteLoginTextField.center.y = separator.center.y - 20
        self.siteLoginTextField.anchor(top: nil, left: separator.leftAnchor, bottom: separator.bottomAnchor, right: copyButton.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 10, width: separator.frame.width, height: 30)
        
        self.copyButton.anchor(top: siteLoginTextField.topAnchor, left: nil, bottom: nil, right: separator.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        self.passwordLabelText.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        self.passwordLabelText.anchor(top: separator.topAnchor, left: loginLabelText.leftAnchor , bottom: sitePasswordTextField.topAnchor, right: sitePasswordTextField.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        self.sitePasswordTextField.anchor(top: passwordLabelText.topAnchor, left: separator.leftAnchor, bottom: separatorTwo.bottomAnchor, right: copyButtonTwo.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 40, width: separator.frame.width, height: 30)
//        self.sitePasswordTextField.center.x = size.width / 2
//        self.sitePasswordTextField.center.y = separator.center.y + 60
        
        self.copyButtonTwo.anchor(top: sitePasswordTextField.topAnchor, left: nil, bottom: nil, right: separatorTwo.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        self.showPassword.anchor(top: sitePasswordTextField.topAnchor, left: nil, bottom: nil, right: copyButtonTwo.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 20, height: 20)
        
        self.separatorTwo.anchor(top: sitePasswordTextField.bottomAnchor, left: separator.leftAnchor, bottom: nil, right: separator.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: size.width / 1.4, height: 2)
//        self.separatorTwo.frame = CGRect(x: 0, y: 0, width: size.width / 1.4, height: 2)
//        self.separatorTwo.center.x = size.width / 2
//        self.separatorTwo.center.y = sitePasswordTextField.center.y + 20
    }
}

