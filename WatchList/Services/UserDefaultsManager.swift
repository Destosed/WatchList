import Foundation

class UserDefaultsManager {
    
    // MARK: - Nested Types
    
    private enum Keys {
        
        // MARK: - Type Properties
        
        static let user = "user"
    }
    
    // MARK: - Instance Properties
    
    static let shared = UserDefaultsManager()
    
    // MARK: - Instance Methods
    
    func saveUser(user: User) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: Keys.user)
    }
    
    func getUser() -> User? {
        if let userData = UserDefaults.standard.value(forKey: Keys.user) as? Data {
            if let user = try? PropertyListDecoder().decode(User.self, from: userData) {
                return user
            }
        }
        return nil
    }
    
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: Keys.user)
    }
}
