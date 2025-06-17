//
//  AppCoordinator.swift
//  pokeexplorer
//
//  Created by user276504 on 6/16/25.
//


import SwiftUIimport SwiftData@MainActorfinal class AppCoordinator: ObservableObject {    @Published var path = NavigationPath()    @Published var currentView: AppView = .auth    @Published var currentUser: User?    @AppStorage("loggedInUserEmail") var loggedInUserEmail: String?        private(set) var persistenceService: PersistenceService?        enum AppView { case auth, main }    func setup(modelContext: ModelContext) {        if self.persistenceService == nil {            self.persistenceService = PersistenceService(modelContext: modelContext)            checkLoginStatus()        }    }        private func checkLoginStatus() {        guard let service = persistenceService, let email = loggedInUserEmail else {            self.currentView = .auth            return        }        Task {            self.currentUser = try? await service.fetchUser(withEmail: email)            self.currentView = self.currentUser != nil ? .main : .auth        }    }        func login(email: String) {        loggedInUserEmail = email        checkLoginStatus()    }        func logout() {        path.removeLast(path.count)        loggedInUserEmail = nil        currentUser = nil        currentView = .auth    }}