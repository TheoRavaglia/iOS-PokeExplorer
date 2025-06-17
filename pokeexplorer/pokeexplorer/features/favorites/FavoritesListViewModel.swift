//
//  FavoritesListViewModel.swift
//  pokeexplorer
//
//  Created by user276504 on 6/16/25.
//


import SwiftUIimport SwiftData@MainActorclass FavoritesListViewModel: ObservableObject {    @Query var favorites: [FavoritePokemon]    init(coordinator: AppCoordinator) {        let userEmail = coordinator.loggedInUserEmail ?? ""        _favorites = Query(filter: #Predicate<FavoritePokemon> { $0.user?.email == userEmail }, sort: \.name)    }}