import UIKit
import SPStorkController
import SparrowKit
import RealmSwift
import SPFakeBar

protocol ModalVCDelegate {
    func didChangeInfo()
    func reloadData()
}

class ModalVC: UIViewController {
    
    let realm = try! Realm()
    
    var selectedSite: SiteList?
    
    var delegate: ModalVCDelegate?
    
    var presenter = ModalVcPresenterPresenter()
    
    var toggle = true
    var titleLabel = String()
    
    let navBar = SPFakeBarView(style: .stork)
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    
    var loginLabelText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Логин"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
     var siteLoginTextField: UITextField = {
        let siteLabel = UITextField()
        siteLabel.translatesAutoresizingMaskIntoConstraints = false
        siteLabel.isEnabled = false
        siteLabel.textColor = .black
        siteLabel.font = UIFont.systemFont(ofSize: 19)
        return siteLabel
    }()
    
    var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hexValue: "#dbdbdb", alpha: 1.0)
        return separator
    }()
    
    var passwordLabelText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пароль"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var sitePasswordTextField: UITextField = {
        let passwdLabel = UITextField()
        passwdLabel.translatesAutoresizingMaskIntoConstraints = false
        passwdLabel.isEnabled = false
        passwdLabel.isSecureTextEntry = true
        passwdLabel.font = UIFont.systemFont(ofSize: 19)
        passwdLabel.textColor = .black
        
        return passwdLabel
    }()
    
    var separatorTwo: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(hexValue: "#dbdbdb", alpha: 1.0)
        return separator
    }()
    
    var copyButton: UIButton = {
        let copy = UIButton()
        copy.translatesAutoresizingMaskIntoConstraints = false
        copy.setBackgroundImage(UIImage(named: "copyImage"), for: .normal)
        copy.contentMode = .scaleAspectFit
        copy.addTarget(self, action: #selector(copyLoginText), for: .touchUpInside)
        
        return copy
    }()
    
    var copyButtonTwo: UIButton = {
        let copy = UIButton()
        copy.translatesAutoresizingMaskIntoConstraints = false
        copy.setBackgroundImage(UIImage(named: "copyImage"), for: .normal)
        copy.contentMode = .scaleAspectFit
        copy.addTarget(self, action: #selector(copyPasswordText), for: .touchUpInside)
        
        return copy
    }()
    
    var showPassword: UIButton = {
        let copy = UIButton()
        copy.translatesAutoresizingMaskIntoConstraints = false
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
        
        navBar.titleLabel.text = self.titleLabel
        self.view.backgroundColor = UIColor.white
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.navBar.leftButton.setTitle("Поделиться", for: .normal)
        self.navBar.leftButton.setTitleColor(.blue, for: .highlighted)
        self.navBar.leftButton.addTarget(self, action: #selector(self.shareSite), for: .touchUpInside)
        
        self.navBar.rightButton.setTitle("Просмотреть", for: .normal)
        self.navBar.rightButton.addTarget(self, action: #selector(changeInfo), for: .touchUpInside)
        
        [navBar, siteLoginTextField, sitePasswordTextField, loginLabelText, passwordLabelText, separator, separatorTwo, copyButton, copyButtonTwo, showPassword].forEach(view.addSubview)
        setup()
    }
    
    func setup() {
        siteLoginTextField.text = selectedSite?.siteLogin
        sitePasswordTextField.text = selectedSite?.sitePassword
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
    
    @objc func shareSite() {
        self.presenter.shareSite(vc: self)
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
        
        self.separator.frame = CGRect(x: 0, y: 0, width: size.width / 1.6, height: 2)
        self.separator.center.x = size.width / 2
        self.separator.center.y = size.height / 2
        
        self.loginLabelText.anchor(top: nil, leading: siteLoginTextField.leadingAnchor , bottom: siteLoginTextField.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))

        self.siteLoginTextField.anchor(top: nil, leading: separator.leadingAnchor, bottom: separator.bottomAnchor, trailing: copyButton.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 30),
                                       size: CGSize(width: 0, height: 30))

        self.copyButton.anchor(top: siteLoginTextField.topAnchor, leading: nil, bottom: nil, trailing: separator.trailingAnchor, size: CGSize(width: 25, height: 25))

        self.passwordLabelText.anchor(top: separator.topAnchor, leading: loginLabelText.leadingAnchor , bottom: sitePasswordTextField.topAnchor, trailing: sitePasswordTextField.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0),size: CGSize(width: 90, height: 30))


        self.sitePasswordTextField.anchor(top: passwordLabelText.topAnchor, leading: separator.leadingAnchor, bottom: separatorTwo.bottomAnchor, trailing: showPassword.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 30), size: CGSize(width: separator.frame.width, height: 30))


        self.copyButtonTwo.anchor(top: sitePasswordTextField.topAnchor, leading: nil, bottom: nil, trailing: separatorTwo.trailingAnchor, size: CGSize(width: 25, height: 25))


        self.showPassword.anchor(top: sitePasswordTextField.topAnchor, leading: nil, bottom: nil, trailing: copyButtonTwo.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30),
                                 size: CGSize(width: 25, height: 25))

        self.separatorTwo.anchor(top: sitePasswordTextField.bottomAnchor, leading: separator.leadingAnchor, bottom: nil, trailing: separator.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0),
                                 size: CGSize(width: self.separator.frame.width, height: 2))
    }
}

extension ModalVC: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        guard let siteName = selectedSite?.siteName,
            let siteLogin = selectedSite?.siteLogin,
            let sitePasswd = selectedSite?.sitePassword
            else { return ""}
        
        return """
        \(siteName)
        \(siteLogin)
        \(sitePasswd)
        """
    }
}

