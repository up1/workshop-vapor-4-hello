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
        routes.delete("api", "user", ":id", use: deleteById)
        routes.put("api", "user", ":id", use: updateById)
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
    
    func deleteById(request: Request) throws ->EventLoopFuture<HTTPStatus> {
        guard let id =
            request.parameters.get("id", as: Int.self) else {
                throw Abort(.badRequest)
        }
        return User.find(id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: request.db) }
            .transform(to: .ok)
    }
    
    func updateById(request: Request) throws ->EventLoopFuture<User> {
        guard let id =
            request.parameters.get("id", as: Int.self) else {
                throw Abort(.badRequest)
        }
        let updatedUser = try request.content.decode(User.self)
        return User.find(id, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.name = updatedUser.name
                user.username = updatedUser.username
                return user.save(on: request.db).map { user }
        }
    }
}
