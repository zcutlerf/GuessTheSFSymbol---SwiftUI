//
//  HowToPlayView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/14/23.
//

import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .contentShape(Rectangle())
                    }
                }
                
                Text("How to Play")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .accessibilityAddTraits(.isHeader)
                
                HStack {
                    Text(attributedString)
                    
                    Spacer()
                    
                    badSFIcon
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 5.0) {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("You know, those cute little symbols with catchy names like:")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                            Label("tortoise", systemImage: "tortoise")
                            Label("info.square", systemImage: "info.square")
                                .accessibilityLabel("info dot square")
                            Label("heart.circle.fill", systemImage: "heart.circle.fill")
                            .accessibilityLabel("heart dot circle dot fill")
                        }
                        .accessibilityElement(children: .combine)
                        
                        Spacer(minLength: 10.0)
                        
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Or, the classic:")
                                .font(.title3)
                                .fontWeight(.medium)
                            Label("rectangle.and.arrow.up.right.and.arrow.down.left.slash", systemImage: "rectangle.and.arrow.up.right.and.arrow.down.left.slash")
                                .accessibilityLabel("rectangle dot and dot arrow dot up dot right dot and dot arrow dot down dot left dot slash")
                        }
                        .accessibilityElement(children: .combine)
                    }
                    .imageScale(.medium)
                    
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("All you have to do is look at the symbol, and type in the right name! Easy enough, right?")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .accessibilityHeading(.h2)
                        
                        Text("You'll earn more points for guessing longer symbol names.")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Single Player")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Race against the clock to guess as many symbol names as possible! See if you can beat those other speedy designers on the leaderboards.")
                        }
                        .accessibilityElement(children: .combine)
                        
                        Spacer(minLength: 10.0)
                        
                        VStack(alignment: .leading) {
                            Text("Multi Player")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Race against a frenemy to mash that keyboard and guess symbol names faster than they can type!")
                        }
                        .accessibilityElement(children: .combine)
                    }
                    
                    Spacer()
                }
                
            }
            .padding()
        }
    }
}

extension HowToPlayView {
    private var attributedString: AttributedString {
        var attributedString: AttributedString = ""
        do {
            attributedString = try AttributedString(markdown: "As an elite app developer, you must undoubtedly be familiar with [SF Symbols.](https://developer.apple.com/sf-symbols/)")
        } catch {
        attributedString = "As an elite app developer, you must undoubtedly be familiar with SF Symbols."
        }
        return attributedString
    }
    
    private var badSFIcon: some View {
        VStack(spacing: 2.0) {
            HStack(spacing: 2.0) {
                Image(systemName: "heart.fill")
                    .font(.title3.bold())
                    .foregroundColor(Color(UIColor.cyan))
                    .rotation3DEffect(Angle(degrees: 45.0), axis: (-30.0, 60.0, -30.0))
                Image(systemName: "star.fill")
                    .font(.title3.bold())
                    .foregroundColor(Color(.systemBlue))
                    .rotation3DEffect(Angle(degrees: -45.0), axis: (-30.0, 60.0, -30.0))
            }
            
            Spacer()
                .frame(height: 5.0)
            
            Image(systemName: "character")
                .font(.title3.bold())
                .foregroundColor(Color(UIColor.green))
                .rotation3DEffect(Angle(degrees: -45.0), axis: (-30.0, 0.0, 0.0))
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 15.0)
                .foregroundColor(.black)
                .shadow(radius: 5.0, x: 3.0, y: 3.0)
        }
        .accessibilityHidden(true)
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
