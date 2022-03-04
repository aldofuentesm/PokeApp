//
//  APIResponse.swift
//  ApiGateway
//
//  Created by gbmlocaladmin on 06/03/18.
//  Copyright © 2018 GBM. All rights reserved.
//

import UIKit

protocol InitializableWithData {
    init(data: Data?) throws
}

protocol InitializableWithJson {
    init(json: [String: Any]) throws
}

struct ApiParseError: Error {
    static let code = 999
    let error: Error
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    var localizedDescription: String {
        return error.localizedDescription + " \(error)"
    }
}

struct ApiResponse<T: InitializableWithData> {
    let entity: T?
    let httpUrlResponse: HTTPURLResponse?
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        do {
            self.entity = try T(data: data)
            self.httpUrlResponse = httpUrlResponse
            self.data = data
        } catch {
            throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
 
    init() throws {
        let data = Data()
        self.entity = try? T(data: data)
        self.httpUrlResponse = nil
        self.data = data
    }
}

extension Array: InitializableWithData {
    init(data: Data?) throws {
        guard let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let jsonArray = jsonObject as? [[String: Any]] else {
                throw NSError.createParseError()
        }
        
        guard let element = Element.self as? InitializableWithJson.Type else {
            throw NSError.createParseError()
        }
        
        self = try jsonArray.map({
            return try element.init(json: $0) as! Element
        })
    }
}

extension NSError {
    static func createParseError() -> NSError {
        return NSError(domain: "homebroker",
                       code: ApiParseError.code,
                       userInfo: [NSLocalizedDescriptionKey: "A parsing error occured"])
    }
}

extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customDecodeDate
        do {
            return try decoder.decode(Self.self, from: data)
        } catch {
        }
        return try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .customEncodeDate
        return try encoder.encode(self)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customDecodeDate = custom({ decoder -> Date in
        let container = try decoder.singleValueContainer()
        var string = try container.decode(String.self)
        let components = string.components(separatedBy: ".")
        if components.count == 2 && components[0].count <= 6 {
            string = components[0] + "Z"
        }
        if let date = Formatter.baseFormatCodable.date(from: string) ?? ISO8601DateFormatter().date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    })
}

extension JSONEncoder.DateEncodingStrategy {
    static let customEncodeDate = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.baseFormatCodable.string(from: $0))
    }
}

extension Formatter {
    static let baseFormatCodable: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "es_MX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return formatter
    }()
}
