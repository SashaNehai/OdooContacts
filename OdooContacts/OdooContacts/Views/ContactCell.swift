//
//  ContactCell.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/22/21.
//

import UIKit

class ContactCell: UITableViewCell {
  
  private let nameLabel = UILabel()
  private let phoneLabel = UILabel()
  private let emailLabel = UILabel()
  private let jobLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    nameLabel.pin.top().horizontally(15).height(Sizes.textHeight)
    phoneLabel.pin.below(of: nameLabel).marginTop(0).horizontally(15).height(Sizes.textHeight)
    emailLabel.pin.below(of: phoneLabel).marginTop(0).horizontally(15).height(Sizes.textHeight)
    jobLabel.pin.below(of: emailLabel).marginTop(0).horizontally(15).height(Sizes.textHeight)
  }

  func setupCell() {
    let labels = [jobLabel, nameLabel, phoneLabel, emailLabel]
    
    labels.forEach { label in
      self.contentView.addSubview(label)
    }
  }
  
  func setup(with data: ContactModel) {
    jobLabel.text = "\(data.job)"
    nameLabel.text = data.name
    phoneLabel.text = data.phone
    emailLabel.text = data.email
  }

}
