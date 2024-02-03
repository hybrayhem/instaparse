//
//  FeedViewController.swift
//  InstaParse
//
//
//

import UIKit

// TODO: Import Parse Swift


class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryPosts()
    }

    private func queryPosts() {
        // define query
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
        
        // fetch query async
        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts // update local posts
            
            case .failure(let error):
                Alert(self).showError(for: error)
            }
        }
    }

    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }

    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

extension FeedViewController: UITableViewDelegate { }
