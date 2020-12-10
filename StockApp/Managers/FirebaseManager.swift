//
//  FirebaseManager.swift
//  StockApp
//
//  Created by Field Employee on 12/4/20.
//

import Foundation
import Firebase

final class FirebaseManager {
    static var shared = FirebaseManager()
    public var email: String = ""
    public var password: String = ""
    let ref = Database.database().reference()
    let session: URLSession
    private init (session: URLSession = URLSession.shared)
    {
        self.session = session
    }
}

extension FirebaseManager {
    
    func login(email:String, password:String, completion: @escaping (String) -> ()){
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                if(error != nil){
                    print(error?.localizedDescription ?? "An unknown error occured")
                    completion("error")
                }
                else {
                    self.email = email
                    self.password = password
                    completion("success")
                }
            }
        }
    }
    
    func checkForUser(user: String, completion: @escaping (String) -> ()){
        var safeUser = user.replacingOccurrences(of: "@", with: "-")
        safeUser = safeUser.replacingOccurrences(of: ".", with: "-")
        DispatchQueue.main.async {
            self.ref.child("Users").observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                let keys = value?.allKeys as? [String]
                if((keys!.contains(safeUser)))
                {
                    completion(safeUser)
                }
                else{
                    completion("")
                }
            })
        }
    }
    
    func registerUser(username: String, password: String, firstName: String, lastName: String){
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
        }
        var safeUser = username.replacingOccurrences(of: "@", with: "-")
        safeUser = safeUser.replacingOccurrences(of: ".", with: "-")
        self.ref.child("Users").child(safeUser).setValue(["firstName": firstName, "lastName": lastName])
    }
    
    func favoriteStockList(completion: @escaping ([String:String]) -> ()) {
        var safeUser = self.email.replacingOccurrences(of: "@", with: "-")
        safeUser = safeUser.replacingOccurrences(of: ".", with: "-")
        DispatchQueue.main.async {
            self.ref.child("Users").child(safeUser).child("Favorite").observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? [String:String]
                completion(value ?? [:])
            })
        }
    }
    
    func addToFavorites(symbol: String, companyName: String) {
        var safeUser = self.email.replacingOccurrences(of: "@", with: "-")
        safeUser = safeUser.replacingOccurrences(of: ".", with: "-")
        DispatchQueue.main.async {
            self.ref.child("Users").child(safeUser).child("Favorite").child(symbol).setValue(companyName)
        }
    }
    
    func removeFromFavorites(symbol: String, companyName: String) {
        var safeUser = self.email.replacingOccurrences(of: "@", with: "-")
        safeUser = safeUser.replacingOccurrences(of: ".", with: "-")
        DispatchQueue.main.async {
            self.ref.child("Users").child(safeUser).child("Favorite").child(symbol).removeValue()
        }
    }
}
