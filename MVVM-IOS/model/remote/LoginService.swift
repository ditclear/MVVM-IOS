//
//  LoginService.swift
//  MVVM-IOS
//
//  Created by ditclear on 2018/6/1.
//  Copyright © 2018年 ditclear. All rights reserved.
//

import Foundation
import RxSwift

enum LoginService {
    
    static func login(_ username: String, _ password:String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map{ pair in
                if pair.response.statusCode == 404 {
                    throw NSError(domain: "not found", code: 404)
                }
                return true
        }
        .catchErrorJustReturn(false)
        
    }
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
