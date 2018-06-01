//
//  ViewController.swift
//  MVVM-IOS
//
//  Created by ditclear on 2018/6/1.
//  Copyright © 2018年 ditclear. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    
    @IBOutlet weak var resultOutlet: UILabel!
    
    @IBOutlet weak var loadingOutlet: UIActivityIndicatorView!
    
    let mViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingOutlet.isHidden = true
        
        let usernameDriver = usernameOutlet.rx.text.orEmpty
        let passwordDriver = passwordOutlet.rx.text.orEmpty
        let loginDriver = loginOutlet.rx.tap.asDriver()
        let resultDriver = resultOutlet.rx.text
        
        usernameDriver.asDriver().drive(mViewModel.userName).disposed(by: disposeBag)
        passwordDriver.asDriver().drive(mViewModel.password).disposed(by: disposeBag)
        
        mViewModel.userName.asDriver().drive(usernameDriver).disposed(by: disposeBag)
        mViewModel.password.asDriver().drive(passwordDriver).disposed(by: disposeBag)
        
        mViewModel.result.asDriver().drive(resultDriver).disposed(by: disposeBag)
        
        
        Driver.combineLatest(mViewModel.userName.asDriver(),mViewModel.password.asDriver()){($0.count>5&&$1.count>5)}
            .drive(onNext: { [weak self] valid in
                self?.loginOutlet.isEnabled = valid
                self?.loginOutlet.alpha = valid ? 1.0:0.5
            }).disposed(by: disposeBag)
        
        loginDriver.drive(onNext: { [weak self] _ in
            print("tap")
            self?.login()
        }).disposed(by: disposeBag)
    }
    
    private func login() {
        mViewModel.signup()
            .do(onSubscribe: {
                print("onSubscribe")
                self.loadingOutlet.isHidden = false
                self.loadingOutlet.startAnimating()
                self.loginOutlet.isEnabled = false
                self.loginOutlet.alpha = 0.5
                self.usernameOutlet.isEnabled = false
                self.passwordOutlet.isEnabled = false
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext :{ success in
                print("onNext")
                self.resultOutlet.textColor = UIColor.darkText
            },onError : { error in
                print("onError")
                self.resultOutlet.textColor = UIColor.red
            }, onDisposed : {
                print("onDisposed")
                self.loginOutlet.isEnabled = true
                self.loginOutlet.alpha = 1.0
                self.usernameOutlet.isEnabled = true
                self.passwordOutlet.isEnabled = true
                self.loadingOutlet.isHidden = true
                self.loadingOutlet.stopAnimating()
            }).disposed(by: disposeBag)
    }
    
    
    
}

