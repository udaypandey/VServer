//
//  Networking.swift
//  Test
//
//  Created by vaion on 17/01/2020.
//  Copyright © 2020 vaion. All rights reserved.
//

import Foundation




// Use this class to handle communication with the server
// it has been configured with a mock implementation of the NetworkingProtocol below
class Networking: NetworkingProtocol {
    static let sharedInstance = Networking()
}



struct Credentials {
    var username: String
    var password: String
}




/// Information about a completed network request
struct NetworkingResponse {
    /// - parameter: success: `true` if the request succeeds, `false` if there is an error
    var success: Bool
    
    /// HTTP response code
    var code: Int
    
    /// status code description
    var message: String
}


protocol NetworkingProtocol {
    /**
     Attempts to connect to a server at the specified `ipAddress`, with the `credentials` provided.

        - Parameters:
            - ipAddress:            The ip address of the server.
            - credentials:          Username and password for authentication (Optional).
            - completionHandler:    Code to be executed once the request completes.
    */
    func connectToServer(ipAddress: String, credentials: Credentials?, completionHandler: @escaping (NetworkingResponse)->Void)
    
    
    
    
    
    /**
     Gets all existing server groups in the cluster.
     
        - Parameters:
            - completionHandler:  Code to be executed once the request completes.

        - Throws: `NetworkingError.notConnected`
              if called before successfully connecting to a cluster
    */
    func getServerGroups(completionHandler: @escaping ([ServerGroup])->Void) throws
    
    
    
    
    /**
     Adds the new  server to the cluster. Must supply either `serverGroupName` or `newServerGroup`
     
        - Parameters:
            - name:               Name for the new server.
            - serverGroupName:    The name of an existing `ServerGroup` to add the new server to (Optional).
            - newServerGroup:     A new `ServerGroup` to create and add the new server to (Optional).
            - completionHandler:  Code to be executed once the request completes.

        - Throws: `NetworkingError.notConnected`
              if called before successfully connecting to a cluster
    */
    func configureServer(name: String, serverGroupName: String?, newServerGroup: ServerGroup?, completionHandler: @escaping (NetworkingResponse)->Void) throws
}




enum NetworkingError: Error {
    case notConnected
}


struct ServerGroup {
    var name: String
    var location: String?
}




















// MARK: - Private

private var __connected = false
private var __serverGroups = [
    ServerGroup(name: "Sales Headquarters", location: "Chicago"),
    ServerGroup(name: "Charter Building", location: "London"),
    ServerGroup(name: "Oslo Office", location: "Oslo"),
]
extension Networking {
    
    func connectToServer(ipAddress: String, credentials: Credentials?, completionHandler: @escaping (NetworkingResponse) -> Void) {
        __connected = false
        
        self.request {
            switch ipAddress {

            case "192.168.0.10":
                completionHandler(NetworkingResponse(success: true, code: 200, message: "Ok"))
                __connected = true

            case "192.168.0.11":
                if credentials?.username == "vaion" && credentials?.password == "password" {
                    completionHandler(NetworkingResponse(success: true, code: 200, message: "Ok"))
                    __connected = true
                } else {
                    completionHandler(NetworkingResponse(success: false, code: 401, message: "Authentication failed"))
                }
            default:
                completionHandler(NetworkingResponse(success: false, code: 0, message: "Host not found"))
            }
        }
    }
    
    
    func getServerGroups(completionHandler: @escaping ([ServerGroup])->Void) throws {
        if !__connected {
            throw NetworkingError.notConnected
        }
        self.request {
            completionHandler(__serverGroups);
        }
    }
    
    
    func configureServer(name: String, serverGroupName: String?, newServerGroup: ServerGroup?, completionHandler: @escaping (NetworkingResponse)->Void) throws {
        if !__connected {
            throw NetworkingError.notConnected
        }
        self.request {
            if let newGroup = newServerGroup {
                // new group must have a name
                if newGroup.name.count > 0 {
                    __serverGroups.append(newGroup)
                    completionHandler(NetworkingResponse(success: true, code: 200, message: "Ok"))
                    return
                }
            
            } else if let existingGroupName = serverGroupName {
                // otherwise must match an existing group
                if __serverGroups.first(where: { $0.name == existingGroupName }) != nil {
                    completionHandler(NetworkingResponse(success: true, code: 200, message: "Ok"))
                    return
                }
            }
            completionHandler(NetworkingResponse(success: false, code: 400, message: "Bad request"))
        }
    }
    
    
    private func request(completionHandler: @escaping () -> Void) {
        let delay = Float.random(in: 1..<2) // in seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .Stride(delay), execute: completionHandler)
    }
    
}
