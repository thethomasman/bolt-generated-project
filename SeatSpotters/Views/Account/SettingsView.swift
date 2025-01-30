import SwiftUI

struct SettingsView: View {
  var body: some View {
    Form {
      Section(header: Text("Account").foregroundColor(NeonTheme.neonBlue)) {
        Text("Profile Settings")
        Text("Payment Methods")
        Text("Notification Preferences")
      }
      
      Section(header: Text("Advanced").foregroundColor(NeonTheme.neonBlue)) {
        Toggle("Dark Mode", isOn: .constant(true))
        Text("App Version 1.0.0")
      }
    }
    .foregroundColor(.white)
    .background(NeonTheme.background)
  }
}
