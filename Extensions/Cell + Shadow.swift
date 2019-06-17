import UIKit

extension UIView {
    
    func setCellShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 5
    }
}

//public extension UIColor {
//    
//    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
//        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
//    }
//    
//    static var customLightBlueColor: UIColor = {
//        return UIColor(r: 44, g: 57, b: 95)
//    }()
//    
//    static var customRedColor: UIColor = {
//        return UIColor(r: 217, g: 48, b: 80)
//    }()
//    
//    static var customDarkBlueColor: UIColor = {
//        return UIColor(r: 11, g: 22, b: 53)
//    }()
//}















