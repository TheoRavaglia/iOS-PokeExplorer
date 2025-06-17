//
//  AppCoordinatorView.swift
//  pokeexplorer
//
//  Created by user276504 on 6/16/25.
//


import SwiftUIstruct AppCoordinatorView: View {    // O StateObject garante que o Coordinator viverá enquanto esta View existir.    @StateObject private var coordinator: AppCoordinator        // O ModelContext é obtido do ambiente para ser passado ao Coordinator.    @Environment(\.modelContext) private var modelContext    init() {        // A inicialização do StateObject acontece aqui.        _coordinator = StateObject(wrappedValue: AppCoordinator())    }    var body: some View {        Group {            if coordinator.currentView == .auth {                // Passa o coordinator para a LoginView.                LoginView(viewModel: AuthViewModel(coordinator: coordinator))            } else {                // Passa o coordinator para a MainTabView.                MainTabView(coordinator: coordinator)            }        }        .onAppear {            // Quando a view aparece, configuramos o coordinator com o modelContext.            coordinator.setup(modelContext: modelContext)        }    }}