//
//  ViewController.swift
//  Natife Post App
//
//  Created by Ivan Behichev on 30.08.2023.
//

import UIKit

class AllPostsViewController: UIViewController, State {

    @IBOutlet weak private var postsTableView: UITableView!
    
    private var posts: Posts?
    private var rowHeight: CGFloat = UITableView.automaticDimension
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getPosts { model in
            self.posts = model
            DispatchQueue.main.async {
                self.postsTableView.reloadData()
            }
        }
        delegates()
    }
    
    private func delegates() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        
        let nib = UINib(nibName: AppConstants.nibName, bundle: nil)
        postsTableView.register(nib, forCellReuseIdentifier: AppConstants.cellReuseIdentifier)
    }
    
    func objectStateChanged(state: Bool, object: Int) {
        if state {
            rowHeight = 300
        } else {
            rowHeight = UITableView.automaticDimension
        }
    }
    
    //MARK: - Actions
    @IBAction private func sortButtonTapped(_ sender: UIBarButtonItem) {
    }
}

//MARK: - Table View Data Source
extension AllPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.cellReuseIdentifier) as? PostTableViewCell {
            let item = posts?.posts[indexPath.row]
            if let item {
                let date = Date(timeIntervalSince1970: TimeInterval(item.timeshamp))
                let configuration = PostConfiguration(
                    title: item.title,
                    text: item.previewText,
                    date: date,
                    likes: item.likesCount,
                    id: item.postId)
                cell.configure(with: configuration)
                cell.delegate = self
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
}
//MARK: - Table View Delegate
extension AllPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
