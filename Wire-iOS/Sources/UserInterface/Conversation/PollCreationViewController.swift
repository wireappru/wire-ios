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
    public var questionText: UITextField!
    public var toolbarText: UILabel!
    var conversation: ZMConversation!
    private var maxOptionSoFar = 0
    
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
        stack.spacing = 10.0
        self.view.addSubview(container)
        
        constrain(self.view, container) {
            view, container in
            container.edges == inset(view.edges, 24, 0)
        }
        container.addSubview(stack)
        
        let toolbar = UIView()
        container.addSubview(toolbar)
        
        let question = UITextField()
        question.placeholder = "Question"
        question.text = "What do you think?"
        question.textAlignment = .center
        container.addSubview(question)
        
        constrain(container, stack, toolbar, question) {
            container, stack, toolbar, question in
            toolbar.leading == container.leading
            toolbar.trailing == container.trailing
            toolbar.top == container.top + 20.0
            toolbar.height == 40.0
            
            question.leading == container.leading
            question.trailing == container.trailing
            question.bottom == stack.top - 20.0
            
            stack.leading == container.leading
            stack.trailing == container.trailing
            stack.bottom == container.bottom - 100.0
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
        
        let toolbarText = UILabel()
        toolbarText.text = "Create poll"
        toolbarText.textAlignment = .center
        toolbar.addSubview(toolbarText)
        
        constrain(toolbar, dismissButton, sendButton, toolbarText) {
            toolbar, dismiss, send, text in
            
            text.top == toolbar.top
            text.bottom == toolbar.bottom
            text.trailing == send.leading
            text.leading == dismiss.trailing
            
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
        addButton.setIcon(.plusCircled, with: .medium, for: .normal)
        addButton.addTarget(self, action: #selector(self.addOptionButtonTapped(_:)), for: .touchUpInside)
        stack.addArrangedSubview(addButton)
        
        self.stackView = stack
        self.questionText = question
        self.toolbarText = toolbarText
        
        addOptionButtonTapped(self)
        addOptionButtonTapped(self)
        addOptionButtonTapped(self)
        
        
    }
    
    func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func addOptionButtonTapped(_ sender: Any) {
        guard let stack = self.stackView as? UIStackView else { return }
        self.maxOptionSoFar += 1
        let option = PollCreationOptionView(stack: stack, label: "Option \(self.maxOptionSoFar)")
        guard let plusButton = stack.arrangedSubviews.last else { return }
        stack.removeArrangedSubview(plusButton)
        stack.addArrangedSubview(option)
        stack.addArrangedSubview(plusButton)
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

@available(iOS 9.0, *)
public class PollCreationOptionView: UIView {
    
    public let textView: UITextField
    var text: String? {
        return textView.text
    }
    
    private weak var stack: UIStackView?
    
    init(stack: UIStackView, label: String) {
        let icon = IconButton()
        icon.setIcon(.cancel, with: .tiny, for: .normal)
        icon.setIconColor(.lightGray, for: .normal)
        
        let text = UITextField()
        text.placeholder = "Option"
        text.text = label
        self.textView = text
        
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        self.stack = stack
        self.addSubview(text)
        self.addSubview(icon)
        
        constrain(self, icon, text) {
            view, icon, text in
            icon.top == view.top
            icon.bottom == view.bottom
            icon.trailing == view.trailing
            icon.leading == text.trailing
            text.top == view.top
            text.bottom == view.bottom
            text.leading == view.leading
            icon.width == 40.0
        }
        
        icon.addTarget(self, action: #selector(didRemove(_:)), for: .touchUpInside)
    }
    
    public func didRemove(_ sender: Any?) {
        self.stack?.removeArrangedSubview(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
}
