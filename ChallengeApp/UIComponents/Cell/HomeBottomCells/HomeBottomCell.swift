//
//  HomeBottomTableCell.swift
//  ChallengeApp
//
//  Created by ugur-pc on 5.05.2022.
//

import UIKit

class HomeBottomCell: UICollectionViewCell {

    static var identifier = "HomeBottomTableCell"
    var cellMovieUpComingList = [HomeBottomTableCellProtocol]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //register
        tableView.register(HomeBottomTableCell.self,
                           forCellReuseIdentifier: HomeBottomTableCell.identifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not imp")
    }
    
    private func setupViews(){
        contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

//MARK: -
extension HomeBottomCell {
    func setData(movieValue: [HomeBottomTableCellProtocol]){
        self.cellMovieUpComingList = movieValue
        
        self.tableView.reloadData()
    }
}


//MARK: - Constraints
extension HomeBottomCell {
    private func setConstraints(){
        tableView.fillSuperview()
    }
}

//MARK: - Delegate, DataSource
extension HomeBottomCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellMovieUpComingList.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeBottomTableCell.identifier, for: indexPath) as? HomeBottomTableCell else {
            return UITableViewCell()
        }
        
        cell.saveModel(model: cellMovieUpComingList[indexPath.row])
        cell.backgroundColor = .white
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
       return cell
    }
       
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
   }
}
