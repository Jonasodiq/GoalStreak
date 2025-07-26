//
//  InfoRowView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-10.
//

import SwiftUI

struct InfoRowView: View {
  
  // MARK: - PROPERTIES
  var icon: String
  var tint: Color
  var label: String
  var value: String
  var isLink: Bool = false
  var linkDestination: URL? = nil

  // MARK: - BODY
  var body: some View {
    Group {
      if isLink, let destination = linkDestination {
        Link(destination: destination) {
          rowContent
            .foregroundColor(.blue)
        }
      } else {
        rowContent
      }
    }
  }

  // MARK: Row
  private var rowContent: some View {
    HStack {
      iconView(icon, tint)
        .padding(.trailing, 8)
      Text(label)
      Spacer()
      Text(value)
        .font(.subheadline.bold())
        .foregroundColor(isLink ? .blue : .secondary)
    }
  }
  
  // MARK: Icon
  private func iconView(_ systemName: String, _ color: Color) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8)
        .frame(width: 30, height: 30)
        .foregroundColor(color)
      Image(systemName: systemName)
        .foregroundColor(.white)
        .fontWeight(.semibold)
    }
  }
}

// MARK: - PREVIEW
#Preview {
  List {
    InfoRowView(
      icon: "swift",
      tint: .orange,
      label: "Technology",
      value: "Swift"
    )
    InfoRowView(
      icon: "globe",
      tint: .blue,
      label: "Website",
      value: "My Portfolio",
      isLink: true,
      linkDestination: URL(string: "https://my-easy-portfolio.netlify.app/")
    )
  }
}
