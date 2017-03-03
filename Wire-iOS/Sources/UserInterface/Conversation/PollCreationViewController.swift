//
//  PollCreationViewController.swift
//  Wire-iOS
//
//  Created by Marco Conti on 03/03/2017.
//  Copyright © 2017 Zeta Project Germany GmbH. All rights reserved.
//

import Foundation


import ZMCDataModel
import Cartography
import MapKit
import CoreLocation

//@available(iOS 9.0, *)
@objc final public class PollCreationViewController: UIViewController {
    
    private var stackView: UIView!
    var conversation: ZMConversation!
    
    public init(forPopoverPresentation popover: Bool) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, user 'init(forPopoverPresentation:)'")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 9.0, *) {
            configureViews()
        }
    }
    
    @available(iOS 9.0, *)
    fileprivate func configureViews() {
        let container = UIView()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        self.view.addSubview(container)
        
        constrain(self.view, container) {
            view, container in
            container.edges == inset(view.edges, 24, 0)
        }
        container.addSubview(stack)
        
        let toolbar = UIView()
        container.addSubview(toolbar)
        
        let question = UITextField()
        question.placeholder = "What's the question?"
        container.addSubview(question)
        
        constrain(container, stack, toolbar, question) {
            container, stack, toolbar, question in
            toolbar.leading == container.leading
            toolbar.trailing == container.trailing
            toolbar.top == container.top + 20.0
            toolbar.height == 40.0
            
            question.leading == container.leading
            question.trailing == container.trailing
            question.top == toolbar.bottom + 10.0
            
            stack.leading == container.leading
            stack.trailing == container.trailing
            stack.top == question.bottom + 10.0
        }
        
        let dismissButton = IconButton()
        dismissButton.setIcon(.cancel, with: .tiny, for: .normal)
        dismissButton.setIconColor(.lightGray, for: .normal)
        dismissButton.addTarget(self, action: #selector(self.dismissButtonTapped(_:)), for: .touchUpInside)
        toolbar.addSubview(dismissButton)
        
        let sendButton = IconButton()
        sendButton.setIcon(.send, with: .medium, for: .normal)
        sendButton.addTarget(self, action: #selector(self.sendButtonTapped(_:)), for: .touchUpInside)

        toolbar.addSubview(sendButton)
        
        constrain(toolbar, dismissButton, sendButton) {
            toolbar, dismiss, send in
            
            send.top == toolbar.top
            send.trailing == toolbar.trailing
            send.bottom == toolbar.bottom
            dismiss.width == 40.0
            
            dismiss.top == toolbar.top
            dismiss.leading == toolbar.leading
            dismiss.bottom == toolbar.bottom
            dismiss.width == 40.0
        }
        
        let addButton = IconButton()
        addButton.setIcon(.plusCircled, with: .tiny, for: .normal)
        
        self.stackView = stack
        
        addOptionButtonTapped(self)
        addOptionButtonTapped(self)
        addOptionButtonTapped(self)
    }
    
    func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func addOptionButtonTapped(_ sender: Any) {
        if #available(iOS 9.0, *) {
            guard let stack = self.stackView as? UIStackView else { return }
            let text = UITextField()
            text.placeholder = "Option \(stack.arrangedSubviews.count+1)"
            stack.addArrangedSubview(text)
        }
    }
    
    public override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIViewController.wr_supportedInterfaceOrientations()
    }

    public func sendButtonTapped(_ viewController: PollCreationViewController) {
        ZMUserSession.shared()?.performChanges {
            self.conversation.appendPoll(options: ["Cat", "Dog", "Bird"])
        }
        dismiss(animated: true, completion: nil)
    }
}
