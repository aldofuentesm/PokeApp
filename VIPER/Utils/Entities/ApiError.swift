//
//  ApiError.swift
//  ApiGateway
//
//  Created by gbmlocaladmin on 06/03/18.
//  Copyright © 2018 GBM. All rights reserved.
//

import Foundation

struct ApiGbmError: Decodable {
    var eventId: Decimal? = 20
    var code: String? = ""
    var message: String? = ""
    var target: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case code
        case message
        case target
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let eventIdInt = try? values.decode(Decimal.self, forKey: .eventId) {
            eventId = eventIdInt
        }
        eventId = 0
        code = try? values.decode(String.self, forKey: .code)
        message = try? values.decode(String.self, forKey: .message)
        target = try? values.decode(String.self, forKey: .target)
    }
}

struct ApiError: Error, Decodable {
    static fileprivate let messageSplit = 2
    var code: String? = ""
    var eventId: String? = ""
    var message: String? = ""
    var friendlyMessage: String? = ""
    var parseMessage: String? = ""
    var origin: String? = ""
    var type: String? = ""
    var error: ApiGbmError? = nil
    
    enum CodingKeys: String, CodingKey {
        case eventId            = "EventId"
        case errorCode          = "ErrorCode"
        case errorMessage       = "ErrorMessage"
        case isBussinessError   = "IsBussinessError"
        case error
    }
    
    init() {}
 
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try? String(values.decode(Int.self, forKey: .errorCode))
        eventId = try? String(values.decode(Int.self, forKey: .eventId))
        message = try? values.decode(String.self, forKey: .errorMessage)
        friendlyMessage = try? values.decode(String.self, forKey: .errorMessage)
        origin = try? String(values.decode(Bool.self, forKey: .isBussinessError))
        type = try? String(values.decode(Bool.self, forKey: .isBussinessError))
        if message?.contains(":") ?? false {
            if let arrayMessage = message?.split(separator: Character(":")) {
                if let lastMessage = arrayMessage.last {
                    friendlyMessage = arrayMessage.count >= ApiError.messageSplit ? String(lastMessage) : nil
                }
            }
        }
        if let gbmError = try? values.decode(ApiGbmError.self, forKey: .error) {
            code = gbmError.code
            eventId = NSDecimalNumber(decimal: gbmError.eventId ?? Decimal.zero).stringValue
            message = gbmError.message
            friendlyMessage = gbmError.message
        }
    }
    
    static var unexpectedError: ApiError {
        return ApiError()
        
    }
    
    static var notFundError: ApiError {
        return ApiError()
    }
    
    static var networkRequestError: ApiError {
        return ApiError()
        
    }
    
    static var unauthorizedError: ApiError {
        return ApiError()
        
    }
    
    init(friendlyMessage: String) {
        self = ApiError.unexpectedError
        self.friendlyMessage = friendlyMessage
    }
    
    init(code: String,
         eventId: String,
         friendlyMessage: String,
         message: String,
         origin: String,
         type: String) {
        self.code = code
        self.eventId = eventId
        self.friendlyMessage = friendlyMessage
        self.message = message
        self.origin = origin
        self.type = type
    }
    
    init(data: Data?) {
        self = ApiError()
    }
}
