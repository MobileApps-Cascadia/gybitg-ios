//
//  UsersRepository.swift
//  GYBITG
//
//  Created by Sharief Youssef on 5/28/19.
//

import Foundation

//The protocol for the VideoView
protocol UsersRepositoryProtocol{
    //to store all videos
    func addUser(userToAdd: User) -> String
    
}

class UsersRepository: UsersRepositoryProtocol{
  
    internal var users = [User]()
    
    //purpose: will insert the video passed in
    //precondition: User is not already in the array
    //postcondion: The Users passed in will be added to the users array and the userID returned
    func addUser(userToAdd: User) -> String {
        if(!users.contains(userToAdd)){
            users.append(userToAdd)
        }
        return userToAdd.userId
    }
    
}
