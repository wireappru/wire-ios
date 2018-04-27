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
    let canToggleMediaType, isAudioCall, isMuted, canAccept, isTerminating: Bool
    let mediaState: MediaState
}

class IconLabelButtonTests: ZMSnapshotTestCase {
    
    fileprivate var button: IconLabelButton!
    
    override func setUp() {
        super.setUp()
        snapshotBackgroundColor = .darkGray
        button = IconLabelButton.video()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setNeedsLayout()
        button.layoutIfNeeded()
    }
    
    override func tearDown() {
        button = nil
        super.tearDown()
    }

    func testIconLabelButton_Video_Unselected_Enabled() {
        // When
        button.configuration = .video
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Video_Unselected_Disabled() {
        // When
        button.isEnabled = false
        button.configuration = .video
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Video_Selected_Enabled() {
        // When
        button.isSelected = true
        button.configuration = .video
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Video_Selected_Disabled() {
        // When
        button.isSelected = true
        button.isEnabled = false
        button.configuration = .video
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Audio_Unselected_Enabled() {
        // Given
        snapshotBackgroundColor = .white

        // When
        button.configuration = .audio
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Audio_Unselected_Disabled() {
        // Given
        snapshotBackgroundColor = .white
        
        // When
        button.isEnabled = false
        button.configuration = .audio
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Audio_Selected_Enabled() {
        // Given
        snapshotBackgroundColor = .white
        
        // When
        button.isSelected = true
        button.configuration = .audio
        
        // Then
        verify(view: button)
    }
    
    func testIconLabelButton_Audio_Selected_Disabled() {
        // Given
        snapshotBackgroundColor = .white
        
        // When
        button.isSelected = true
        button.isEnabled = false
        button.configuration = .audio
        
        // Then
        verify(view: button)
    }
    
}
