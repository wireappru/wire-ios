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

extension IconLabelButton {
    
    static let width: CGFloat = 64
    static let height: CGFloat = 88
    
    static func speaker() -> IconLabelButton {
        return .init(
            icon: .speaker,
            label: "voice.speaker_button.title".localized,
            accessibilityId: "CallSpeakerButton"
        )
    }
    
    static func acceptCall() -> IconLabelButton {
        return .init(
            icon: .phone,
            label: "voice.accept_button.title".localized,
            accessibilityId: "AcceptButton",
            backgroundColor: ZMAccentColor.strongLimeGreen.color,
            iconColor: .white,
            borderWidth: 0
        )
    }
    
    static func endCall() -> IconLabelButton {
        return .init(
            icon: .endCall,
            label: "voice.hang_up_button.title".localized,
            accessibilityId: "LeaveCallButton",
            backgroundColor: ZMAccentColor.vividRed.color,
            iconColor: .white,
            borderWidth: 0
        )
    }
    
    static func muteCall() -> IconLabelButton {
        return .init(
            icon: .microphoneWithStrikethrough,
            label: "voice.mute_button.title".localized,
            accessibilityId: "CallMuteButton"
        )
    }
    
    static func video() -> IconLabelButton {
        return .init(
            icon: .videoCall,
            label: "voice.video_button.title".localized,
            accessibilityId: "CallVideoButton"
        )
    }
    
    static func flipCamera() -> IconLabelButton {
        return .init(
            icon: .cameraSwitch,
            label: "voice.flip_video_button.title".localized,
            accessibilityId: "CallFlipCameraButton"
        )
    }
    
    // MARK: - Helper
    
    fileprivate convenience init(
        icon: ZetaIconType,
        label: String,
        accessibilityId: String,
        backgroundColor: UIColor? = nil,
        iconColor: UIColor? = nil,
        borderWidth: CGFloat? = nil
        ) {
        self.init()
        iconButton.setIcon(icon, with: .small, for: .normal)
        subtitleLabel.text = label
        titleLabel?.font = FontSpec(.small, .light).font!
        accessibilityIdentifier = accessibilityId
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor.apply(papply(flip(iconButton.setBackgroundImageColor), .normal))
        iconColor.apply(papply(flip(iconButton.setIconColor), .normal))
        borderWidth.apply { iconButton.borderWidth = $0 }
        widthAnchor.constraint(equalToConstant: IconLabelButton.width).isActive = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: IconLabelButton.height).isActive = true
    }
}
