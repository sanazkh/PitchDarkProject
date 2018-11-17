//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Sanaz Khosravi on 10/3/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var profileImage: UIImageView!
    var posts : [Post] = []
    var posts1 : [Post] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let mPosts = posts[indexPath.row]
        if let imageFile : PFFile = mPosts.media {
            imageFile.getDataInBackground { (data, error) in
                if (error != nil) {
                    cell.profilePicsImageView.image = UIImage(named: "image_placeholder.png")!
                    print(error?.localizedDescription)
                }
                else {
                    cell.profilePicsImageView.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }
    
    
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileCollectionView.dataSource = self
        let layout = profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        let cellPerLine : CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellPerLine - 1)
        let width = (profileCollectionView.frame.size.width / cellPerLine) - (interItemSpacingTotal / cellPerLine)
        layout.itemSize = CGSize(width: width, height: width * 3 / 3)
        usernameLabel.text = PFUser.current()?.username
        fetchPostedImagesByUser()
        fetchProfilePic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPostedImagesByUser()
    }
    func fetchPostedImagesByUser(){
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("createdAt")
        query?.whereKey("author", equalTo: PFUser.current())
        query?.whereKey("caption", notEqualTo: "profilePicture")
        
        // Fetch data asynchronously
        query?.findObjectsInBackground(block: { (posts, error) in
            if let posts = posts {
                self.posts = posts as! [Post]
                self.profileCollectionView.reloadData()
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
    func fetchProfilePic(){
        let query = Post.query()
        query?.whereKey("author", equalTo: PFUser.current())
        query?.whereKey("caption", equalTo: "profilePicture")
        
        // Fetch data asynchronously
        query?.findObjectsInBackground(block: { (posts, error) in
            if let posts = posts {
                self.posts1 = posts as! [Post]
                print(self.posts1.count)
                if(self.posts1.count > 0){
                    if let imageFile : PFFile = self.posts1[0].media {
                        imageFile.getDataInBackground { (data, error) in
                            if (error != nil) {
                                self.profileImage.image = UIImage(named: "image_placeholder.png")!
                                print(error?.localizedDescription)
                            }
                            else {
                                self.profileImage.image = UIImage(data: data!)
                            }
                        }
                    }
                }else {
                    self.profileImage.image = UIImage(named: "image_placeholder.png")!
                }
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
    
}
