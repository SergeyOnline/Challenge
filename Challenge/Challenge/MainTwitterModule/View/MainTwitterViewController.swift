//
//  ViewController.swift
//  Challenge
//
//  Created by Сергей on 27.01.2022.
//

import UIKit
import WebKit

final class MainTwitterViewController: UIViewController {
	
	enum Constants {
		static let headerLabelFontSize = 34.0
		static let infoCellIdentifier = "InfoTableViewCell"
		static let twitCellIdentifier = "TwitTableViewCell"
	}
	
	enum Props {
		case loading
		case error(description: String)
		case loaded([Data])
		
		struct Data {
			let id: Int
			let text: String
			let favoriteCount: String
			let retweetCount: String
			let date: String
			let imageURL: String?
		}
	}
	
	var props: Props = .loading {
		didSet {
			view.setNeedsLayout()
		}
	}
	
	var presenter: IMainTwitterPresenter?
	
//	MARK: - UI
	lazy var headerLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Новости"
		label.font = UIFont.boldSystemFont(ofSize: Constants.headerLabelFontSize)
		return label
	}()
	lazy var loadingView = LoadingView.initial()
	lazy var errorView = ErrorView.initial()
	lazy var webView = WebView.initial()
	lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		view.backgroundColor = traitCollection.userInterfaceStyle == .light ? .white : .black
		tableView.backgroundColor = view.backgroundColor
		switch props {
		case .loading:
			tableView.isHidden = true
			errorView.isHidden = true
			loadingView.activityIndicator.startAnimating()
			webView.isHidden = true
			
		case .error(let description):
			loadingView.isHidden = true
			loadingView.activityIndicator.stopAnimating()
			tableView.isHidden = true
			errorView.isHidden = false
			errorView.descriptionLabel.text = description
			errorView.reloadButtonClosure = {
				self.presenter?.changeState()
			}
			webView.isHidden = true
		case .loaded:
			tableView.isHidden = false
			errorView.isHidden = true
			loadingView.isHidden = true
			loadingView.activityIndicator.stopAnimating()
			webView.isHidden = true
			
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
//	MARK: - private functions
	private func setup() {
		
		view.addSubview(headerLabel)
		setupHeaderLabelConstraints()
		
		view.addSubview(loadingView)
		setupLoadingViewConstraints()
		
		view.addSubview(errorView)
		setupErrorViewConstraints()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: Constants.twitCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.twitCellIdentifier)
		tableView.register(UINib(nibName: Constants.infoCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.infoCellIdentifier)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 150
		view.addSubview(tableView)
		setupTableViewConstraints()
		
	
		view.addSubview(webView)
		setupWebViewConstraints()
	}
	
	private func setupWebViewConstraints() {
		webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
		webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
		webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	
	private func setupHeaderLabelConstraints() {
		headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56).isActive = true
		headerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
		headerLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
		headerLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
	}
	
	private func setupLoadingViewConstraints() {
		loadingView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 65).isActive = true
		loadingView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
		loadingView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
		loadingView.heightAnchor.constraint(equalToConstant: 211).isActive = true
	}
	
	private func setupErrorViewConstraints() {
		errorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 65).isActive = true
		errorView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
		errorView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
		errorView.heightAnchor.constraint(equalToConstant: 258).isActive = true
	}
	
	private func setupTableViewConstraints() {
		tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	
}

extension MainTwitterViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if case .loaded(let data) = props {
			return data.count + 1
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellIdentifier) as? InfoTableViewCell else { return UITableViewCell() }
			
			cell.backgroundColor = view.backgroundColor
			cell.isUserInteractionEnabled = false
			return cell
		} else if case .loaded(let propsData) = props {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.twitCellIdentifier) as? TwitTableViewCell else { return UITableViewCell() }
			
			cell.backgroundColor = view.backgroundColor
			cell.twitTextView.text = propsData[indexPath.row - 1].text
			cell.favoriteCountLabel.text = propsData[indexPath.row - 1].favoriteCount
			cell.retweetCountLabel.text = propsData[indexPath.row - 1].retweetCount
			cell.dateLabel.text = propsData[indexPath.row - 1].date
			if let imageURL = propsData[indexPath.row - 1].imageURL {
				presenter?.getImageFromUrl(url: imageURL, completion: { image in
					DispatchQueue.main.async {
						cell.loadedImageView.isHidden = false
						cell.loadedImageView.image = image
					}
				})
			} else {
				cell.loadedImageView.isHidden = true
			}
			
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		   tableView.deselectRow(at: indexPath, animated: true)
		
//		MARK: open link in Safari
//		if case .loaded(let propsData) = props {
//			guard let url = URL(string: "https://twitter.com/mosgortrans_ru/status/\(propsData[indexPath.row - 1].id)") else { return }
//			UIApplication.shared.open(url)
//		}
		
		if case .loaded(let propsData) = props {
			webView.readyButtonClosure = {
				self.presenter?.changeState()
			}
			let myURL = URL(string: "https://twitter.com/mosgortrans_ru/status/\(propsData[indexPath.row - 1].id)")
			let myRequest = URLRequest(url: myURL!)
			webView.webView.load(myRequest)
			self.tableView.isHidden = true
			errorView.isHidden = true
			loadingView.isHidden = true
			webView.isHidden = false
		}
		
	}
}

extension MainTwitterViewController: IMainTwitterViewController {}
