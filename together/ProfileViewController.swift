//
//  ProfileViewController.swift
//  together
//
//  Created by ASda Bogasd on 02.02.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class ProfileViewController: UIViewController {
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet weak var followingLabels: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subscribeBtnLabel: UILabel!
    @IBOutlet var subscribleButton: UIButton!
    
    
    var userId: UInt64!
    var user: UserModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundPic()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        if (userId == MainUserRepo.shared.getUser().getId()){
            UserRepo.getCurrentUser(userId: MainUserRepo.shared.getUser().getId())
                .then{ user -> Void in
                    self.setUserInfo(user: user)
                    self.user = user
            }
            subscribleButton.isHidden = true
        } else {
            UserRepo.getCurrentUser(userId: userId)
                .then{ user -> Void in
                        self.setUserInfo(user: user)
                        self.user = user
            }
        }
        
    }
 

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserInfo(user:UserModel){
        followersLabel.text = String(user.getFollowersCount())
        loginLabel.text = user.getName()
        titleLabel.text = user.getTitle()
        avatar.image = user.getPhoto()
        followingLabels.text = String(user.getFriendsCount())
        descriptionLabel.text = user.getDescription()
    }
    
    //Actions
    @IBAction func subscriblePressed(sender: AnyObject) {
        if (MainUserRepo.shared.getUser().isFriend(userId: userId)){
            MainUserRepo.shared.subscribePresed(userId: userId)
            subscribleButton.setTitle(" Subscribe".localized, for: .normal)
        } else {
            let notificationRepositories = NotificationRepositories()
            notificationRepositories.notificationCount(withh: {(count) in
                let notifText = self.user.name + " subscribe on you".localized
                let notification: NotificationModel = NotificationModel(notifId: Int(count)+1, text:notifText, userId:self.userId, type:"subscrible", usersNotifId:[self.user.notificationId] )
                OneSignal.postNotification(["contents": [notification.lang: notification.text], "include_player_ids": notification.usersNotifId])
                let notifDicionary = notificationMaper.notificationToDictionary(notification: notification)
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                ref.child("notifications/"+String(count+1)+"/").setValue(notifDicionary)
                MainUserRepo.shared.subscribePresed(userId: self.userId)
                self.subscribleButton.setTitle(" Unscribe".localized, for: .normal)
            })
        }
    }
    
    func roundPic(){
        self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
        self.avatar.clipsToBounds = true;
        self.avatar.layer.borderWidth = 1.0
        self.avatar.layer.borderColor = UIColor.white.cgColor
    }
}
