//
//  LoginViewModel.swift
//  MVVM-IOS
//
//  Created by ditclear on 2018/6/1.
//  Copyright © 2018年 ditclear. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    let userName : Variable<String> = Variable("")
    let password : Variable<String> = Variable("")
    let result : Variable<String> = Variable("")
    let signUpValid : Variable<Bool> = Variable(false)
    
    
    
    init() {
        
    }
    
    func signup() -> Observable<Bool> {
        
        print(self.userName.value, self.password.value)
        
        
        return LoginService.login(userName.value, password.value)
            .delay(2, scheduler: MainScheduler.asyncInstance)
            
            .do(onNext: { (success) in
                self.result.value = "登录成功 \(self.userName.value) \(self.password.value)"
            }, onError: { (error) in
                self.result.value = "登录失败，你的用户名或密码错误"
            })
        
    }
    
    
}

