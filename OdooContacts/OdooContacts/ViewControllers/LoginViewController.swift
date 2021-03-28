//
//  LoginViewController.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/22/21.
//

import UIKit

class LoginViewController: BaseViewController, XMLParserDelegate {
  
  private let databaseUrlTextField = UITextField()
  private let databaseNameTextField = UITextField()
  private let loginTextField = UITextField()
  private let passwordTextField = UITextField()
  private let loginButton = UIButton()
  private let cancelButton = UIButton()
  
  var items: [UIView] = []
  var viewModel: LoginViewModel?
  var authenticateModel: AuthenticateModel?
  
  convenience init() {
    self.init(viewModel: nil)
  }
  
  init(viewModel: LoginViewModelImpl?) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    items = [databaseUrlTextField, databaseNameTextField, loginTextField, passwordTextField, loginButton, cancelButton]
    items.forEach { item in
      self.view.addSubview(item)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let margin: CGFloat = 40
    databaseUrlTextField.pin.top(margin).horizontally(margin).height(Sizes.textHeight)
    
    var previous: UIView = databaseUrlTextField
    items.dropFirst().forEach {
      $0.pin.below(of: previous).marginTop(margin).horizontally(margin).height(Sizes.textHeight)
      previous = $0
    }
  }
  
  override func setupDesign() {
    super.setupDesign()
    loginButton.backgroundColor = .green
    loginButton.setTitle("Login", for: .normal)
    
    cancelButton.backgroundColor = .red
    cancelButton.setTitle("Cancel", for: .normal)
    
    databaseUrlTextField.placeholder = "Database url"
    databaseUrlTextField.autocapitalizationType = .none
    
    databaseNameTextField.placeholder = "Database"
    databaseNameTextField.autocapitalizationType = .none
    
    loginTextField.placeholder = "Login"
    loginTextField.autocapitalizationType = .none
    
    passwordTextField.placeholder = "Password"
    passwordTextField.autocapitalizationType = .none
  }
  
  override func setupSubscriptions() {
    super.setupSubscriptions()
    loginButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      let authenticateModel = AuthenticateModel(databaseUrl: self.databaseUrlTextField.text,
                                                databaseName: self.databaseNameTextField.text,
                                                username: self.loginTextField.text,
                                                password: self.passwordTextField.text)
      self.authenticateModel = authenticateModel
      self.viewModel?.authenticateModelObserver.onNext(authenticateModel)
    }).disposed(by: disposeBag)
    
    viewModel?.userIdIsReadyObservable.subscribe(onNext: { [weak self] userId in
      guard let self = self else { return }
      DispatchQueue.main.async {
        let contactsViewModel = ContactsViewModelImpl(authenticateModel: self.authenticateModel, userId: userId)
        let viewController = ContactsViewController(viewModel: contactsViewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(viewController, animated: true)
      }
    }).disposed(by: disposeBag)
    
    cancelButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      self.databaseUrlTextField.text = nil
      self.databaseNameTextField.text = nil
      self.loginTextField.text = nil
      self.passwordTextField.text = nil
    }).disposed(by: disposeBag)
  }
  
  override func setupNavigationController() {
    super.setupNavigationController()
    self.navigationItem.title = "Login"
  }
}
