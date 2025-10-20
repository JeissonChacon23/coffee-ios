//
//  TownsListView.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI

struct TownsListView: View {
    @StateObject private var viewModel: TownsListViewModel
    @State private var selectedTown: Town?
    @State private var showTownDetail = false
    
    init(viewModel: TownsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorConstants.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Towns")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(ColorConstants.textPrimary)
                        
                        Text("Explore coffee regions")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(ColorConstants.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(ColorConstants.textSecondary)
                        
                        TextField("Search towns...", text: $viewModel.searchText)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(ColorConstants.textPrimary)
                            .onChange(of: viewModel.searchText) { oldValue, newValue in
                                viewModel.search(query: newValue)
                            }
                    }
                    .padding(12)
                    .background(ColorConstants.surfaceLight)
                    .border(ColorConstants.borderLight, width: 1)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    Divider()
                        .background(ColorConstants.borderLight)
                    
                    // Content
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(ColorConstants.primary)
                            Text("Loading towns...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(ColorConstants.textSecondary)
                                .padding(.top, 12)
                            Spacer()
                        }
                    } else if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(ColorConstants.error)
                            
                            Text("Error")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(ColorConstants.textPrimary)
                            
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(ColorConstants.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                viewModel.fetchTowns()
                            }) {
                                Text("Retry")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(ColorConstants.primary)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    } else if viewModel.towns.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "map.fill")
                                .font(.system(size: 48))
                                .foregroundColor(ColorConstants.textSecondary)
                            
                            Text("No Towns Found")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(ColorConstants.textPrimary)
                            
                            Text("Try adjusting your search or filters")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(ColorConstants.textSecondary)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(viewModel.towns) { town in
                                    NavigationLink(destination: TownDetailView(town: town)) {
                                        TownCard(town: town)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchTowns()
            }
        }
    }
}

// MARK: - TownCard Component
struct TownCard: View {
    let town: Town
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            AsyncImage(url: URL(string: town.imageURL)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.3)
                        ProgressView()
                            .tint(ColorConstants.primary)
                    }
                    .frame(height: 150)
                    .cornerRadius(8)
                
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(8)
                
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.3)
                        Image(systemName: "photo.fill")
                            .font(.system(size: 32))
                            .foregroundColor(ColorConstants.textSecondary)
                    }
                    .frame(height: 150)
                    .cornerRadius(8)
                
                @unknown default:
                    EmptyView()
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text(town.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorConstants.textPrimary)
                
                Text(town.department)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(ColorConstants.textSecondary)
                
                Text(town.description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(ColorConstants.textSecondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.primary)
                        Text("\(town.coffeeCount) coffees")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(ColorConstants.textSecondary)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.primary)
                        Text("\(town.farmerCount) farmers")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(ColorConstants.textSecondary)
                    }
                }
            }
            .padding(12)
            .background(ColorConstants.surfaceLight)
            .cornerRadius(8)
        }
        .background(ColorConstants.surfaceLight)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorConstants.borderLight, lineWidth: 1)
        )
    }
}

// MARK: - Placeholder TownDetailView
struct TownDetailView: View {
    let town: Town
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(town.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ColorConstants.textPrimary)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Department: \(town.department)")
                        .foregroundColor(ColorConstants.textSecondary)
                    Text("Zip Code: \(town.postalCode)")
                        .foregroundColor(ColorConstants.textSecondary)
                    Text("Coffees: \(town.coffeeCount)")
                        .foregroundColor(ColorConstants.textSecondary)
                    Text("Farmers: \(town.farmerCount)")
                        .foregroundColor(ColorConstants.textSecondary)
                }
                .padding(20)
                .background(ColorConstants.surfaceLight)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle(town.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TownsListView(
        viewModel: TownsListViewModel(
            getTownsUseCase: DIContainer.shared.makeGetTownsUseCase()
        )
    )
    .preferredColorScheme(.dark)
}
