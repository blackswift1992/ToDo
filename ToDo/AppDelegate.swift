import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            let _ = try Realm()
        } catch {
            print("New Realm initialising is failed, \(error)")
        }
        
        return true
    }
}
