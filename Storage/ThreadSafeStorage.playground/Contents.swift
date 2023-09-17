import UIKit

struct User: Identifiable, Codable {
    let id: UUID
}

/// to prevent `data race`
/// using of `async` for `serial` queue, to not block of the caller queue
/// for getting `@escaping` callback is required
class UserStorageLegacy {
    private var users = [User.ID: User]()
    private let queue = DispatchQueue(label: "UserStorage.sync")
    
    func store(_ user: User) {
        queue.async {
            self.users[user.id] = user
        }
    }
    
    func loadUser(withID id: User.ID,
                  handler: @escaping (User?) -> Void) {
        queue.async {
            handler(self.users[id])
        }
    }
}

/// to prevent `data race`
/// using of `actor`
actor UserStorage {
    private var users = [User.ID: User]()
    
    func store(_ user: User) {
        users[user.id] = user
    }
    
    func user(withID id: User.ID) -> User? {
        users[id]
    }
}


class UserLoaderRaceConditionProne {
    private let storage: UserStorage
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    
    init(storage: UserStorage, urlSession: URLSession = .shared) {
        self.storage = storage
        self.urlSession = urlSession
    }
    
    func loadUser(withID id: User.ID) async throws -> User {
        if let storedUser = await storage.user(withID: id) {
            return storedUser
        }
        
        let url = URL(string: "https://getUser?id=uuid")!
        let (data, _) = try await urlSession.data(from: url)
        let user = try decoder.decode(User.self, from: data)
        
        await storage.store(user)
        
        return user
    }
}

/// to prevent `race condition` with multiple loading of the same user
/// tracking `Tasks`
class UserLoaderRaceConditionFree {
    private let storage: UserStorage
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    private var activeTasks = [User.ID: Task<User, Error>]()
    
    
    
    init(storage: UserStorage, urlSession: URLSession = .shared) {
        self.storage = storage
        self.urlSession = urlSession
    }
    
    func loadUser(withID id: User.ID) async throws -> User {
        if let existingTask = activeTasks[id] {
            return try await existingTask.value
        }
        
        let task = Task<User, Error> {
            if let storedUser = await storage.user(withID: id) {
                activeTasks[id] = nil
                return storedUser
            }
            
            let url = URL(string: "https://getUser?id=uuid")!
            
            do {
                let (data, _) = try await urlSession.data(from: url)
                let user = try decoder.decode(User.self, from: data)
                
                await storage.store(user)
                activeTasks[id] = nil
                return user
            } catch {
                activeTasks[id] = nil
                throw error
            }
        }
        
        activeTasks[id] = task
        
        return try await task.value
    }
}
