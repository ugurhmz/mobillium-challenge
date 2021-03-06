//
//  SearchTableCell.swift
//  ChallengeApp
//
//  Created by ugur-pc on 10.05.2022.
//

import UIKit

class SearchTableCell: UITableViewCell {

    static var identifier = "SearchTableCell"
    
    private let iconImg: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "magnifyingglass")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 22, weight: .medium)
       label.textColor = .black
       label.numberOfLines = 0
       return label
   }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not imp")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImg)
        contentView.addSubview(titleLabel)
    }

}

//MARK: - Fill Data
extension SearchTableCell {
    func fillSearchData(for searchArr: HomeMovieSearchProtocol?){
        
        if let mvTitle = searchArr?.movieTitle {
            if let movieDate =  searchArr?.releaseDateLabel {
                self.titleLabel.text = "\(mvTitle) (\(movieDate.prefix(4)))"
            }
        }
        
    }
}

//MARK: -
extension SearchTableCell {
    private func setConstraints(){
        iconImg.anchor(top: contentView.topAnchor,
                       leading: contentView.leadingAnchor,
                       bottom: contentView.bottomAnchor,
                       trailing: nil,
                       padding: .init(top: 5, left: 15, bottom: 5, right: 0),
                       size: .init(width: 30, height: 30))
        
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: iconImg.trailingAnchor,
                          bottom: contentView.bottomAnchor,
                          trailing: contentView.trailingAnchor,
                          padding: .init(top: 0, left: 20, bottom: 5, right: 0))
    }
}
