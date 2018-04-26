//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
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

import XCTest
@testable import Wire

fileprivate struct CallActionsViewInput: CallActionsViewInputType {
    let isMuted, canAccept: Bool
    let videoState: VideoState
    let accessoryButtonState: AccessoryButtonState
}

class CallActionsViewTests: ZMSnapshotTestCase {
    
    fileprivate var sut: CallActionsView!
    fileprivate var widthConstraint: NSLayoutConstraint!

    override func setUp() {
        super.setUp()
        recordMode = true
        snapshotBackgroundColor = .lightGray
        sut = CallActionsView()
        sut.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = sut.widthAnchor.constraint(equalToConstant: 340)
        widthConstraint.isActive = true
        sut.setNeedsLayout()
        sut.layoutIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCallActionsView_NotMuted_CanAccept_VideoUnvailable_FlipCamera() {
        // Given
        let input = CallActionsViewInput(
            isMuted: false,
            canAccept: true,
            videoState: .unavailable,
            accessoryButtonState: .flipCamera
        )
        
        // When
        sut.update(with: input)
        
        // Then
        verify(view: sut)
    }
    
    func testCallActionsView_Muted_CanAccept_VideoUnvailable_FlipCamera() {
        // Given
        let input = CallActionsViewInput(
            isMuted: true,
            canAccept: true,
            videoState: .unavailable,
            accessoryButtonState: .flipCamera
        )
        
        // When
        sut.update(with: input)
        
        // Then
        verify(view: sut)
    }
    
    func testCallActionsView_NotMuted_CanNotAccept_VideoUnvailable_FlipCamera() {
        // Given
        let input = CallActionsViewInput(
            isMuted: false,
            canAccept: false,
            videoState: .unavailable,
            accessoryButtonState: .flipCamera
        )
        
        // When
        sut.update(with: input)
        
        // Then
        verify(view: sut)
    }
    
    func testCallActionsView_NotMuted_CanNotAccept_VideoNotSending_SpearkerDisabled() {
        // Given
        let input = CallActionsViewInput(
            isMuted: false,
            canAccept: false,
            videoState: .notSending,
            accessoryButtonState: .speaker(enabled: false)
        )
        
        // When
        sut.update(with: input)
        
        // Then
        verify(view: sut)
    }
    
    func testCallActionsView_NotMuted_CanNotAccept_VideoNotSending_SpearkerEnabled() {
        // Given
        let input = CallActionsViewInput(
            isMuted: false,
            canAccept: false,
            videoState: .notSending,
            accessoryButtonState: .speaker(enabled: true)
        )
        
        // When
        sut.update(with: input)
        
        // Then
        verify(view: sut)
    }
    
    func testCallActionsView_NotMuted_CanNotAccept_VideoNotSending_SpearkerEnabled_Compact() {
        // Given
        let input = CallActionsViewInput(
            isMuted: false,
            canAccept: false,
            videoState: .notSending,
            accessoryButtonState: .speaker(enabled: true)
        )
        
        // When
        widthConstraint.constant = 400
        sut.isCompact = true
        sut.update(with: input)

        // Then
        verify(view: sut)
    }
    
    func testCallActionsView_Muted_CanAccept_VideoSending_FlipCamera_Compact() {
        // Given
        let input = CallActionsViewInput(
            isMuted: true,
            canAccept: true,
            videoState: .sending,
            accessoryButtonState: .flipCamera
        )
        
        // When
        widthConstraint.constant = 400
        sut.isCompact = true
        sut.update(with: input)
        
        // Then
        verify(view: sut)
    }

}
