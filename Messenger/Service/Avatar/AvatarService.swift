//
//  AvatarService.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import UIKit

class AvatarService: IAvatarService {
	let network: INetworkTask
	let requestURL = URL(string: "https://pixabay.com/api/?key=21232169-94326e6096be4a4a500d3bf26&q=people&per_page=200")
	var dataModel = [PixabayData.Image]()
	
	func getAvatars(count: ((Int) -> Void)?, completion: ((Result<(UIImage, Int), AvatarError>) -> Void)?) {
		guard let requestURL = requestURL else {
			completion?(.failure(.unableToLoadAny))
			return
		}
		network.get(url: requestURL, headers: nil) { [weak self] (result: Result<PixabayData, NetworkError>) in
			switch result {
			case .success(let data):
				self?.dataModel = data.hits
				count?(data.hits.count)
				self?.getImagesFromCollectedURLs(completion: completion)
			case .failure(let error):
				self?.handleNetworkError(error: error, at: nil, completion: completion)
			}
		}
	}
	
	private func getImagesFromCollectedURLs(completion: ((Result<(UIImage, Int), AvatarError>) -> Void)?) {
		for i in dataModel.indices {
			network.get(url: dataModel[i].webformatURL, headers: nil) { [weak self] (result: Result<Data, NetworkError>) in
				switch result {
				case .success(let data):
					if let image = UIImage(data: data) {
						completion?(.success((image, i)))
					} else {
						completion?(.failure(.unableToLoad(at: i)))
					}
				case .failure(let error):
					self?.handleNetworkError(error: error, at: i, completion: completion)
				}
			}
		}
	}
	
	private func handleNetworkError(error: NetworkError, at index: Int?, completion: ((Result<(UIImage, Int), AvatarError>) -> Void)?) {
		switch error {
		case .decodingFailure:
			if let index = index {
				completion?(.failure(.unableToLoad(at: index)))
			} else {
				completion?(.failure(.unableToLoadAny))
			}
		case .serverFailure:
			if let index = index {
				completion?(.failure(.unableToLoad(at: index)))
			} else {
				completion?(.failure(.unableToLoadAny))
			}
		}
	}
	
	init(network: INetworkTask) {
		self.network = network
	}
}
