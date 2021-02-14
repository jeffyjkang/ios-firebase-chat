//
//  Room+MessageController.swift
//  firebase-chat
//
//  Created by Jeff Kang on 2/13/21.
//

import Foundation
import FirebaseDatabase

class RoomMessageController {
    
    var ref: DatabaseReference = Database.database().reference()
    
    var chatRooms: [ChatRoom] = []
    var messages: [Message] = []
    var currentSender: Sender?
    
    private lazy var formatter: DateFormatter = {
        let res = DateFormatter()
        res.dateStyle = .medium
        res.timeStyle = .medium
        return res
    }()
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        let chatRoom: [String: Any] = [
            "title": title,
            "messages": [],
            "identifier": UUID().uuidString
        ]
        ref.child("chatRooms").child(chatRoom["identifier"] as! String).setValue(chatRoom)
        completion()
    }
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        ref.child("chatRooms").observe(DataEventType.value, with: {(snapshot) in
            guard let chatRoomsDict = snapshot.value as? [String: AnyObject] else { return }
            var tempChatRooms: [ChatRoom] = []
            for (_, value) in chatRoomsDict {
                
                guard let title = value["title"] else { return }
                guard let identifier = value["identifier"] else { return }
                let tempChatRoom = ChatRoom(title: title as! String, messages: [], identifier: identifier as! String)
                tempChatRooms.append(tempChatRoom)
            }
            
            self.chatRooms = tempChatRooms
            self.messages = []
            completion()
        })
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        let message: [String: Any] = [
            "text": text,
            "senderId": sender.senderId,
            "displayName": sender.displayName,
            "timestamp": formatter.string(from: Date()),
            "messageId": UUID().uuidString
        ]
        ref.child("chatRooms").child(chatRoom.identifier).child("messages").child(message["messageId"] as! String).setValue(message)
        completion()
    }
    
    func fetchMessages(chatRoom: ChatRoom, completion: @escaping () -> Void) {
        ref.child("chatRooms").child(chatRoom.identifier).child("messages").observe(DataEventType.value, with: {(snapshot) in
            guard let messagesDict = snapshot.value as? [String: AnyObject] else { return }
            var tempMessages: [Message] = []
            for(_, value) in messagesDict {
                guard let text = value["text"] else { return }
                guard let senderId = value["senderId"] else { return }
                guard let displayName = value["displayName"] else { return }
                guard let timestamp = value["timestamp"] else { return }
                guard let messageId = value["messageId"] else { return }
                let timestampDate = self.formatter.date(from: timestamp as! String)
                let tempSender = Sender(senderId: senderId as! String, displayName: displayName as! String)
                let tempMessage = Message(text: text as! String, sender: tempSender, timestamp: timestampDate!, messageId: messageId as! String)
                tempMessages.append(tempMessage)
            }
            self.messages = tempMessages
            completion()
        })
    }
    
}
