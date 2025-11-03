//
//  TodosViewModelTest.swift
//  TestEMTests
//
//  Created by Tamerlan Swift on 02.11.2025.
//

import XCTest
import Combine
@testable import TestEM

class TodosViewModelTest: XCTestCase {
    
    var vm: TodosViewModel!
    var mockDS: MockTodoDataService!
    var cancellables: Set<AnyCancellable>!
    let mockTodo = "Пробежка"
    let mockDescription = "Выйти на пробежку в 7 утра"
    let mockUserId: Int64 = 26
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockDS = MockTodoDataService()
        vm = TodosViewModel(todoDataService: mockDS)
    }
    override func tearDown(){
        vm = nil
        mockDS = nil
        cancellables = nil
        TestCoreDataStack.shared.reset()
        super.tearDown()
    }
    
    func testViewModelInit() {
        XCTAssertNotNil(vm)
        XCTAssertTrue(vm.todos.isEmpty)
        XCTAssertEqual(vm.searchText, "")
    }
    
    func testAddTodos() {
        
        vm.addTodo(todo: mockTodo, description: mockDescription)
        
        XCTAssertEqual(mockDS.addTodoCallCount, 1)
        XCTAssertEqual(mockDS.lastAddedtodo, mockTodo)
        XCTAssertEqual(mockDS.lastAddedDescription, mockDescription)
    }
    
    func testToggleCompleted() {
        
        let mockEnt = TestCoreDataStack.shared.createMockTodoEntity(id: 1, todo: mockTodo, userId: mockUserId)
        let todo = Todo(id: 1, todo: mockTodo, completed: false, userId: Int(mockUserId), addDate: Date(), description: mockDescription)
        
        mockDS = MockTodoDataService(mockEntities: [mockEnt])
        vm = TodosViewModel(todoDataService: mockDS)
        
        vm.toggleCompleted(todo)
        
        XCTAssertEqual(mockDS.toggleCompletedCallCount, 1)
        XCTAssertEqual(mockDS.lastToggledEntity?.id, 1)
    }
    
    func testDeleteTodo() {
        
        let mockEnt = TestCoreDataStack.shared.createMockTodoEntity(id: 1, todo: mockTodo, userId: mockUserId)
        let todo = Todo(id: 1, todo: mockTodo, completed: false, userId: Int(mockUserId), addDate: Date(), description: mockDescription)
        
        mockDS = MockTodoDataService(mockEntities: [mockEnt])
        vm = TodosViewModel(todoDataService: mockDS)
        
        vm.deleteTodo(todo)
        
        XCTAssertEqual(mockDS.deleteTodoCallCount, 1)
        XCTAssertEqual(mockDS.lastDeletedEntity?.id, 1)
    }
    
    func testSearchFunc() {
        
        let expectation = XCTestExpectation(description: "Search should filter todos")
        
        let mockEntities = [
            TestCoreDataStack.shared.createMockTodoEntity(id: 1, todo: "Помыть посуду", userId: mockUserId),
            TestCoreDataStack.shared.createMockTodoEntity(id: 2, todo: "Прогуляться по парку", userId: mockUserId),
            TestCoreDataStack.shared.createMockTodoEntity(id: 3, todo: "Приготовить ужин", userId: mockUserId)
            ]
        mockDS = MockTodoDataService(mockEntities: mockEntities)
        vm = TodosViewModel(todoDataService: mockDS)
        
        var todos: [Todo] = []
        
        vm.$todos
            .dropFirst()
            .sink { returnedTodos in
                todos = returnedTodos
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.searchText = "ужин"
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.id, 3)
    }
    
    func testEmptySearchFunc() {
        
        let expectation = XCTestExpectation(description: "Empty Search should all todos")
        
        let mockEntities = [
            TestCoreDataStack.shared.createMockTodoEntity(id: 1, todo: "Помыть посуду", userId: mockUserId),
            TestCoreDataStack.shared.createMockTodoEntity(id: 2, todo: "Прогуляться по парку", userId: mockUserId),
            TestCoreDataStack.shared.createMockTodoEntity(id: 3, todo: "Приготовить ужин", userId: mockUserId)
            ]
        
        mockDS = MockTodoDataService(mockEntities: mockEntities)
        vm = TodosViewModel(todoDataService: mockDS)
        
        var todos: [Todo] = []
        
        vm.$todos
            .dropFirst()
            .sink { returnedTodos in
                todos = returnedTodos
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.searchText = ""
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(todos.count, 3)
    }
    
    func testPerformanceExample() {
        measure {
            let mockEnt = (1...1000).map { id in
                TestCoreDataStack.shared.createMockTodoEntity(id: Int64(id), todo: mockTodo, userId: 26)
            }
            
            mockDS = MockTodoDataService(mockEntities: mockEnt)
            vm = TodosViewModel(todoDataService: mockDS)
            
            vm.searchText = "500"
        }
    }
}
