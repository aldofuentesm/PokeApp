//
//  Result.swift
//  ApiGateway
//
//  Created by gbmlocaladmin on 06/03/18.
//  Copyright © 2018 GBM. All rights reserved.
//

import Foundation

enum ApiResult<T> {
    case success(T)
    case failure(ApiError)
    
    func dematerialize() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            return error as! T
        }
    }
}
