//
//  PollCreationViewController.swift
//  Wire-iOS
//
//  Created by Marco Conti on 03/03/2017.
//  Copyright © 2017 Zeta Project Germany GmbH. All rights reserved.
//

import Foundation


import ZMCDataModel
import Cartography
import MapKit
import CoreLocation

@objc final public class PollCreationViewController: UIViewController {
    
    public let addOptionButton = IconButton()
    public let acceptOptionButton = IconButton()
    public let optionsStackView = StackView()
    
    public init(forPopoverPresentation popover: Bool) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, user 'init(forPopoverPresentation:)'")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        createConstraints()
    }
    
    fileprivate func configureViews() {
        //addChildViewController()
//        sendViewController.didMove(toParentViewController: self)
//        [mapView, sendViewController.view, toolBar, locationButton].forEach(view.addSubview)
//        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
//        locationButton.setIcon(.location, with: .tiny, for: UIControlState())
//        locationButton.cas_styleClass = "back-button"
//        mapView.isRotateEnabled = false
//        mapView.isPitchEnabled = false
//        toolBar.title = title
//        pointAnnotation.coordinate = mapView.centerCoordinate
//        annotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: String(describing: type(of: self)))
//        mapView.addSubview(annotationView)
    }
    
    fileprivate func createConstraints() {
//        constrain(view, mapView, sendViewController.view, annotationView, toolBar) { view, mapView, sendController, pin, toolBar in
//            mapView.edges == view.edges
//            sendController.leading == view.leading
//            sendController.trailing == view.trailing
//            sendController.bottom == view.bottom
//            sendController.height == 56
//            toolBar.leading == view.leading
//            toolBar.top == view.top
//            toolBar.trailing == view.trailing
//            pin.centerX == mapView.centerX + 8.5
//            pin.bottom == mapView.centerY + 5
//            pin.height == 39
//            pin.width == 32
//        }
//        
//        constrain(view, sendViewController.view, locationButton) { view, sendController, button in
//            button.leading == view.leading + 16
//            button.bottom == sendController.top - 16
//            button.width == 28
//            button.height == 28
//        }
    }
    
    @objc fileprivate func addOptionButtonTapped(_ sender: IconButton) {
        // TODO MARCO
    }
    
    public override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIViewController.wr_supportedInterfaceOrientations()
    }

    public func pollCreationSendButtonTapped(_ viewController: PollCreationViewController) {
        dismiss(animated: true, completion: nil)
    }
}
