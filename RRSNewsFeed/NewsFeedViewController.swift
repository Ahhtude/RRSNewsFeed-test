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
        print("LOL")
    }
    
    private func configureTableView() {
            tableView?.register(UINib(nibName: "DrinkFeedViewCell", bundle: nil),
            forCellReuseIdentifier: "DrinkFeedCellViewModel")
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
        self.tableView.reloadData()
    }
    
    private func reloadData() {
        self.viewModel.reloadData()
    }
}

extension NewsFeedViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        print("DATA IS LOAD \(viewModel.rssItems[indexPath.item])")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rssItems.count
    }
    
}

