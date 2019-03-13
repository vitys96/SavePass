import UIKit
import RealmSwift

class DBManager {
    
    var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromSiteList() -> Results<SiteList> {
        
        let results: Results<SiteList> = database.objects(SiteList.self)
        //.sorted(byKeyPath: "siteName", ascending: true)
        return results
    }
    
    func addDataSiteList(object: SiteList) {
        
        try! database.write {
            database.add(object, update: true)
            print("Added new object SiteList")
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: SiteList) {
        try! database.write {
            database.delete(object)
        }
    }
    
}
