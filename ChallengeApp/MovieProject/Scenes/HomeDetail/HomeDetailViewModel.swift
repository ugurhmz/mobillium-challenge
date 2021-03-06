//
//  HomeDetailViewModel.swift
//  ChallengeApp
//
//  Created by ugur-pc on 7.05.2022.
//

import Foundation

protocol HomeDetailViewModelDataSource {
    
    var movieId: Int? {get}
    var movieImageUrl: URL? {get}
    var movieRate: Double? { get}
    var movieTitle: String? { get }
    var movieDefinition: String? {get}
    var movieReleaseData: String? {get}
    var similarMovieArr: [SimilarCellProtocoL]? { get set}
    func cellItem(for indexPath: IndexPath) -> SimilarCellProtocoL
    var similarCell: SimilarCellProtocoL? {get}
    var numberItemsInSection: Int { get }
}

protocol HomeDetailViewModelEventSource {
    var reloadData: VoidClosure? { get set}
    var endRefreshing: VoidClosure? {get set}
}
protocol HomeDetailViewModelProtocol: HomeDetailViewModelDataSource, HomeDetailViewModelEventSource {
    
}

class HomeDetailViewModel: BaseViewModel<HomeDetailRouter>, HomeDetailViewModelProtocol {
 
    var endRefreshing: VoidClosure?
    var similarCell: SimilarCellProtocoL?
    var similarMovieArr: [SimilarCellProtocoL]? = []
    var reloadData: VoidClosure?
    var movieReleaseData: String?
    var movieId: Int?
    var movieImageUrl: URL?
    var movieRate: Double?
    var movieTitle: String?
    var movieDefinition: String?
    let imgPath: String = "https://image.tmdb.org/t/p/original"
    
    var sectionName: String? {
        return "Benzer Filmler"
    }
    
    var numberItemsInSection: Int {
        return similarMovieArr?.count ?? 0
    }
    
    init(movieId: Int?, router: HomeDetailRouter){
        self.movieId = movieId
        super.init(router: router)
    }
    
    private func setData(detailModel: MovieDetailsModel){
        self.movieTitle = detailModel.title
        self.movieDefinition  = detailModel.overview
        self.movieRate = detailModel.voteAverage
        self.movieImageUrl = URL(string: imgPath + (detailModel.posterPath ?? "") )
        self.movieReleaseData = detailModel.releaseDate
    }
    
    
    func cellItem(for indexPath: IndexPath) -> SimilarCellProtocoL {
        return similarMovieArr?[indexPath.row] ?? SimilarCellModel()
    }
    
    
    func didSelectTopItem(at indexPath: IndexPath) {
        let selectItemId = similarMovieArr?[indexPath.item].movieId ?? 0
        router.pushHomeDetail(movieId: selectItemId)
    }
}

//MARK: - Fetch Data
extension HomeDetailViewModel {
    
    func fetchDetailData() {
        let request = MovieDetailRequest(movieId: movieId ?? 0)
        dataProvider.request(for: request) {  [weak self] result in
            guard let strongSelf = self  else { return }
            switch result {
            case .success(let response):
                guard let response = response else {return}
                strongSelf.setData(detailModel: response)
                strongSelf.reloadData?()
            case .failure(let error):
                strongSelf.showWarningToast?(error.localizedDescription)
            }
        }
    }
    
    func fetchSimilarMovieData(){
        let request = MovieSimilarRequest(movieId: movieId ?? 0)
        dataProvider.request(for: request) { [weak self] result in
            guard let strongSelf = self else {return }
            switch result {
            case .success(let response):
                guard let movieArr = response?.results?.map({
                    return SimilarCellModel(movieId: $0.id,
                                            movieTitle: $0.title,
                                            movieReleaseDate: $0.releaseDate,
                                            movieImageUrl: URL(string: strongSelf.imgPath + ($0.poster_path ?? "")) )
                }) else {return }
                strongSelf.similarMovieArr = movieArr
                print("movieArr",movieArr.count)
                strongSelf.endRefreshing?()
                strongSelf.reloadData?()
            case .failure(let error):
                strongSelf.showWarningToast?(error.localizedDescription)
            }
        }
    }
}
