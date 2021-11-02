//
//  Network.swift
//  TEDxConnect
//
//  Created by Tadeh Alexani on 8/8/20.
//  Copyright © 2020 Alexani. All rights reserved.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first!
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("event_ios_app_apollo_db.sqlite")
        
        let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
        
        let store = ApolloStore(cache: sqliteCache)
        
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: Configuration.oldBaseUrl)!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    
    private(set) lazy var apolloNew: ApolloClient = {
        let client = URLSessionClient()
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first!
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("event_ios_app_apollo_db.sqlite")
        
        let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
        
        let store = ApolloStore(cache: sqliteCache)
        
        let provider = NewNetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: Configuration.baseUrl)!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()
    
    func fetch<Query: GraphQLQuery>(query: Query, completion: @escaping (Result<GraphQLResult<Query.Data>, Error>) -> (), cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely) {
        apolloNew.fetch(query: query,cachePolicy: cachePolicy) { result in
            switch result {
            case .failure(let error):
                //                if let errorResponse = error as? GraphQLHTTPResponseError {
                //                    if errorResponse.response.statusCode == 401 {
                //                        self.refreshToken { isSucceeded in
                //                            if isSucceeded {
                //                                self.fetch(query: query, completion: completion)
                //                            } else {
                //                                completion(result)
                //                            }
                //                        }
                //                    } else {
                completion(result)
                //                    }
                //                } else {
                //                    completion(result)
                //                }
            case .success(_ ):
                completion(result)
            }
        }
    }
    
    func perform<Mutation: GraphQLMutation>(mutation: Mutation, completion: @escaping (Result<GraphQLResult<Mutation.Data>, Error>) -> (), cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely) {
        apolloNew.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                //              if let errorResponse = error as? GraphQLResultError.error. {
                //                    if errorResponse.res.statusCode == 401 {
                //                        self.refreshToken { isSucceeded in
                //                            if isSucceeded {
                //                                self.perform(mutation: mutation, completion: completion)
                //                            } else {
                //                                completion(result)
                //                            }
                //                        }
                //                    } else {
                //                        completion(result)
                //                    }
                //                } else {
                completion(result)
                //                }
            case .success(_ ):
                completion(result)
            }
        }
    }
    
    func refreshToken(completion: @escaping (Bool) -> ()) {
        apolloNew.perform(mutation: GetRefreshTokenMutation(refreshToken: DataManager.shared.refreshToken)) { result in
            switch result {
            case .failure(_ ):
                completion(true)
            case .success(_ ):
                completion(false)
            }
        }
    }
    
}

