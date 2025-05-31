//
//  View+ext.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import SwiftUI

extension View {
    func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent, in: .rect(cornerRadius: 16))
    }
    
    func badgeButton() -> some View {
        self
            .font(.caption).bold()
            .foregroundStyle(Color.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.blue)
            .cornerRadius(6)
    }
    
    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
    }
    
    func tappableBackground() -> some View {
        background(Color.black.opacity(0.001))
    }
    
    func addingGradientBackgroundForText() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [.black.opacity(0), .black.opacity(0.3), .black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    @ViewBuilder
    func ifSatisfiedCondition(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self) // with modifer
        } else {
            self
        }
        
    }
}
