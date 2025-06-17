//
//  PokemonListViewModel.swift
//  pokeexplorer
//
//  Created by user276504 on 6/16/25.
//


import Foundation@MainActorfinal class PokemonListViewModel: ObservableObject {    @Published var pokemons: [APIPokemonListItem] = []    @Published var isLoading = false    private let apiService = PokemonAPIService()    private var offset = 0    private let limit = 20    private var canLoadMore = true    func loadMorePokemons() {        guard !isLoading, canLoadMore else { return }        isLoading = true                Task {            do {                let newPokemons = try await apiService.fetchPokemonList(limit: limit, offset: offset)                if newPokemons.isEmpty { canLoadMore = false }                else {                    pokemons.append(contentsOf: newPokemons)                    offset += limit                }            } catch {}            isLoading = false        }    }}