import UIKit
import SPStorkController
import RealmSwift
import LocalAuthentication
import AppLocker

class SitesCollectionVC: UICollectionViewController {
    
    var searchController: UISearchController!
    let cellId = "cell"
    var filterResultArray: [SiteList] = []
    var alert: UIAlertController!
    lazy var emptySitesButton = UIButton()
    let emptySitesLabel = UILabel()
    let userDefaults = UserDefaults.standard
    let realm = try! Realm()
    
    var selectedSite: SiteList!
    
    @IBAction func changePassword(_ sender: UIBarButtonItem) {
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if userDefaults.bool(forKey: "passwordCreate") && !userDefaults.bool(forKey: "passwordDelete") {
            alertActions(title: "Изменить пароль", style: .default) { (success) in
                self.pin(.change)
                
            }
            alertActions(title: "Удалить пароль", style: .destructive) { (success) in
                self.pin(.deactive)
                self.userDefaults.set(true, forKey: "passwordDelete")
            }
        }
        if userDefaults.bool(forKey: "passwordDelete") {
            alertActions(title: "Создать пароль", style: .default) { (success) in
                self.pin(.create)
                self.userDefaults.set(false, forKey: "passwordDelete")
                
            }
        }
        
        let defaultAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alert.addAction(defaultAction)
        
        present(alert, animated: true) {
            self.alert.view.superview?.subviews[1].isUserInteractionEnabled = true
            self.alert.view.superview?.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController)))
        }
    }
    
    func alertActions(title: String, style: UIAlertAction.Style, hadler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: hadler)
        alert.addAction(action)
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
        guard !userDefaults.bool(forKey: "wasWatched") else { return }
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageVC") as? PageVC {
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryAppCheck()
        configureStartScreen()
        createSearchController() 
    }
    
    private func entryAppCheck() {
        
        if userDefaults.bool(forKey: "passwordDelete") {
            return
        }
        
        if !userDefaults.bool(forKey: "passwordCreate") {
            pin(.create)
            userDefaults.set(true, forKey: "passwordCreate")
        }
        else {
            pin(.validate)
        }
    }
    
    private func pin(_ mode: ALMode) {
        var appearance = ALAppearance()
        guard let image = UIImage(named: "shieldy") else { return }
        appearance.image = image
        
        appearance.color = UIColor(hexValue: "#636363", alpha: 1.0)
        appearance.isSensorsEnabled = true
        AppLocker.present(with: mode, and: appearance)
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
    
    private func filterContentFor(searchText text: String)
    {
        let sortedBySiteName = DBManager.sharedInstance.getDataFromSiteList().sorted(byKeyPath: "siteName", ascending: true)
        filterResultArray = sortedBySiteName.filter{ (item) -> Bool in
            return (item.siteName.lowercased().contains(text.lowercased()))
            
        }
    }
    
    private func siteToDisplayAt(indexPath: IndexPath) -> SiteList {
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

extension SitesCollectionVC {
    
    // MARK: - Table View data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterResultArray.count
        }
        return DBManager.sharedInstance.getDataFromSiteList().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SitesCollectionViewCell
        
        configureCell(cell: cell!, indexPath: indexPath)
        return cell!
    }
    
    
    
    // MARK: - Table View delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchController.searchBar.resignFirstResponder()
        
        let site = siteToDisplayAt(indexPath: indexPath)
        
        let modal = ModalVC()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 400
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        
        
        modal.delegate = self
        modal.selectedSite = site

        modal.titleLabel = site.siteName
        
        present(modal, animated: true, completion: nil)
        
        self.selectedSite = site
    }
}



extension SitesCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

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








