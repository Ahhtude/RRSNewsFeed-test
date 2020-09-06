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
        //checkStarting()
    }
    
    private func configureTableView() {
            tableView?.register(UINib(nibName: "NewsFeedViewCell", bundle: nil),
            forCellReuseIdentifier: "NewsFeedViewCellViewModel")
        
            self.tableView.delegate = self
            self.tableView.dataSource = self
    }
    
    private func checkStarting() {
        if self.viewModel.rssItems.isEmpty {
            let alert = UIAlertController(title: "Internet troubles", message: "You have some trouble with internet. You nead turn ON internet in first lounch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { action in
                self.viewModel.reloadData()
            }))
            self.present(alert, animated: true)
        }
    }
    
    private func bindToViewModel() {
        self.viewModel.didUpdate = { [unowned self] _ in
            self.viewModelDidUpdate()
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
        pushDetailVC(newsModel: cell.viewModel.model)
    }
    
    private func pushDetailVC(newsModel model: RSSNewsFeed) {
        let vc =  UIStoryboard(name: "NewsDetailController", bundle: nil)
        .instantiateViewController(withIdentifier: "NewsDetailController") as! NewsDetailController
        let vm = NewsDetailViewModel(newsFeed: model)
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [deleteRow(rowIndexPathAt: indexPath)])
    }
    
    private func deleteRow(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") {[unowned self] (action, view, _) in
            self.viewModel.rssItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        return action
    }
}

