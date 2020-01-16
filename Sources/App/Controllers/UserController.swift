//
//  File.swift
//  
//
//  Created by Somkiat Puisungnoen on 16/1/2563 BE.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("api", "user", use: createHandler)
        routes.get("api", "user", use: getAllHandler)
        routes.get("api", "user", ":id", use: getById)
    }
    
    func createHandler(request: Request) throws ->EventLoopFuture<User> {
        let user = try request.content.decode(User.self)
        return user.save(on: request.db).map {user}
    }
    
    func getAllHandler(request: Request) throws ->EventLoopFuture<[User]> {
        User.query(on: request.db).all()
    }
    
    func getById(request: Request) throws ->EventLoopFuture<User> {
        guard let id =
            request.parameters.get("id", as: Int.self) else {
                throw Abort(.badRequest)
        }
        return User.find(id, on: request.db).unwrap(or: Abort(.notFound))
    }
}
