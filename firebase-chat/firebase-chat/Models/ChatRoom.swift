//
//  ChatRoom.swift
//  firebase-chat
//
//  Created by Jeff Kang on 2/11/21.
//

import Foundation

struct ChatRoom {
    let title: String
    var messages: [Message]
    let identifier: String
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
}
