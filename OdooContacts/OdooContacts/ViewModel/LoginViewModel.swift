//
//  LoginViewModel.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation
import RxSwift

protocol LoginViewModel: ViewModel {
  var authenticateModelObserver: AnyObserver<AuthenticateModel> { get }
  var userIdIsReadyObservable: Observable<Int> { get }
}

final class LoginViewModelImpl: LoginViewModel {
  
  private let authenticateModelSubject = PublishSubject<AuthenticateModel>()
  var authenticateModelObserver: AnyObserver<AuthenticateModel> {
    return authenticateModelSubject.asObserver()
  }
  
  private let userIdSubject = PublishSubject<Int>()
  var userIdIsReadyObservable: Observable<Int> {
    return userIdSubject.asObservable()
  }
  
  private let disposeBag = DisposeBag()
  private let network = NetworkService()
  private let parser = XMLLoginParseManager()
  
  init() {
    self.initiateSubscriptions()
  }
  
  private func initiateSubscriptions() {
    authenticateModelSubject.asObservable().subscribe(onNext:{ [weak self] model in
      guard let self = self else { return }
      self.network.task(for: .login(model: model), baseUrl: model.databaseUrl)
    }).disposed(by: disposeBag)
    
    network.responseSubject.asObservable().subscribe(onNext: { [weak self] response in
      guard let self = self, let data = response else { return }
      self.parser.decodeXML(data: data)
    }).disposed(by: disposeBag)
    
    parser.userId.asObservable().subscribe(onNext: { [weak self] userId in
      guard let self = self else { return }
      self.userIdSubject.onNext(userId)
    }).disposed(by: disposeBag)
  }
}
