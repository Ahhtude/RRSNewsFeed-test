//
//  NewsFeedViewController.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import UIKit

class NewsFeedViewController: UITableViewController {
    let viewModel = NewsFeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindToViewModel()
    }
    
    private func configureTableView() {
            tableView?.register(UINib(nibName: "NewsFeedViewCell", bundle: nil),
            forCellReuseIdentifier: "NewsFeedViewCellViewModel")
        
            self.tableView.delegate = self
            self.tableView.dataSource = self
    }
    
    private func bindToViewModel() {
        self.viewModel.didUpdate = { [weak self] _ in
            self?.viewModelDidUpdate()
        }
//        self.viewModel.didError = { [weak self] error in
//            self?.viewModelDidError(error: error)
//        }
        reloadData()
    }
    
//    private func viewModelDidError(error: NetworkError) {
//       UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
//    }
    
    private func viewModelDidUpdate() {
        OperationQueue.main.addOperation {[unowned self] in
            self.tableView.reloadData()
        }
    }
    
    private func reloadData() {
        self.viewModel.reloadData()
    }
}

extension NewsFeedViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedViewCellViewModel") as? NewsFeedViewCell else { return UITableViewCell() }
        let feed = viewModel.rssItems[indexPath.row]
        cell.fill(model: NewsFeedViewCellViewModel(model: feed))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NewsFeedViewCell
        //print("MORE DATA IS \(cell.viewModel.model.mediaDataURL)")
        
        pushDetailVC(newsModel: cell.viewModel.model)
//        tableView.beginUpdates()
//        cell.titleLabel.numberOfLines = (cell.descriptionLabel.numberOfLines == 0) ? 2 : 0
//        cell.descriptionLabel.numberOfLines = (cell.descriptionLabel.numberOfLines == 0) ? 3 : 0
//        tableView.endUpdates()
    }
    
    private func pushDetailVC(newsModel model: RSSNewsFeed) {
        let vc =  UIStoryboard(name: "NewsDetailController", bundle: nil)
        .instantiateViewController(withIdentifier: "NewsDetailController") as! NewsDetailController
        let vm = NewsDetailViewModel(newsFeed: model)
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

