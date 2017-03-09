//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
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

import Foundation

@objc
class NearbyPeopleSection : NSObject, CollectionViewSectionController {
    
    weak var delegate: CollectionViewSectionDelegate?
    var nearbyUsersDirectory : NearbyUsersDirectory
    var collectionView: UICollectionView! {
        didSet {
            collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "NearbyPeopleCellIdentifier")
            collectionView.register(SearchSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PeoplePickerHeaderReuseIdentifier")
        }
    }
    
    init(nearbyUsersDirectory: NearbyUsersDirectory) {
        self.nearbyUsersDirectory = nearbyUsersDirectory
        
        super.init()
        
        nearbyUsersDirectory.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyUsersDirectory.nearbyUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyPeopleCellIdentifier", for: indexPath)
        
        if let searchResultCell = cell as? SearchResultCell {
            let searchUser = nearbyUsersDirectory.nearbyUsers[indexPath.row]
            searchResultCell.user = searchUser
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(WAZUIMagic.float(forIdentifier: "people_picker.search_results_mode.tile_height")))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PeoplePickerHeaderReuseIdentifier", for: indexPath)
        
        if let headerView = supplementaryView as? SearchSectionHeaderView {
            headerView.title = "Nearby people".uppercased()
        }
        
        // in case of search, the headers are with zero frame, and their content should not be displayed
        // if not clipping, then part of the label is still displayed, so we clip it
        supplementaryView.clipsToBounds = true
        return supplementaryView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width, height: CGFloat(WAZUIMagic.float(forIdentifier: "people_picker.section_header.height")))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset = CGFloat(WAZUIMagic.float(forIdentifier: "people_picker.search_results_mode.top_padding"))
        let leftInset = CGFloat(WAZUIMagic.float(forIdentifier: "people_picker.search_results_mode.left_padding"))
        let rightInset = CGFloat(WAZUIMagic.float(forIdentifier: "people_picker.search_results_mode.right_padding"))
        
        return UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: rightInset)
    }
    
    dynamic var isHidden: Bool = true
    
    func hasSearchResults() -> Bool {
        return nearbyUsersDirectory.nearbyUsers.count > 0
    }
    
}

extension NearbyPeopleSection : NearbyUsersDirectoryDelegate {
    
    func nearbyUsersDirectoryDidUpdate() {
        isHidden = nearbyUsersDirectory.nearbyUsers.count == 0
    }
}
