//
//  VideoGridView.swift
//  Wire-iOS
//
//  Created by Jacob Persson on 24.04.18.
//  Copyright © 2018 Zeta Project Germany GmbH. All rights reserved.
//

import Foundation
import avs

class VideoGridView: UIStackView {
    
    let upperHorizontalStackerView: UIStackView! = UIStackView(arrangedSubviews: [])
    let lowerHorizontalStackerView: UIStackView! = UIStackView(arrangedSubviews: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lowerHorizontalStackerView.axis = .horizontal
        upperHorizontalStackerView.axis = .horizontal
        
        lowerHorizontalStackerView.distribution = .fillEqually
        upperHorizontalStackerView.distribution = .fillEqually
        
        self.distribution = .fillEqually
        self.axis = .vertical
        self.addArrangedSubview(upperHorizontalStackerView)
        self.addArrangedSubview(lowerHorizontalStackerView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startVideo(for uuid: UUID) {
        let videoView = AVSVideoView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.userid = uuid.transportString()
        videoView.shouldFill = true
        
        if upperHorizontalStackerView.arrangedSubviews.count <= lowerHorizontalStackerView.arrangedSubviews.count {
            upperHorizontalStackerView.addSubview(videoView)
            upperHorizontalStackerView.addArrangedSubview(videoView)
        } else {
            lowerHorizontalStackerView.addSubview(videoView)
            lowerHorizontalStackerView.addArrangedSubview(videoView)
        }
    }
    
    func stopVideo(for uuid: UUID) {
        if let videoView = upperHorizontalStackerView.arrangedSubviews.first(where: { ($0 as? AVSVideoView)?.userid == uuid.transportString() }) {
            upperHorizontalStackerView.removeArrangedSubview(videoView)
            videoView.removeFromSuperview()
        }
        
        if let videoView = lowerHorizontalStackerView.arrangedSubviews.first(where: { ($0 as? AVSVideoView)?.userid == uuid.transportString() }) {
            lowerHorizontalStackerView.removeArrangedSubview(videoView)
            videoView.removeFromSuperview()
        }
    }
    
}
