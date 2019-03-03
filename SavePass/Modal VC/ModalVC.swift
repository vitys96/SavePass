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
    
    let navBar = SPFakeBarView(style: .stork)
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    
    lazy var loginLabelText: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var siteLoginLabel: UILabel = {
        let siteLabel = UILabel()
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
    
    lazy var sitePasswordLabel: UILabel = {
        let passwdLabel = UILabel()
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
        //        self.view.addSubview(self.navBar)
        //
        //
        //        self.view.addSubview(self.siteLoginLabel)
        //        self.view.addSubview(self.sitePasswordLabel)
        //        self.view.addSubview(self.loginLabelText)
        //        self.view.addSubview(self.passwordLabelText)
        //        self.view.addSubview(self.separator)
        //        self.view.addSubview(self.separatorTwo)
        //        self.view.addSubview(self.copyButton)
        //        self.view.addSubview(self.copyButtonTwo)
        
        [navBar, siteLoginLabel, sitePasswordLabel, loginLabelText, passwordLabelText, separator, separatorTwo, copyButton, copyButtonTwo].forEach(view.addSubview)
        
        
    }
    
    @objc func copyLoginText() {
        copyTextInLabel(your: siteLoginLabel)
    }
    
    @objc func copyPasswordText() {
        copyTextInLabel(your: sitePasswordLabel)
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
        
        self.separator.frame = CGRect(x: 0, y: 0, width: siteLoginLabel.frame.width, height: 2)
        self.separator.center.x = size.width / 2
        self.separator.center.y = size.height / 2
        
        self.loginLabelText.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        self.loginLabelText.anchor(top: nil, left: siteLoginLabel.leftAnchor , bottom: siteLoginLabel.topAnchor, right: siteLoginLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        self.siteLoginLabel.frame = CGRect(x: 0, y: 0, width: 230, height: 40)
        self.siteLoginLabel.center.x = size.width / 2
        self.siteLoginLabel.center.y = separator.center.y - 20
        
        self.copyButton.anchor(top: siteLoginLabel.topAnchor, left: nil, bottom: nil, right: siteLoginLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        self.passwordLabelText.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        self.passwordLabelText.anchor(top: separator.bottomAnchor, left: sitePasswordLabel.leftAnchor , bottom: sitePasswordLabel.topAnchor, right: sitePasswordLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        self.sitePasswordLabel.frame = CGRect(x: 0, y: 0, width: 230, height: 30)
        self.sitePasswordLabel.center.x = size.width / 2
        self.sitePasswordLabel.center.y = separator.center.y + 50
        
        self.copyButtonTwo.anchor(top: sitePasswordLabel.topAnchor, left: nil, bottom: nil, right: sitePasswordLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        self.separatorTwo.anchor(top: sitePasswordLabel.bottomAnchor, left: sitePasswordLabel.leftAnchor, bottom: nil, right: sitePasswordLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: sitePasswordLabel.frame.width, height: 2)
    }
}

