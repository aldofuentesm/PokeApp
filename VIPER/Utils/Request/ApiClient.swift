//
//  APIClient.swift
//  ApiGateway
//
//  Created by gbmlocaladmin on 06/03/18.
//  Copyright © 2018 GBM. All rights reserved.
//

import Foundation

enum StatusCode: Int {
    case success             = 200
    case created             = 201
    case accepted            = 202
    case noContent           = 204
    case partialContent      = 206
    case badRequest          = 400
    case unauthorized        = 401
    case forbidden           = 403
    case notFound            = 404
    case internalServerError = 500
    case serviceUnavailable  = 503
}

protocol ApiClient {
    func execute<T>(request: ApiRequest,
                    completion: @escaping (_ result: ApiResult<ApiResponse<T>>) -> Void)
}

class ApiClientImplementation: NSObject, ApiClient {
    static let timeOut = 240.0
    static let emptyExplicit = "\"\""
    
    var urlSession: URLSession!
    
    override init() {
        super.init()
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    fileprivate func requestDataLog(requestLog: inout String, log: String) {
        requestLog = requestLog + "\n" + log
    }
    
    func execute<T>(request: ApiRequest, completion: @escaping (ApiResult<ApiResponse<T>>) -> Void) {
        
        guard let urlRequest = request.urlRequest else {
            DispatchQueue.main.async {
                completion(.failure(ApiError.unexpectedError))
            }
            return
        }
        let absoluteString = urlRequest.url?.absoluteString ?? ""
        var requestLog = ""
        requestDataLog(requestLog: &requestLog, log: "Request: \(absoluteString)")
        requestDataLog(requestLog: &requestLog, log: "Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        requestDataLog(requestLog: &requestLog, log: "Method: \(urlRequest.httpMethod ?? "")")
        if let httpBody = urlRequest.httpBody {
            requestDataLog(requestLog: &requestLog, log: "HttpBody: \(String.init(data: httpBody, encoding: String.Encoding.utf8) ?? "")")
        }
        requestDataLog(requestLog: &requestLog, log: "----------------")
        let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            var responseLog = ""
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(ApiError.networkRequestError)) }
                return
            }
            self?.requestDataLog(requestLog: &responseLog, log: "Response: \(absoluteString)")
            self?.requestDataLog(requestLog: &responseLog, log: "StatusCode: \(httpUrlResponse.statusCode)")
            if let response = data {
                let logString = String(data: response, encoding: .utf8) ?? ""
                self?.requestDataLog(requestLog: &responseLog, log: "Data: \(logString)")
            } else {
                self?.requestDataLog(requestLog: &responseLog, log: "No data")
            }
            self?.requestDataLog(requestLog: &responseLog, log: "----------------")
            if httpUrlResponse.statusCode == StatusCode.success.rawValue ||
                httpUrlResponse.statusCode == StatusCode.noContent.rawValue ||
                httpUrlResponse.statusCode == StatusCode.created.rawValue ||
                httpUrlResponse.statusCode == StatusCode.accepted.rawValue {
                do {
                    let response = data?.count == .zero ? try ApiResponse<T>() : try ApiResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    if let response = try? ApiResponse<T>(),
                        let responseString = String(data: data ?? Data(), encoding: .utf8),
                       responseString == ApiClientImplementation.emptyExplicit {
                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                        return
                    }
                    self?.handleError(request, data, response, error)
                    DispatchQueue.main.async {
                        completion(.failure(ApiError.unexpectedError))
                    }
                }
            } else {
                self?.handleError(request, data, response, error)
                DispatchQueue.main.async {
                    switch httpUrlResponse.statusCode {
                    case StatusCode.unauthorized.rawValue,
                         StatusCode.serviceUnavailable.rawValue:
                        completion(.failure(ApiError.unauthorizedError))
                        
                    case StatusCode.notFound.rawValue:
                        completion(.failure(ApiError.notFundError))
                        
                    default:
                        completion(.failure(ApiError.notFundError))
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    fileprivate func handleError(_ request: ApiRequest,
                                 _ data: Data?,
                                 _ response: URLResponse?,
                                 _ error: Error?) {
        var value = ""
        var statusCode = ""
        
        if let response = data {
            value = String.init(data: response, encoding: .utf8) ?? ""
        }
        if let httpUrlResponse = response as? HTTPURLResponse {
            statusCode = "\(httpUrlResponse.statusCode)"
        }
        let absoluteString = request.urlRequest?.url?.absoluteString ?? ""
        var requestErrorLog = ""
        requestDataLog(requestLog: &requestErrorLog, log: "Error Request: \(absoluteString)")
        requestDataLog(requestLog: &requestErrorLog, log: "StatusCode: \(statusCode)")
        requestDataLog(requestLog: &requestErrorLog, log: "Error: \(String(describing: error))")
        requestDataLog(requestLog: &requestErrorLog, log: "Response: \(value)")
    }
    
    var configuration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ApiClientImplementation.timeOut
        configuration.timeoutIntervalForResource = ApiClientImplementation.timeOut
        return configuration
    }
}

struct host {
    fileprivate static let keyServerAdvisorURL   = "ServerAdvisorURL"
    fileprivate static let keyServerApiGbmURL    = "ServerApiGbmURL"
    fileprivate static let keyServerCaptchaURL   = "ServerCaptchaURL"
    fileprivate static let keyServerFractionals  = "ServerFractionalsURL"
    fileprivate static let keyServerMockURL      = "ServerMockURL"
    fileprivate static let keyServerPatronURL    = "ServerPatronURL"
    fileprivate static let keyServerPiggoURL     = "ServerPiggoURL"
    fileprivate static let keyServerPublicGbmURL = "ServerPublicGbmURL"
    fileprivate static let keyServerURL          = "ServerURL"
    static let advisor        = Bundle.main.infoDictionary?[keyServerAdvisorURL] as! String
    static let captchaBaseUrl = Bundle.main.infoDictionary?[keyServerCaptchaURL] as! String
    static let fractionals    = Bundle.main.infoDictionary?[keyServerFractionals] as! String
    static let gbm            = Bundle.main.infoDictionary?[keyServerApiGbmURL] as! String
    static let homebroker     = Bundle.main.infoDictionary?[keyServerURL] as! String
    static let mock           = Bundle.main.infoDictionary?[keyServerMockURL] as! String
    static let patron         = Bundle.main.infoDictionary?[keyServerPatronURL] as! String
    static let piggo          = Bundle.main.infoDictionary?[keyServerPiggoURL] as! String
    static let publicGbm      = Bundle.main.infoDictionary?[keyServerPublicGbmURL] as! String
}

struct ExternalLink {
    static let academy              = "https://academy.gbm.com"
    static let blog                 = "https://blog.gbm.com"
    static let curp                 = "https://www.gob.mx/curp"
    static let fiel                 = "https://portalsat.plataforma.sat.gob.mx/RecuperacionDeCertificados/"
    static let singNowPDF           = "https://gbmhomebroker.com/pdf/Manual-GBM-SignNow.pdf"
    static let serviceGuide         = "https://gbm.com/wp-content/uploads/2021/03/Guia-de-Servicios-GBM_v0321.pdf"
    static let privacyAnnouncement  = "https://auth.gbm.com/docs/aviso-de-privacidad.pdf"
    static let siteGBM              = "https://www.gbm.com"
    static let faqs                 = "https://comunidad.gbm.com/s/"
    static let fractionalsWaitList  = "https://gbm.com/waitlist/"
    static let termsAndConditions   = host.publicGbm + "docs/Terminos_y_Condiciones.pdf"
    static let thumbnailOnboarding  = host.publicGbm + "assets/iOS/video/thumbnail.png"
    static let videoGBM             = host.publicGbm + "assets/iOS/video/onboarding.mp4"
    static let videoGBMPosition     = host.publicGbm + "assets/iOS/video/onboarding_position.mp4"
    static let videoSmartCash       = host.publicGbm + "assets/iOS/video/onboarding_sc.mp4"
    static let videoWealth          = host.publicGbm + "assets/iOS/video/onboarding_wm.mp4"
    static let videoTrading         = host.publicGbm + "assets/iOS/video/onboarding_trading.mp4"
    static let videoRewardsExchange = host.publicGbm + "assets/iOS/video/rewards_exchange.mp4"
    static let videoRewardsShare    = host.publicGbm + "assets/iOS/video/trading_rewards.mp4"
}

struct HttpMethod {
    static let GET    = "GET"
    static let POST   = "POST"
    static let PUT    = "PUT"
    static let DELETE = "DELETE"
    static let PATCH  = "PATCH"
}

struct EndPoint {
    static let addIssueWatchList    = "/api/Market/AddIssueWatchList"
    static let addWatchList         = "/api/Market/AddWatchList"
    static let deleteIssueWatchList = "/api/Market/DeleteIssueWatchList"
    static let getWatchList         = "/api/Market/GetWatchList"
    static let getWatchListDetail   = "/api/Market/GetWatchListDetail"
    static let registerWithdrawal   = "/api/Operation/RegisterWithdrawal"
    static let getCashOperations    = "/api/Operation/GetIntradayCashOperations"
    static let getPartyInfo         = "/v1/parties"
    
    struct Formatter {
        static let issuerWithWatchListType = "%@%@/%@/%d"
    }
    
    struct ContractOpening {
        static let batch = "/batch"
        static let fiel = "/fiel"
        static let rfc = "/rfc"
    }
}

extension ApiClientImplementation: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            challenge.sender!.use(URLCredential(trust: challenge.protectionSpace.serverTrust!), for: challenge)
            challenge.sender!.continueWithoutCredential(for: challenge)
        }
        if challenge.previousFailureCount > 0 {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        }
    }
}
