
import UIKit

class SitesCollectionViewCell: UICollectionViewCell {
    
    var site: Site? {
        didSet {
            guard let siteImage = site?.image else { return }
            guard let loginName = site?.name else { return }
            
            siteImageView.image = UIImage(named: siteImage)
            loginLabel.text = loginName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
    }
    
    func setup() {
        
        self.backgroundColor = .white
        
        self.addSubview(siteImageView)
        self.addSubview(grayView)
        self.addSubview(loginLabel)
        
        siteImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 60)
        grayView.anchor(top: siteImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        loginLabel.anchor(top: siteImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
    }
    
    let siteImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0  )
        return view
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
