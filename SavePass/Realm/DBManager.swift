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
        do {
            try database.write {
                database.add(object, update: .all)
            }
        }
        catch {
            print ("error additing data to site list")
        }
    }
    
    func deleteAllDatabase()  {
        
        do {
            try database.write {
                database.deleteAll()
            }
        }
        catch {
            print ("error to delete all database")
        }
    }
    
    func deleteFromDb(object: SiteList) {
        
        do {
            try database.write {
                database.delete(object)
            }
        }
        catch {
            print ("error to delete site from database")
        }
    }
    
}
