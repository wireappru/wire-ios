//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import UIKit

protocol CallActionsViewDelegate: class {
    func callActionsView(_ callActionsView: CallActionsView, perform action: CallActionsViewAction)
}

enum VideoState {
    case sending, notSending, unavailable
}

enum AccessoryButtonState {
    case speaker(enabled: Bool)
    case flipCamera
}

// This protocol describes the input for a `CallActionsView`.
protocol CallActionsViewInput {
    var isMuted: Bool { get }
    var canAccept: Bool { get }
    var videoState: VideoState { get}
    var accessoryButtonState: AccessoryButtonState { get }
}

// The ouput actions a `CallActionsView` can perform.
enum CallActionsViewAction {
    case toggleMuteState
    case toggleVideoState
    case toggleSpeakerState
    case acceptCall
    case terminateCall
    case flipCamera
}

// A view showing multiple buttons depenging on the given `CallActionsView.Input`.
// Button touches result in `CallActionsView.Action` cases to be sent to the objects delegate.
final class CallActionsView: UIView {
    
    
    weak var delegate: CallActionsViewDelegate?
    
    private let verticalStackView = UIStackView(axis: .vertical)
    private let topStackView = UIStackView(axis: .horizontal)
    private let bottomStackView = UIStackView(axis: .horizontal)
    
    // Buttons
    private let muteCallButton = IconLabelButton.muteCall()
    private let videoButton = IconLabelButton.video()
    private let speakerButton = IconLabelButton.speaker()
    private let flipCameraButton = IconLabelButton.flipCamera()
    private let endCallButton = IconLabelButton.endCall()
    private let acceptCallButton = IconLabelButton.endCall()
    
    private var allButtons: [IconLabelButton] {
        return [muteCallButton, videoButton, speakerButton, flipCameraButton, endCallButton, acceptCallButton]
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(verticalStackView)
        allButtons.forEach {
            $0.addTarget(self, action: #selector(performButtonAction), for: .touchUpInside)
        }
    }
    
    private func createConstraints() {
        
    }
    
    // Entry single point for all state changes.
    // All side effects should be started from this method.
    func update(state: CallActionsViewInput) {
        
    }
    
    @objc private func performButtonAction(_ sender: IconLabelButton) {
        delegate?.callActionsView(self, perform: action(for: sender))
    }
    
    private func action(for button: IconLabelButton) -> CallActionsViewAction {
        switch button {
        case muteCallButton: return .toggleMuteState
        case videoButton: return .toggleVideoState
        case speakerButton: return .toggleSpeakerState
        case flipCameraButton: return .flipCamera
        case endCallButton: return .terminateCall
        case acceptCallButton: return .acceptCall
        default: fatalError("Unexpected Button: \(button)")
        }
    }
    
}
