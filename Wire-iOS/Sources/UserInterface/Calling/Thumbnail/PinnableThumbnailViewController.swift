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
import avs

@objc class PinnableThumbnailViewController: UIViewController {

    /// The view displaying the contents of the thumbnail.
    let thumbnailView = ContinuousCornersView(cornerRadius: 12)

    private let thumbnailContainerView = UIView()

    // MARK: - Dynamics

    fileprivate let edgeInset: CGFloat = 24
    fileprivate var originalCenter: CGPoint = .zero

    fileprivate lazy var pinningBehavior: ThumbnailCornerPinningBehavior = {
        return ThumbnailCornerPinningBehavior(item: self.thumbnailView, edgeInset: self.edgeInset)
    }()

    fileprivate lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.thumbnailContainerView)
    }()

    // MARK: - Configuration

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureConstraints()

        view.backgroundColor = .white

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        thumbnailView.addGestureRecognizer(panGestureRecognizer)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
        resetThumbnailPosition()

        pinningBehavior.updateFields(in: thumbnailContainerView.bounds)
        animator.addBehavior(self.pinningBehavior)

    }

    private func configureViews() {

        view.addSubview(thumbnailContainerView)
        thumbnailContainerView.clipsToBounds = false

        thumbnailContainerView.addSubview(thumbnailView)
        thumbnailView.autoresizingMask = []
        thumbnailView.backgroundColor = .red
        thumbnailView.clipsToBounds = true
        
    }

    private func resetThumbnailPosition() {

        let parentSize = thumbnailContainerView.frame.size
        let contentSize = CGSize(width: 112.5, height: 200)

        let defaultFrame = CGRect(x: parentSize.width - contentSize.width - edgeInset, y: edgeInset,
                                  width: contentSize.width, height: contentSize.height)

        guard #available(iOS 10, *) else {
            thumbnailView.frame = defaultFrame
            return
        }

        if view.effectiveUserInterfaceLayoutDirection == .rightToLeft {

            thumbnailView.frame = CGRect(x: edgeInset, y: edgeInset,
                                         width: contentSize.width, height: contentSize.height)

        } else {
            thumbnailView.frame = defaultFrame
        }

    }

    private func configureConstraints() {

        thumbnailContainerView.translatesAutoresizingMaskIntoConstraints = false

        thumbnailContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuideOrFallback.leadingAnchor).isActive = true
        thumbnailContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuideOrFallback.trailingAnchor).isActive = true
        thumbnailContainerView.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        thumbnailContainerView.bottomAnchor.constraint(equalTo: safeBottomAnchor).isActive = true

    }

    // MARK: - Size

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Ensure the item stays on screen during a bounds change.
        guard let corner = pinningBehavior.currentCorner else { return }

        pinningBehavior.isEnabled = false

        let bounds = CGRect(origin: CGPoint.zero, size: size)

        pinningBehavior.updateFields(in: bounds)

        coordinator.animate(alongsideTransition: { context in
            self.thumbnailView.center = self.pinningBehavior.position(for: corner)
        }, completion: { context in
            self.pinningBehavior.isEnabled = true
        })

    }

    // MARK: - Panning

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
        case .began:
            // Disable the pinning while the user moves the thumbnail
            pinningBehavior.isEnabled = false
            originalCenter = thumbnailView.center

        case .changed:

            // Calculate the target center

            let originalFrame = thumbnailView.frame
            let containerFrame = thumbnailContainerView.frame

            let translation = recognizer.translation(in: thumbnailContainerView)
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            let transformedPoint = originalCenter.applying(transform)

            // Calculate the appropriate horizontal origin

            let x: CGFloat
            let halfWidth = originalFrame.width / 2

            if (transformedPoint.x - halfWidth) < containerFrame.minX {
                x = containerFrame.minX
            } else if (transformedPoint.x + halfWidth) > containerFrame.maxX {
                x = containerFrame.maxX - originalFrame.width
            } else {
                x = transformedPoint.x - halfWidth
            }

            // Calculate the appropriate vertical origin

            let y: CGFloat
            let halfHeight = originalFrame.height / 2

            if (transformedPoint.y - halfHeight) < containerFrame.minY {
                y = containerFrame.minY
            } else if (transformedPoint.y + halfHeight) > containerFrame.maxY {
                y = containerFrame.maxY - originalFrame.height
            } else {
                y = transformedPoint.y - halfHeight
            }

            // Do not move the thumbnail outside the container
            thumbnailView.frame = CGRect(x: x, y: y, width: originalFrame.width, height: originalFrame.height)

        case .cancelled, .ended:

            // Snap the thumbnail to the closest edge
            let velocity = recognizer.velocity(in: self.thumbnailContainerView)
            pinningBehavior.isEnabled = true
            pinningBehavior.addLinearVelocity(velocity)

        default:
            break
        }

    }

}
