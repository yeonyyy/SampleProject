//
//  BoardsSearchTableViewCell.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/23.
//

import UIKit
import RxSwift
import RxCocoa

class BoardsSearchTableViewCell: UITableViewCell {
    static let identifier = "BoardsSearchTableViewCell"
    
    static let estimatedCellHeight: CGFloat = 75
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.tintColor = .lightGray
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var disposeBag = DisposeBag()
    private var cellmodel : BoardsSearchCellModel?
    
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
        leftImageView.image = nil
        categoryLabel.text = ""
        title.text = ""
        rightButton.setImage(nil, for: .normal)
    }
    
    func fill(_ model: BoardsSearchCellModel, idx:Int ,leftButtonTap: PublishSubject<(Int, BoardsSearchCellModel)>) {
        cellmodel = model
        categoryLabel.text = "\(model.category):"
        title.text = model.keyword
        leftImageView.isHidden = model.hidesLeftImage
        leftImageView.image = model.lefImage
        rightButton.setImage(model.rightImage, for: .normal)
        
        rightButton.rx.tap
            .filter { model.history != nil }
            .bind {
                leftButtonTap.onNext((idx, model))
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupViews(){
        contentStackView.addArrangedSubview(leftImageView)
        contentStackView.addArrangedSubview(categoryLabel)
        contentStackView.addArrangedSubview(title)
        contentStackView.addArrangedSubview(rightButton)
        contentView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.bottom.right.equalToSuperview().offset(-15)
        }
    }

}
