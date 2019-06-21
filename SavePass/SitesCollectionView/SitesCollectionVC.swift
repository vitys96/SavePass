import UIKit
import SPStorkController
import RealmSwift
import LocalAuthentication
import AppLocker

class SitesCollectionVC: UICollectionViewController {
    
    var searchController: UISearchController!
    lazy var emptySitesButton = UIButton()
    var alert: UIAlertController!
    let userDefaults = UserDefaults.standard
    
    var presenter = SitesCollectionVCPresenter()
    
    var selectedSite: SiteList!
    var filterResultArray: [SiteList] = []
    
    @IBAction func changePassword(_ sender: UIBarButtonItem) {
        self.presenter.changePasswordLogic(vc: self)
    }
    
    @IBAction func addNewsite(_ sender: Any) {
        self.pushToAddSite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkCountOfSite()
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(self)
        
        entryAppCheck()
        configureStartScreen()
        createSearchController() 
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
    
    private func entryAppCheck() {
        self.presenter.checkEntryAppPassLogic()
    }
    
    private func configureStartScreen() {
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        collectionView?.register(SitesCollectionViewCell.self, forCellWithReuseIdentifier: SitesCollectionViewCell.reuseId)
        
    }
    private func checkCountOfSite() {
        self.presenter.checkCountOfSiteLogic(button: emptySitesButton, vc: self)
    }
    
    @objc private func pushToAddSite() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreAddNewSiteCollectionVC") as? PreAddNewSiteCollectionVC else { return }
        fadeInAnimationsNavigationController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
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

extension SitesCollectionVC: SitesCollectionVCProtocol {
    
    func newSiteBtnAddTarget(button: UIButton) {
        button.addTarget(self, action: #selector(pushToAddSite), for: .touchUpInside)
    }
    
    func pinValidate() {
        pin(.validate)
    }
    
    func pinChange() {
        pin(.change)
    }
    
    func pinDeactive() {
        pin(.deactive)
    }
    
    func pinCreate() {
        pin(.create)
    }
    
}

extension SitesCollectionVC {
    
    // MARK: - Table View data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterResultArray.count
        }
        return DBManager.sharedInstance.getDataFromSiteList().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SitesCollectionViewCell.reuseId, for: indexPath) as? SitesCollectionViewCell else { return UICollectionViewCell() }
        
        configureCell(cell: cell, indexPath: indexPath)
        return cell
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

extension SitesCollectionVC: SiteModalDelegate {
    func didChangeInfo() {
        
        self.searchController.isActive = false
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.searchController.searchBar.text = nil
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NewSiteTableVC") as! NewSiteTableVC
            vc.isDeletedVisible = true
            guard let selectedSite = self.selectedSite else { return }
            vc.selectedSite = selectedSite
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
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
        self.collectionView.reloadData()
    }
}








