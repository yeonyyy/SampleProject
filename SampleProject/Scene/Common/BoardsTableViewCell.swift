//
//  BoardsTableViewCell.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/21.
//

import UIKit
import RxSwift
import SnapKit
import Kingfisher

class BoardsTableViewCell: UITableViewCell {
    static let identifier = "DefaultTableViewCell"
    static let estimatedCellHeight: CGFloat = 75

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()

    private lazy var subTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var attachmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var writerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var viewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.tintColor = .lightGray
        return imageView
    }()

    private lazy var viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        badgeImageView.image = nil
        titleLabel.text = ""
        attachmentImageView.image = nil
        writerLabel.text = ""
        attachmentImageView.image = nil
        newImageView.image = nil
        writerLabel.text = ""
        dateLabel.text = ""
        viewCountLabel.text = ""
        
    }
    
    func fill(with model: PostDTO) {
        if model.postType == "notice" {
            badgeImageView.isHidden = false
            badgeImageView.image = UIImage(systemName: "bell.circle.fill")
            badgeImageView.tintColor = .systemOrange
        }else if model.postType == "reply" {
            badgeImageView.isHidden = false
            badgeImageView.image = UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
            badgeImageView.tintColor = .systemRed
        }else if model.postType == "normal" {
            badgeImageView.isHidden = true
            badgeImageView.image = nil
        }
        
        if model.attachmentsCount > 0 {
            attachmentImageView.image = UIImage(systemName: "paperclip")
            attachmentImageView.tintColor = .lightGray
            attachmentImageView.isHidden = false
        }else {
            attachmentImageView.image = nil
            attachmentImageView.isHidden = true
        }
        
        if model.isNewPost == true {
            newImageView.image = UIImage(systemName: "n.circle.fill")
            newImageView.tintColor = .systemRed
            newImageView.isHidden = false
        }else {
            newImageView.image = nil
            newImageView.isHidden = true
        }
        
        titleLabel.text = model.title
        writerLabel.text = model.writer.displayName
        dateLabel.text = model.createdDateTime.stringToDate().yyyyMMdd()
        viewCountLabel.text = "\(model.viewCount)"
        
    }
    
    private func setupViews() {
        backgroundColor = .white
       
        badgeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(17)
        }
        attachmentImageView.snp.makeConstraints { make in
            make.height.width.equalTo(17)
        }
        newImageView.snp.makeConstraints { make in
            make.height.width.equalTo(17)
        }
        viewImageView.snp.makeConstraints { make in
            make.height.width.equalTo(17)
        }
        
        titleStackView.addArrangedSubview(badgeImageView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(attachmentImageView)
        titleStackView.addArrangedSubview(newImageView)
        contentStackView.addArrangedSubview(titleStackView)
        subTitleStackView.addArrangedSubview(writerLabel)
        subTitleStackView.addArrangedSubview(dateLabel)
        subTitleStackView.addArrangedSubview(viewImageView)
        subTitleStackView.addArrangedSubview(viewCountLabel)
        contentStackView.addArrangedSubview(subTitleStackView)
        contentView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.bottom.right.equalToSuperview().offset(-15)
        }
    }
    
}

