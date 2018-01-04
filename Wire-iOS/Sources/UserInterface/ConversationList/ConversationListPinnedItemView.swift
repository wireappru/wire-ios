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

import UIKit
import Cartography
import WireExtensionComponents


final class ConversationListPinnedItemView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ConversationListCellDelegate {
    
    private var collectionView: UICollectionView?
    var items: [ZMConversation]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    let cellReuseIdConversation = "CellId"
    let layoutCell = ConversationListCell()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        collectionView = UICollectionView()
        collectionView?.dataSource = self
        
        self.addSubview(collectionView!)
        
        constrain(self, collectionView!) { (selfView, collectionView) in
            collectionView.edges == collectionView.edges
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items?[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdConversation, for: indexPath) as! ConversationListCell
        cell.delegate = self
        cell.mutuallyExclusiveSwipeIdentifier = "ConversationList"
        cell.conversation = item
        cell.autoresizingMask = .flexibleWidth
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layoutCell.size(inCollectionViewSize: collectionView.bounds.size)
    }
    
    func conversationListCellOverscrolled(_ cell: ConversationListCell!) {
        
    }
    
}
