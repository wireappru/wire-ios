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
        case .audio: return .wr_color(fromColorScheme: ColorSchemeColorIconNormal, variant: .light)
        case .video: return .wr_color(fromColorScheme: ColorSchemeColorIconNormal, variant: .dark)
        }
    }
    
    var iconColorNormal: UIColor {
        switch self {
        case .audio: return .wr_color(fromColorScheme: ColorSchemeColorIconNormal, variant: .light)
        case .video: return .wr_color(fromColorScheme: ColorSchemeColorIconNormal, variant: .dark)
        }
    }

    var iconColorSelected: UIColor {
        switch self {
        case .audio: return .wr_color(fromColorScheme: ColorSchemeColorIconNormal, variant: .dark)
        case .video: return .wr_color(fromColorScheme: ColorSchemeColorIconNormal, variant: .light)
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

class IconLabelButton: ButtonWithLargerHitArea {
    private static let width: CGFloat = 64
    private static let height: CGFloat = 88
    
    private(set) var iconButton = IconButton()
    private(set) var subtitleLabel = UILabel()
    
    var configuration: CallActionColorConfiguration = .video {
        didSet {
            updateState()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
        createConstraints()
    }
    
    fileprivate convenience init(
        icon: ZetaIconType,
        label: String,
        accessibilityId: String
        ) {
        self.init()
        iconButton.setIcon(icon, with: .small, for: .normal)
        subtitleLabel.text = label
        accessibilityIdentifier = accessibilityId
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateState()
    }
    
    private func setupViews() {
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        iconButton.isUserInteractionEnabled = false
        iconButton.borderWidth = 0
        iconButton.circular = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textTransform = .upper
        subtitleLabel.textAlignment = .center
        titleLabel?.font = FontSpec(.small, .light).font!
        [iconButton, subtitleLabel].forEach(addSubview)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: IconLabelButton.width),
            heightAnchor.constraint(greaterThanOrEqualToConstant: IconLabelButton.height),
            iconButton.widthAnchor.constraint(equalToConstant: IconLabelButton.width),
            iconButton.heightAnchor.constraint(equalToConstant: IconLabelButton.width),
            iconButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconButton.topAnchor.constraint(equalTo: topAnchor),
            iconButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func updateState() {
        apply(configuration)
        subtitleLabel.font = titleLabel?.font
        subtitleLabel.textColor = titleColor(for: state)
    }
    
    override var isHighlighted: Bool {
        didSet {
            iconButton.isHighlighted = isHighlighted
            updateState()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            iconButton.isSelected = isSelected
            updateState()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            iconButton.isEnabled = isEnabled
            updateState()
        }
    }
    
    private func apply(_ configuration: CallActionColorConfiguration) {
        iconButton.setBackgroundImageColor(configuration.backgroundColorNormal, for: .normal)
        iconButton.setBackgroundImageColor(configuration.backgroundColorSelected, for: .selected)
        
        iconButton.setIconColor(configuration.iconColorNormal, for: .normal)
        iconButton.setIconColor(configuration.iconColorSelected, for: .selected)

        setTitleColor(configuration.iconColorNormal, for: .normal)
        setTitleColor(configuration.iconColorNormal.withAlphaComponent(0.4), for: .disabled)
        setTitleColor(configuration.iconColorNormal.withAlphaComponent(0.4), for: [.disabled, .selected])
        
        iconButton.setIconColor(configuration.iconColorNormal.withAlphaComponent(0.4), for: .disabled)
        iconButton.setBackgroundImageColor(configuration.backgroundColorNormal, for: .disabled)

        iconButton.setIconColor(configuration.iconColorSelected.withAlphaComponent(0.4), for: [.disabled, .selected])
        iconButton.setBackgroundImageColor(configuration.backgroundColorSelected, for: [.disabled, .selected])
    }
    
}

extension IconLabelButton {

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
    
}
