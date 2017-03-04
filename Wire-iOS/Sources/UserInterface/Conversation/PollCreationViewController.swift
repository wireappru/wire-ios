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

@available(iOS 9.0, *)
@objc final public class PollCreationViewController: UIViewController {
    
    private var stackView: UIView!
    private var questionText: UITextField!
    var conversation: ZMConversation!
    
    public init(forPopoverPresentation popover: Bool) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, user 'init(forPopoverPresentation:)'")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
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
        self.questionText = question
        
        addOptionButtonTapped(self)
        addOptionButtonTapped(self)
        addOptionButtonTapped(self)
    }
    
    func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func addOptionButtonTapped(_ sender: Any) {
        guard let stack = self.stackView as? UIStackView else { return }
        let option = PollCreationOptionView()
        stack.addArrangedSubview(option)
    }
    
    public override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIViewController.wr_supportedInterfaceOrientations()
    }

    public func sendButtonTapped(_ viewController: PollCreationViewController) {
        guard let stack = self.stackView as? UIStackView else { return }
        let choices = stack.arrangedSubviews.flatMap { view -> String? in
            guard let textView = view as? PollCreationOptionView else { return nil }
            guard let text = textView.text, !text.isEmpty else { return nil }
            return text
        }
        guard !choices.isEmpty else { return }
        ZMUserSession.shared()?.performChanges {
            _ = self.conversation.appendPoll(question: self.questionText.text ?? "", options: choices)
        }
        dismiss(animated: true, completion: nil)
    }
}

private class PollCreationOptionView: UIView {
    
    private let textView: UITextField
    var text: String? {
        return textView.text
    }
    
    init() {
        let icon = IconButton()
        icon.setIcon(.checkmark, with: .tiny, for: .normal)
        icon.setIconColor(.lightGray, for: .normal)
        
        let text = UITextField()
        text.placeholder = "Option"
        self.textView = text
        
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        self.addSubview(text)
        self.addSubview(icon)
        
        constrain(self, icon, text) {
            view, icon, text in
            icon.top == view.top
            icon.bottom == view.bottom
            icon.leading == view.leading
            icon.trailing == text.leading
            text.top == view.top
            text.bottom == view.bottom
            text.trailing == view.trailing
            icon.width == 40.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
