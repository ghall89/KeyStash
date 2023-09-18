import SwiftUI

struct AppSettings: View {
	@AppStorage("lockApp") var lockApp: Bool = false
	
    var body: some View {
			VStack {
				Toggle(isOn: $lockApp, label: {
					Text("Lock Data")
				})
				.toggleStyle(.switch)
			}
			.frame(width: 375, height: 150)
    }
}
