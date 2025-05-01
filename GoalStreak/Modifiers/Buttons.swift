//
//  Buttons.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

// MARK: Primär-knapp
struct PrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
      content
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

// MARK: Sekundär-knapp
struct SecondaryButton: ViewModifier {
    func body(content: Content) -> some View {
      content
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.3))
        .foregroundColor(.black)
        .cornerRadius(10)
    }
}

// MARK: - Tryckeffekt via ButtonStyle
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Extensions för enkel användning
extension View {
    func primaryButton() -> some View {
      self
      .modifier(PrimaryButton())
      .buttonStyle(ScaleButtonStyle())
    }
    
    func secondaryButton() -> some View {
      self
      .modifier(SecondaryButton())
      .buttonStyle(ScaleButtonStyle())
    }
}
