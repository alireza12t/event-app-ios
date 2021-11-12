//
//  NewNetwork.swift
//  EventApp
//
//  Created by Alireza on 11/2/21.
//  Copyright © 2021 Alexani. All rights reserved.
//

import Apollo

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenInterceptor(), at: 0)
        return interceptors
    }
}

class NewNetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(BearerInterceptor(), at: 0)
        return interceptors
    }
}

class BearerInterceptor: ApolloInterceptor {
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            if !DataManager.shared.token.isEmpty {
                request.addHeader(name: "Authorization", value: "JWT \(DataManager.shared.token)")
            }
            
            print("request :\(request)")
            print("response :\(String(describing: response))")
            
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
}

class TokenInterceptor: ApolloInterceptor {
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            request.addHeader(name: "Application-Token", value: Configuration.token)

            print("request :\(request)")
            print("response :\(String(describing: response))")
            
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
}
