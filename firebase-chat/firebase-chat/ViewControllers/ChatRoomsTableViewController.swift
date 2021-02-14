//
//  ChatRoomsTableViewController.swift
//  firebase-chat
//
//  Created by Jeff Kang on 2/10/21.
//

import UIKit
import MessageKit

class ChatRoomsTableViewController: UITableViewController {
    
    let roomMessageController = RoomMessageController()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String: String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            roomMessageController.currentSender = currentUser
        } else {
            // create an alert that asks the user for a username and saves it to user defaults
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            var userNameTextField: UITextField!
            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                userNameTextField = textField
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                // take the text field's text and save it to user defaults
                let displayName = userNameTextField.text ?? "No name"
                let id = UUID().uuidString
                let sender = Sender(senderId: id, displayName: displayName)
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                self.roomMessageController.currentSender = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roomMessageController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var chatRoomTitleTextField: UITextField!

    @IBAction func createChatRoom(_ sender: UITextField) {
        chatRoomTitleTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTitleTextField.text else { return }
        
        chatRoomTitleTextField.text = ""
        
        roomMessageController.createChatRoom(with: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roomMessageController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = roomMessageController.chatRooms[indexPath.row].title
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageViewSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? MessageViewController else { return }
            destinationVC.roomMessageController = roomMessageController
            destinationVC.chatRoom = roomMessageController.chatRooms[indexPath.row]
        }
    }

}
