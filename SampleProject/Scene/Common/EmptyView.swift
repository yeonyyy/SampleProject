//
//  EmptyView.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/28.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(descriptionLabel)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.height.equalTo(100)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
    }
    
    
}
