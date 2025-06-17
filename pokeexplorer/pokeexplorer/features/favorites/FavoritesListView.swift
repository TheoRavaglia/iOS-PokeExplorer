//
//  FavoritesListView.swift
//  pokeexplorer
//
//  Created by user276504 on 6/16/25.
//


import SwiftUIimport SwiftDatastruct FavoritesListView: View {    @StateObject private var viewModel: FavoritesListViewModel    @ObservedObject var coordinator: AppCoordinator    init(coordinator: AppCoordinator) {        self.coordinator = coordinator        _viewModel = StateObject(wrappedValue: FavoritesListViewModel(coordinator: coordinator))    }    var body: some View {        NavigationStack {            if viewModel.favorites.isEmpty {                ContentUnavailableView("Sem Favoritos", systemImage: "star.slash", description: Text("Adicione Pokémon para vê-los aqui."))            } else {                List(viewModel.favorites) { pokemon in                    HStack {                        AsyncImage(url: URL(string: pokemon.imageURL)) { $0.resizable().scaledToFit() } placeholder: { ProgressView() }                            .frame(width: 50, height: 50)                        Text(pokemon.name.capitalized)                    }                }            }            .navigationTitle("Favoritos")        }    }}