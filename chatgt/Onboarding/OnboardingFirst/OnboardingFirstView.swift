import SwiftUI

struct OnboardingFirstView: View {
    var animation: Namespace.ID
    @State private var contentVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("imagt.onboarding.background.1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
                ZStack {
                    let centerX = geometry.size.width / 2
                    let centerY = geometry.size.height * 0.37
                    let offset: CGFloat = 118 // (130/2) + (82/2) + 16
                    
                    // Top-left
                    IconCard(imageName: "icon_onbording_1")
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 20)
                        .position(x: centerX - offset, y: centerY - offset)
                    
                    // Top-right
                    IconCard(imageName: "icon_onbording_2")
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 20)
                        .position(x: centerX + offset, y: centerY - offset)
                    
                    // Bottom-left
                    IconCard(imageName: "icon_onbording_3")
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 20)
                        .position(x: centerX - offset, y: centerY + offset)
                    
                    // Bottom-right
                    IconCard(imageName: "icon_onbording_4")
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 20)
                        .position(x: centerX + offset, y: centerY + offset)
                    
                    // Center logo
                    IconCard(
                        imageName: "image.launch.logo",
                        size: CGSize(width: 130, height: 130),
                        insets: EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
                    )
                    .matchedGeometryEffect(id: "logo", in: animation)
                    .position(x: centerX, y: centerY)
                }
                
                bottomButtons(geometry: geometry)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                contentVisible = true
            }
        }
    }
    
    func bottomButtons(geometry: GeometryProxy) -> some View {
        let centerY = geometry.size.height * 0.37
        let offset: CGFloat = 118
        
        return VStack(spacing: 16) {
            Spacer()
                .frame(height: centerY + offset + 76)
            
            Text("Top AI Models in One App")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 30)
            
            HStack(spacing: 8) {
                CapsuleButton(title: "Chat GPT")
                CapsuleButton(title: "DeepSeek")
                CapsuleButton(title: "Grok & others")
            }
            .opacity(contentVisible ? 1 : 0)
            .offset(y: contentVisible ? 0 : 30)
            
            Text("Chat GT unites the world's smartest systems")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 30)
            

            Button(action: {
                // Handle continue action
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .opacity(contentVisible ? 1 : 0)
            .offset(y: contentVisible ? 0 : 30)
        }
        .padding(.bottom, geometry.safeAreaInsets.bottom + 84)
    }
}
