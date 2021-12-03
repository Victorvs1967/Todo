//
//  Example.swift
//  Todo
//
//  Created by Victor Smirnov on 03.12.2021.
//

import Foundation

struct Todo {
    let name: String;
}

protocol TodoListLoading {
    typealias Result = Swift.Result<[Todo], Error>
    typealias Completion = (Result) -> Void
    func load(completion: @escaping Completion)
}

final class TodoListViewModel {
    typealias TodoListObserver = ([Todo]) -> Void
    typealias LoadErrorObserver = (String) -> Void
    
    var todoListObserver: TodoListObserver?
    var loadErrorObserver: LoadErrorObserver?
    
    private let todoListLoader: TodoListLoading
    
    init(todoListLoader: TodoListLoading) {
        self.todoListLoader = todoListLoader
    }
    
    func loadTodoList() {
        todoListLoader.load { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(todos):
                    self?.todoListObserver?(todos)
                case .failure:
                    self?.loadErrorObserver?("Loading failed 😢")
                }
            }
        }
    }
}
