//
//  ApiRequest.swift
//  ApiGateway
//
//  Created by gbmlocaladmin on 06/03/18.
//  Copyright © 2018 GBM. All rights reserved.
//

import UIKit
import CoreLocation

protocol ApiRequest {
    var urlRequest: URLRequest? { get }
}

extension URLRequest {
    static var baseHeaders: [String: String] = [:]
    static func cleanBaseHeaders() {
        URLRequest.baseHeaders = [:]
    }
}
