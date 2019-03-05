import UIKit
import SPStorkController
import RealmSwift
import LocalAuthentication
import AppLocker

class SitesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cell"
    
    let realm = try! Realm()
    var items: Results<SiteList>! {
        get {
            return realm.objects(SiteList.self).sorted(byKeyPath: "siteName", ascending: true)
        }
    }
    var selectedSite: SiteList!
    
    @IBAction func addNewsite(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreAddNewSiteCollectionVC") as? PreAddNewSiteCollectionVC else { return }
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AppLocker.present(with: .validate)
        
        //                var appearance = ALAppearance()
        //                appearance.image = UIImage(named: "Image")!
        //                appearance.title = "Devios Ryasnoy"
        //                appearance.isSensorsEnabled = true
        //                appearance.color = UIColor(hexValue: "#4f4d4d", alpha: 1.0)
        //
        //
        //                AppLocker.present(with: .validate, and: appearance)
        
        
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        
        //        navigationItem.title = "Teams"
        //        navigationController?.navigationBar.barTintColor = UIColor.customRedColor
        //
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
        //                                                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        collectionView?.register(SitesCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SitesCollectionViewCell
        
        let item = items[indexPath.row]
        
        cell.loginLabel.text = item.siteLogin
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        let modal = ModalVC()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 400
        modal.transitioningDelegate = transitionDelegate
        modal.delegate = self
        modal.selectedSite = item
        modal.loginLabel = item.siteLogin
        modal.passwordLabel = item.sitePassword
        modal.navBar.titleLabel.text = item.siteName
        modal.modalPresentationStyle = .custom
        present(modal, completion: nil)
        selectedSite = item
        
    }
    
}

extension SitesCollectionVC: ModalVCDelegate {
    func didChangeInfo() {
        self.dismiss(animated: true) { [weak self] in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NewSiteTableVC") as! NewSiteTableVC
            vc.isDeletedVisible = true
            vc.selectedSite = self!.selectedSite
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func reloadData() {
        self.dismiss(animated: true) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

//extension SitesCollectionVC {
//
//    func authenticationWithTouchID() {
//
//        let localAuthenticationContext = LAContext()
//        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
//
//        var authError: NSError?
//        let reasonString = "To access the secure data"
//
//        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
//
//            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
//
//                if success {
//
//                    //TODO: User authenticated successfully, take appropriate action
//
//                } else {
//                    //TODO: User did not authenticate successfully, look at error and take appropriate action
//                    guard let error = evaluateError else {
//                        return
//                    }
//
//                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
//
//                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
//
//                }
//            }
//        } else {
//
//            guard let error = authError else {
//                return
//            }
//            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
//            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
//        }
//    }
//
//    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
//        var message = ""
//        if #available(iOS 11.0, macOS 10.13, *) {
//            switch errorCode {
//            case LAError.biometryNotAvailable.rawValue:
//                message = "Authentication could not start because the device does not support biometric authentication."
//
//            case LAError.biometryLockout.rawValue:
//                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
//
//            case LAError.biometryNotEnrolled.rawValue:
//                message = "Authentication could not start because the user has not enrolled in biometric authentication."
//
//            default:
//                message = "Did not find error code on LAError object"
//            }
//        } else {
//            switch errorCode {
//            case LAError.touchIDLockout.rawValue:
//                message = "Too many failed attempts."
//
//            case LAError.touchIDNotAvailable.rawValue:
//                message = "TouchID is not available on the device"
//
//            case LAError.touchIDNotEnrolled.rawValue:
//                message = "TouchID is not enrolled on the device"
//
//            default:
//                message = "Did not find error code on LAError object"
//            }
//        }
//
//        return message
//    }
//
//    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
//
//        var message = ""
//
//        switch errorCode {
//
//        case LAError.authenticationFailed.rawValue:
//            message = "The user failed to provide valid credentials"
//
//        case LAError.appCancel.rawValue:
//            message = "Authentication was cancelled by application"
//
//        case LAError.invalidContext.rawValue:
//            message = "The context is invalid"
//
//        case LAError.notInteractive.rawValue:
//            message = "Not interactive"
//
//        case LAError.passcodeNotSet.rawValue:
//            message = "Passcode is not set on the device"
//
//        case LAError.systemCancel.rawValue:
//            message = "Authentication was cancelled by the system"
//
//        case LAError.userCancel.rawValue:
//            message = "The user did cancel"
//
//        case LAError.userFallback.rawValue:
//            message = "The user chose to use the fallback"
//
//        default:
//            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
//        }
//
//        return message
//}
//}








