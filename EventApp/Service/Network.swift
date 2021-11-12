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
    
    func fetch<Query: GraphQLQuery>(query: Query, shouldRetry: Bool = true, completion: @escaping (Result<GraphQLResult<Query.Data>, Error>) -> (), cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely) {
        apolloNew.fetch(query: query,cachePolicy: cachePolicy) { result in
            switch result {
            case .failure(_ ):
                completion(result)
            case .success(let graphQLResult):
                if shouldRetry {
                    if let errors = graphQLResult.errors {
                        print("Errors => ", errors)
                        if errors.compactMap({$0.message}).joined().contains("Signature") {
                            self.refreshToken { isSucceeded in
                                if isSucceeded {
                                    self.fetch(query: query, shouldRetry: false, completion: completion)
                                } else {
                                    completion(result)
                                }
                            }
                        } else {
                            completion(result)
                        }
                    } else {
                        
                    }
                } else {
                    completion(result)
                }
            }
        }
    }
    
    func nsdataToJSON(data: Data) -> [String : Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func perform<Mutation: GraphQLMutation>(mutation: Mutation, shouldRetry: Bool = true, completion: @escaping (Result<GraphQLResult<Mutation.Data>, Error>) -> (), cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely) {
        apolloNew.perform(mutation: mutation) { result in
            switch result {
            case .failure(let error):
                completion(result)
            case .success(let graphQLResult):
                if mutation.operationName != GetRefreshTokenMutation(refreshToken: DataManager.shared.refreshToken).operationName {
                if shouldRetry {
                    if let errors = graphQLResult.errors {
                        print("Errors => ", errors)
                        if errors.compactMap({$0.message}).joined().contains("Signature") {
                            self.refreshToken { isSucceeded in
                                if isSucceeded {
                                    self.perform(mutation: mutation, shouldRetry: false, completion: completion)
                                } else {
                                    completion(result)
                                }
                            }
                        } else {
                            completion(result)
                        }
                    } else  {
                        completion(result)
                    }
                } else {
                    completion(result)
                }
                } else {
                    completion(result)
                }
            }
        }
    }
    
    func refreshToken(completion: @escaping (Bool) -> ()) {
        apolloNew.perform(mutation: GetRefreshTokenMutation(refreshToken: DataManager.shared.refreshToken)) { result in
            switch result {
            case .failure(_ ):
                completion(false)
            case .success(let data):
                let model = data.data?.refreshToken
                if let token = model?.token,
                   let refreshToken = model?.refreshToken {
                    DataManager.shared.refreshToken = refreshToken
                    DataManager.shared.token = token
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
}

