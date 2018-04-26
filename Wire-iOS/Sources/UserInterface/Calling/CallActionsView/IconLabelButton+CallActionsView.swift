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

enum CallActionColorConfiguration {
    case audio, video
    
    var backgroundColorNormal: UIColor {
        switch self {
        case .audio: return UIColor.wr_color(fromColorScheme: ColorSchemeColorGraphite, variant: .light).withAlphaComponent(0.08)
        case .video: return UIColor.white.withAlphaComponent(0.24)
        }
    }
    
    var backgroundColorSelected: UIColor {
        switch self {
        case .audio: return UIColor.wr_color(fromColorScheme: ColorSchemeColorGraphite, variant: .light)
        case .video: return .white
        }
    }
    
    var iconColorNormal: UIColor {
        switch self {
        case .audio: return .black
        case .video: return .white
        }
    }

    var iconColorSelected: UIColor {
        switch self {
        case .audio: return .white
        case .video: return .black
        }
    }
}

extension IconButton {
    
    static let width: CGFloat = 64
    static let height: CGFloat = 64
    
    static func acceptCall() -> IconButton {
        return .init(
            icon: .phone,
            accessibilityId: "AcceptButton",
            backgroundColor: ZMAccentColor.strongLimeGreen.color,
            iconColor: .white
        )
    }
    
    static func endCall() -> IconButton {
        return .init(
            icon: .endCall,
            accessibilityId: "LeaveCallButton",
            backgroundColor: ZMAccentColor.vividRed.color,
            iconColor: .white
        )
    }
    
    fileprivate convenience init(
        icon: ZetaIconType,
        accessibilityId: String,
        backgroundColor: UIColor,
        iconColor: UIColor
        ) {
        self.init()
        circular = true
        setIcon(icon, with: .small, for: .normal)
        titleLabel?.font = FontSpec(.small, .light).font!
        accessibilityIdentifier = accessibilityId
        translatesAutoresizingMaskIntoConstraints = false
        setBackgroundImageColor(backgroundColor, for: .normal)
        setIconColor(iconColor, for: .normal)
        borderWidth = 0
        widthAnchor.constraint(equalToConstant: IconButton.width).isActive = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: IconButton.width).isActive = true
    }
    
}

extension IconLabelButton {
    
    private static let width: CGFloat = 64
    private static let height: CGFloat = 88
    
    static func speaker() -> IconLabelButton {
        return .init(
            icon: .speaker,
            label: "voice.speaker_button.title".localized,
            accessibilityId: "CallSpeakerButton"
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
        accessibilityId: String
        ) {
        self.init()
        iconButton.setIcon(icon, with: .small, for: .normal)
        subtitleLabel.text = label
        titleLabel?.font = FontSpec(.small, .light).font!
        accessibilityIdentifier = accessibilityId
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: IconLabelButton.width).isActive = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: IconLabelButton.height).isActive = true
    }
    
    func apply(configuration: CallActionColorConfiguration) {
        iconButton.setBackgroundImageColor(configuration.backgroundColorNormal, for: .normal)
        iconButton.setBackgroundImageColor(configuration.backgroundColorSelected, for: .selected)
        iconButton.setBackgroundImageColor(configuration.backgroundColorNormal.withAlphaComponent(0.4), for: .disabled)
        iconButton.setBackgroundImageColor(configuration.backgroundColorSelected.withAlphaComponent(0.4), for: [.disabled, .selected])
        iconButton.setIconColor(configuration.iconColorNormal, for: .normal)
        iconButton.setIconColor(configuration.iconColorSelected, for: .selected)
        iconButton.setIconColor(configuration.iconColorNormal.withAlphaComponent(0.4), for: .disabled)
        iconButton.setIconColor(configuration.iconColorSelected.withAlphaComponent(0.4), for: [.disabled, .selected])
        setTitleColor(configuration.iconColorNormal, for: .normal)
        setTitleColor(configuration.iconColorNormal.withAlphaComponent(0.4), for: .disabled)
    }
}
