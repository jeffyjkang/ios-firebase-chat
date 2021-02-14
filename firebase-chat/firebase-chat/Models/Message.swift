//
//  Message.swift
//  firebase-chat
//
//  Created by Jeff Kang on 2/11/21.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    
    var dictionaryRepresentation: [String: String] {
        return ["id": senderId, "displayName": displayName]
    }
    
    init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
    
    init?(dictionary: [String: String]) {
        guard let id = dictionary["id"],
              let displayName = dictionary["displayName"] else { return nil }
        self.init(senderId: id, displayName: displayName)
    }
}

struct Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    var messageId: String
    var sentDate: Date {
        return timestamp
    }
    var kind: MessageKind {
        return .text(text)
    }
    let senderId: String
    let text: String
    let displayName: String
    let timestamp: Date
    
    
    init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
        self.text = text
        self.senderId = sender.senderId
        self.displayName = sender.displayName
        self.timestamp = timestamp
        self.messageId = messageId
    }
    
}
