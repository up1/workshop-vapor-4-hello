import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }
    
    // Route to /hello/workshop
    app.get("hello", "workshop") { req in
        return "Hello Vapor Workshop!"
    }
    
    // Working with path variable from URL
    // /beers/:count
    
    struct Beers: Content {
        let type: String = "Double IPA"
        let count: Int
        
    }
    
    app.get("beers", ":count") { request -> Beers in
        guard let count =
            request.parameters.get("count", as: Int.self) else {
                throw Abort(.badRequest)
        }
        return Beers(count: count)
    }
    
    app.post("beers") { request -> String in
        let beers = try request.content.decode(Beers.self)
        return "There were \(beers.count) bottles"
    }
    
    // Quiz 1 :: /hello/:name
    app.get("hello", ":name") { request -> String in
        guard let name =
            request.parameters.get("name") else {
                throw Abort(.badRequest)
        }
        return "Hello \(name)"
    }

    

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.on(.DELETE, "todos", ":todoID", use: todoController.delete)
}
