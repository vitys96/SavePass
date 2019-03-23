import UIKit
import SPStorkController
import RealmSwift
import LocalAuthentication
import AppLocker
import InfiniteLayout

class SitesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var searchController: UISearchController!
    let cellId = "cell"
    var filterResultArray: [SiteList] = []
    
    var alert: UIAlertController!
    
    lazy var emptySitesButton = UIButton()
    let emptySitesLabel = UILabel()
    
    let realm = try! Realm()
    //    var items: Results<SiteList>! {
    //        get {
    //            return realm.objects(SiteList.self).sorted(byKeyPath: "siteName", ascending: true)
    //        }
    //    }
    var selectedSite: SiteList!
    
    @IBAction func changePassword(_ sender: UIBarButtonItem) {
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changePasswd = UIAlertAction(title: "Изменить пароль", style: .default) { (success) in
            self.pin(.change)
        }
        let defaultAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alert.addAction(changePasswd)
        alert.addAction(defaultAction)
        
        present(alert, animated: true) {
            self.alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            self.alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController)))
        }
    }
    
    @objc func dismissAlertController(){
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewsite(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreAddNewSiteCollectionVC") as? PreAddNewSiteCollectionVC else { return }
        
        fadeInAnimationsNavigationController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        
        checkCountOfSite()
        let userDefaults = UserDefaults.standard
        guard !userDefaults.bool(forKey: "wasWatched") else { return }
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageVC") as? PageVC {
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStartScreen()
        createSearchController()
//                entryAppCheck()
        //                AppLocker.present(with: .validate)
        //
        
        
    }
    
    private func entryAppCheck() {
        
        var appearance = ALAppearance()
        guard let image = UIImage(named: "shieldy") else { return }
        appearance.image = image
        appearance.title = "Save Pass"
        appearance.isSensorsEnabled = true
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "passwordCreate") {
            AppLocker.present(with: .create, and: appearance)
            userDefaults.set(true, forKey: "passwordCreate")
        }
        else {
            AppLocker.present(with: .validate, and: appearance)
        }
    }
    
    private func pin(_ mode: ALMode) {
        var appearance = ALAppearance()
        guard let image = UIImage(named: "shieldy") else { return }
        appearance.image = image
        appearance.title = "Save Pass"
        AppLocker.present(with: mode, and: appearance)
    }
    
    
    
    // MARK: - Table View data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterResultArray.count
        }
        return DBManager.sharedInstance.getDataFromSiteList().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SitesCollectionViewCell
        
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    // MARK: - Table View delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let index = indexPath.item
        searchController.searchBar.resignFirstResponder()
        
        let site = siteToDisplayAt(indexPath: indexPath)
        
        let modal = ModalVC()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 400
        
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        
        modal.delegate = self
        modal.selectedSite = site
        modal.navBar.titleLabel.text = site.siteName
        
        present(modal, animated: true, completion: nil)
        
        self.selectedSite = site
    }
    
    
    // MARK: - MY FUNCTIONS
    
    private func configureStartScreen() {
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        collectionView?.register(SitesCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    private func checkCountOfSite() {
        if DBManager.sharedInstance.getDataFromSiteList().count == 0 {
            addingNewSiteButton()
        }
        else {
            hideNewSiteButton()
        }
    }
    
    private func addingNewSiteButton() {
        emptySitesButton.setBackgroundImage(UIImage(named: "plus"), for: .normal)
        self.view.addSubview(emptySitesButton)
        emptySitesButton.addTarget(self, action: #selector(pushToAddSite), for: .touchUpInside)
        
        emptySitesButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 3, width: 50, height: 50)
        emptySitesButton.center.x = self.view.center.x
    }
    
    @objc private func pushToAddSite() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreAddNewSiteCollectionVC") as? PreAddNewSiteCollectionVC else { return }
        
        fadeInAnimationsNavigationController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    private func hideNewSiteButton() {
        emptySitesButton.removeFromSuperview()
    }
    
    private func createSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = true
        
        searchController.searchBar.placeholder = "Искать в Save Pass"
        searchController.searchBar.sizeToFit()
        
        self.navigationItem.searchController = searchController
    }
    
    
    private func configureCell(cell: SitesCollectionViewCell, indexPath: IndexPath) {
        let item = siteToDisplayAt(indexPath: indexPath)
        cell.loginLabel.text = item.siteLogin
        if let image = UIImage(data: item.siteImageView!) {
            cell.siteImageView.image = image
        }
    }
    
    func filterContentFor(searchText text: String)
    {
        let aka = DBManager.sharedInstance.getDataFromSiteList().sorted(byKeyPath: "siteName", ascending: true)
        //        let all = Array(realm.objects(SiteList.self).sorted(byKeyPath: "siteName", ascending: true))
        
        filterResultArray = aka.filter{ (item) -> Bool in
            return (item.siteName.lowercased().contains(text.lowercased()))
            
        }
    }
    
    func siteToDisplayAt(indexPath: IndexPath) -> SiteList {
        let site: SiteList
        if searchController.isActive && searchController.searchBar.text != "" {
            site = filterResultArray[indexPath.item]
        }
        else {
            site = DBManager.sharedInstance.getDataFromSiteList()[indexPath.item] as SiteList
        }
        return site
    }
}

// MARK: - EXTENSIONS

extension SitesCollectionVC: ModalVCDelegate {
    func didChangeInfo() {
        
        self.searchController.isActive = false
        self.dismiss(animated: true) { [weak self] in
            
            self?.searchController.searchBar.text = nil
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NewSiteTableVC") as! NewSiteTableVC
            vc.isDeletedVisible = true
            guard let selectedSite = self?.selectedSite else { return }
            vc.selectedSite = selectedSite
            
            //            self!.fadeInAnimationsNavigationController()
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func reloadData() {
        self.dismiss(animated: true) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension SitesCollectionVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.endEditing(true)
    }
}

extension SitesCollectionVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        collectionView.reloadData()
    }
    
}

//extension SitesCollectionVC: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        collectionView.reloadData()
//    }
//}
//
//extension SitesCollectionVC: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if(!(searchBar.text?.isEmpty)!){
//            //reload your data source if necessary
//            self.collectionView?.reloadData()
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if(searchText.isEmpty){
//            //reload your data source if necessary
//            self.collectionView?.reloadData()
//        }
//    }
//}

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








