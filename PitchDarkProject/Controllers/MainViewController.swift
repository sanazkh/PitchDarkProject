//
//  MainViewController.swift
//  Instagram
//
//  Created by Sanaz Khosravi on 10/1/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var posts: [Post] = []
    let refreshControl = UIRefreshControl()
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        myTableView.insertSubview(refreshControl, at: 0)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 450
        myTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        pullDownPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier) as! UITableViewHeaderFooterView
        header.textLabel?.text = posts[section].author.username
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.selectionStyle = .none
        // let post = posts[indexPath.row]
        let post = posts[indexPath.section]
        cell.captionText.text = post.caption
        cell.locationLabel.text = post.location
        cell.indexpath = indexPath
        if let imageFile : PFFile = post.media {
            imageFile.getDataInBackground { (data, error) in
                if (error != nil) {
                    cell.imageViewCell.image = UIImage(named: "image_placeholder.png")!
                    print(error?.localizedDescription)
                }
                else {
                    cell.imageViewCell.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }
    
    @IBAction func logOutActionButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogOut"), object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        pullDownPosts()
        
    }
    
    func pullDownPosts() {
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("author")
        query?.includeKey("createdAt")
        query?.whereKey("caption", notEqualTo: "profilePicture")
        query?.limit = 50
        
        // Fetch data asynchronously
        query?.findObjectsInBackground(block: { (posts, error) in
            if let posts = posts {
                self.posts = posts as! [Post]
                self.myTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? PostCell {
            let detailView = segue.destination as! DetailViewController
            detailView.post = posts[(cell.indexpath?.section)!]
        }
    }
}

