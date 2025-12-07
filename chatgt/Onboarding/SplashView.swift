import SwiftUI

struct SplashView: View {
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            Image("image.launch.screen")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
             
                Image("image.launch.logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 200)
                    .matchedGeometryEffect(id: "logo", in: animation)
                
                Spacer()
            }
        }
    }
}
