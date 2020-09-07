//
//  NewsFeedViewController.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 07.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//
import UIKit

class NewsFeedViewController: UITableViewController {
    let viewModel = NewsFeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.bindToViewModel()
        self.checkStarting()
    }
    
    private func configureTableView() {
            tableView?.register(UINib(nibName: "NewsFeedViewCell", bundle: nil),
            forCellReuseIdentifier: "NewsFeedViewCellViewModel")
        
            self.tableView.delegate = self
            self.tableView.dataSource = self
        
            self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc private func refresh(sender:AnyObject) {
        self.viewModel.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    private func checkStarting() {
        if CoreDataManager.shared.getAllNews().isEmpty {
            let alert = UIAlertController(title: "Internet troubles", message: "You have some trouble with internet. You nead turn ON internet in first lounch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {[unowned self] action in
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
        refresh(sender: self)
    }
    
//    private func viewModelDidError(error: NetworkError) {
//       UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
//    }
    
    private func viewModelDidUpdate() {
        OperationQueue.main.addOperation {[unowned self] in
            self.tableView.reloadData()
        }
    }
    
//    private func reloadData() {
//        self.viewModel.reloadData()
//    }
    
    @IBAction func addNewsSourceAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add new NewsFeed", message: "Enter feed name and URL", preferredStyle: .alert)
        self.configureAddNewNewsFeed(alert: alert)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewsFeedViewController {
    //MARK: - Delegate & DataSource
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
    
    
    //MARK:- AddingNewNews
    private func configureAddNewNewsFeed(alert: UIAlertController) {
        
        alert.addTextField { (textField) in
                   textField.placeholder = "Feed name"
               }
        
        alert.addTextField { (textField) in
                   textField.placeholder = "Feed URL"
               }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [unowned self] action in
            let textFields = alert.textFields
            let feedName = (textFields?.first)! as UITextField
            let feedURL = (textFields?.last)! as UITextField
                   
            guard !feedName.text!.isEmpty && !feedURL.text!.isEmpty else {return}
                self.viewModel.addNewNewsSource(url: feedURL.text!)
        }))
    }
    
    //MARK:- Push Detail VC
    private func pushDetailVC(newsModel model: RSSNewsFeed) {
        let vc =  UIStoryboard(name: "NewsDetailController", bundle: nil)
        .instantiateViewController(withIdentifier: "NewsDetailController") as! NewsDetailController
        let vm = NewsDetailViewModel(newsFeed: model)
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- TableView contextual methods
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [deleteRow(rowIndexPathAt: indexPath)])
    }
    
    private func deleteRow(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") {[unowned self] (action, view, _) in
            self.viewModel.deleteNewsFromData(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        return action
    }
}
