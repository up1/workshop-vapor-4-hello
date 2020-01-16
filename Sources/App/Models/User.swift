//
//  File.swift
//  
//
//  Created by Somkiat Puisungnoen on 16/1/2563 BE.
//

import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: "id") var id: Int?
    @Field(key: "name") var name: String
    @Field(key: "username") var username: String
    
    init() { }
    init(id: Int? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
    
}
