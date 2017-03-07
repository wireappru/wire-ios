//
//  PollCell.swift
//  Wire-iOS
//
//  Created by Marco Conti on 03/03/2017.
//  Copyright © 2017 Zeta Project Germany GmbH. All rights reserved.
//

import Foundation
import Cartography

@available(iOS 9.0, *)
@objc public final class PollCell: ConversationCell {
    
    /// Stack view that will contain the individual options
    fileprivate var optionsStackView: UIStackView!
    
    fileprivate var questionTextLabel: UILabel!
    
    // All icon buttons
    fileprivate var buttons: [PollCellOptionView] = []
    
    public override func configure(for message: ZMConversationMessage!, layoutProperties: ConversationCellLayoutProperties!) {
        self.resetAll()
        super.configure(for: message, layoutProperties: layoutProperties)
        self.setupStackView()
        guard let poll = message.pollMessageData else { return }
        poll.entries.enumerated().forEach {
            self.add(option: $0.1, index: $0.0, votes: poll.votes[$0.1] ?? [])
        }
        self.questionTextLabel.text = poll.question
    }
    
    
    public override func update(forMessage changeInfo: MessageChangeInfo!) -> Bool {
        self.configure(for: changeInfo.message, layoutProperties: nil)
        return false
    }
}

@available(iOS 9.0, *)
extension PollCell {
    
    /// Sets up the stack view that will
    fileprivate func setupStackView() {
        if self.optionsStackView == nil {
            self.optionsStackView = UIStackView()
            self.optionsStackView.axis = .vertical
            self.optionsStackView.spacing = 5.0
            self.messageContentView.addSubview(self.optionsStackView)
            
            self.questionTextLabel = UILabel()
            self.questionTextLabel.numberOfLines = 0
            self.messageContentView.addSubview(self.questionTextLabel)
            
            constrain(self.messageContentView, self.optionsStackView, self.questionTextLabel ) {
                content, stack, question in
                question.top == content.topMargin
                question.leading == content.leadingMargin
                question.trailing == content.trailingMargin
                question.bottom == stack.top - 0.5
                stack.bottom == content.bottomMargin
                stack.leading == content.leadingMargin
                stack.trailing == content.trailingMargin
            }
        }
    }
    
    /// Remove all preview views from the stack
    fileprivate func resetAll() {
        guard let stack = self.optionsStackView else { return }
        let allViews = stack.arrangedSubviews
        allViews.forEach {
            stack.removeArrangedSubview($0)
        }
        self.buttons = []
        let views = self.messageContentView.subviews
        views.forEach {
            $0.removeFromSuperview()
        }
        self.optionsStackView = nil
    }
    
    /// Creates the view for an option and add it
    fileprivate func add(option: String, index: Int, votes: Set<ZMUser>) {
        let noSelfVotes = votes.subtracting(Set([ZMUser.selfUser()]))
        let optionView = PollCellOptionView(option: option, votes: noSelfVotes, selfVote: votes.contains(ZMUser.selfUser())) {
            self.didVote(for: index)
        }
        self.buttons.append(optionView)
        self.optionsStackView.addArrangedSubview(optionView)
    }
    
    func didVote(for index: Int) {
        guard let pollData = self.message.pollMessageData else { return }
        ZMUserSession.shared()?.performChanges {
            pollData.castVote(index: index)
        }
    }

}

public class PollCellOptionView: UIView {
    
    let selectButton: IconButton
    let label: UILabel
    let onVote: ()->()
    let option: String
    public let voters: UILabel
    
    init(option: String, votes: Set<ZMUser>, selfVote: Bool, onVote: @escaping ()->()) {
        self.selectButton = IconButton()
        self.selectButton.setIconColor(.lightGray, for: .normal)
        self.selectButton.setIcon(.liked, with: .tiny, for: .selected)
        self.selectButton.setIconColor(.red, for: .selected)
        self.selectButton.setIcon(.like, with: .tiny, for: .normal)
        
        self.label = UILabel()
        self.label.numberOfLines = 0
        self.label.text = option
        
        self.onVote = onVote
        self.option = option
        
        self.voters = UILabel()
        let totalVoters = votes.count + (selfVote ? 1 : 0)
        if totalVoters > 0 {
            var otherVoters = Array(votes).flatMap { $0.displayName }
            if selfVote {
                otherVoters = ["You"] + otherVoters
            }
            self.voters.text = "+\(totalVoters): " + otherVoters.joined(separator: ", ")
        }
        
        
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))

        self.selectButton.addTarget(self, action: #selector(self.didVoteForOption(_:)), for: .touchUpInside)
        self.addSubview(self.selectButton)
        self.addSubview(self.label)
        self.addSubview(self.voters)
        
        self.selectButton.isSelected = selfVote

        constrain(self, self.label, self.selectButton, self.voters) {
            cell, label, button, voters in
            button.leading == cell.leading
            button.trailing == label.leading
            button.top == label.top
            button.bottom == label.bottom
            label.trailing == cell.trailing
            label.top == cell.top
            button.width == 40.0
            voters.top == label.bottom
            voters.bottom == cell.bottom
            voters.trailing == cell.trailing
            voters.leading == cell.leading
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func didVoteForOption(_ sender: Any) {
        self.onVote()
    }
}
