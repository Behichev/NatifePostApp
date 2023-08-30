//
//  ViewController.swift
//  Natife Post App
//
//  Created by Ivan Behichev on 30.08.2023.
//

import UIKit


class AllPostsViewController: UIViewController {
    
    @IBOutlet weak private var postsTableView: UITableView!
    
    private var posts: Posts?
    private var configurationArray: [PostConfiguration] = []
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        delegates()
    }
    
    private func setupData() {
        NetworkManager.shared.getPosts { model in
            self.posts = model
            self.configuration()
            DispatchQueue.main.async {
                self.postsTableView.reloadData()
            }
        }
    }
    
    private func configuration() {
        guard let allPosts = posts else { return }
        
        configurationArray = allPosts.posts.enumerated().map({ (index, item) in
            let date = Date(timeIntervalSince1970: TimeInterval(item.timeshamp))
            return PostConfiguration(title: item.title, text: item.previewText, date: date, likes: item.likesCount, index: index, state: false)
        })
    }
    
    private func delegates() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        
        let nib = UINib(nibName: AppConstants.nibName, bundle: nil)
        postsTableView.register(nib, forCellReuseIdentifier: AppConstants.cellReuseIdentifier)
    }
    
    
    //MARK: - Actions
    @IBAction private func sortButtonTapped(_ sender: UIBarButtonItem) {
    }
}

//MARK: - StateDelegate
extension AllPostsViewController: StateDelegate {
    func objectStateChanged(state: Bool, index: Int) {
        configurationArray[index].state = state
        self.postsTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
       
    }
}
//MARK: - Table View Data Source
extension AllPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configurationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.cellReuseIdentifier) as? PostTableViewCell {
            let item = configurationArray[indexPath.row]
            cell.configure(with: item)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}
//MARK: - Table View Delegate
extension AllPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
