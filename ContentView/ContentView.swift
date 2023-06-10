//
//  ContentView.swift
//  TEST
//
//  Created by 김인섭 on 2023/06/02.
//

import SwiftUI

struct ContentView: VAS {
    
    // MARK: VAS
    typealias Action = ContentViewAction
    typealias State = ContentViewState
    
    @StateObject var state: State
    let action: Action
    
    // MARK: Properties
    @Namespace var animation
    let columns: [GridItem] = Array(repeating: .init(), count: 3)
    let items: [String] = Array(repeating: .init(), count: 100)

    var body: some View {
        VStack(spacing: 0) {
            TabBar()
            Content()
        }
    }
    
    static func build() -> some View {

        let state = ContentViewState()
        let action = ContentViewAction
            .init(
                state: state
            )

        return ContentView
            .init(
                state: state,
                action: action
            )
    }
}


// MARK: SubViews
extension ContentView {
    
    @ViewBuilder
    func TabBar() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(
                        state.currentTab == tab ?
                        .title2 : .title3
                    )
                    .foregroundColor(
                        state.currentTab == tab ?
                        .black : .gray
                    )
                    .padding()
                    .background(alignment: .bottom) {
                        if state.currentTab == tab {
                            Color
                                .black
                                .frame(maxWidth: .infinity)
                                .frame(height: 2)
                                .matchedGeometryEffect(
                                    id: "underline",
                                    in: animation
                                )
                        }
                    }
                    .onTapGesture {
                        action
                            .didTapTab(tab: tab)
                    }
            }
        }
        .background(alignment: .bottom) {
            Color
                .gray
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    func Content() -> some View {
        
        TabView(selection: $state.currentTab) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(items.enumerated()), id: \.offset) { offset, item in
                            Text("\(offset)")
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .background(alignment: .bottom) {
                                    Color
                                        .gray
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 1)
                                }
                            
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView
                .build()
        }
    }
}
