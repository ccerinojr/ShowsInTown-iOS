//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class MessageView: TableViewBackgroundView {
    
    struct Action {
        let title: String
        let handler: () -> ()
    }
    
    var messageText: String? {
        didSet {
            self.updateMessageLabel()
        }
    }
    
    var action: Action? {
        didSet {
            self.updateActionButton()
        }
    }
    
    convenience init(message: String, action: Action?) {
        self.init(frame: .zero)
        self.messageText = message
        self.action = action
        self.updateMessageLabel()
        self.updateActionButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.preservesSuperviewLayoutMargins = true
        self.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.backgroundColor = .clear
        self.container.addArrangedSubview(self.label)
        self.container.addArrangedSubview(self.button)
        self.contentView.addSubview(self.container)
        
        self.container.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        self.container.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor).isActive = true
    }

    //MARK: - Private
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = UIColor.sitLightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        
        return label
    }()
    
    private let button: UIButton = UIButton(frame: .zero)
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc private func buttonTapped() {
        self.action?.handler()
    }
    
    private func updateMessageLabel() {
        self.label.text = messageText
    }
    
    private func updateActionButton() {
        if let title = self.action?.title {
            self.button.setTitle(title, for: .normal)
            self.button.setTitleColor(.sitGreen, for: .normal)
            self.button.isHidden = false
        } else {
            self.button.setTitle(nil, for: .normal)
            self.button.isHidden = true
        }
    }
}
