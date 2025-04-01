
import Library
import SwiftUI

public struct SettingView: View {
    private enum Tabs: Int, CaseIterable, Identifiable {
        public var id: Self {
            self
        }

        #if os(macOS)
            case app
        #endif

        case core, packetTunnel,
            // onDemandRules, profileOverride,
             sponsors

        var label: some View {
            Label(title, systemImage: iconImage)
        }

        var title: String {
            switch self {
            #if os(macOS)
                case .app:
                    return String(localized: "App")
            #endif
            case .core:
                return String(localized: "Core")
            case .packetTunnel:
                return String(localized: "Packet Tunnel")
            //case .onDemandRules:
            //    return String(localized: "On Demand Rules")
            //case .profileOverride:
            //    return String(localized: "Profile Override")
            case .sponsors:
                return String(localized: "Sponsors")
            }
        }

         var iconImage: String {
            switch self {
            #if os(macOS)
                case .app:
                    return "app.badge.fill"
            #endif
            case .core:
                return "shippingbox.fill"
            case .packetTunnel:
                return "aspectratio.fill"
          //  case .onDemandRules:
          //      return "filemenu.and.selection"
          //  case .profileOverride:
          //      return "square.dashed.inset.filled"
            case .sponsors:
                return "heart.fill"
            }
        }

        @MainActor
        var contentView: some View {
            viewBuilder {
                switch self {
                #if os(macOS)
                    case .app:
                        AppView()
                #endif
                case .core:
                    CoreView()
                case .packetTunnel:
                    PacketTunnelView()
          //      case .onDemandRules:
          //          OnDemandRulesView()
          //      case .profileOverride:
           //         ProfileOverrideView()
                case .sponsors:
                    SponsorsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            #if os(iOS)
                .background(Color(uiColor: .systemGroupedBackground))
            #endif
        }

        @MainActor
        var navigationLink: some View {
            FormNavigationLink {
                contentView
            } label: {
                label
            }
        }
    }

    // 添加动画状态
    @State private var selectedTab: Tabs?
    @State private var isLoading = true
    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        FormView {
            #if os(macOS)
                makeNavigationLink(tab: .app)
                    .transition(.opacity)
            #endif
            
            // 核心功能区
            Section {
                ForEach([Tabs.core, Tabs.packetTunnel]) { tab in
                    makeNavigationLink(tab: tab)
                        .transition(.opacity)
                }
            } header: {
                Text(String(localized: "Function settings"))
                    .font(.headline)
            }
            
        }
        .animation(.easeInOut, value: selectedTab)
    }
    
    // 自定义导航链接组件
    private func makeNavigationLink(tab: Tabs) -> some View {
        FormNavigationLink {
            tab.contentView
                .transition(.opacity)
        } label: {
            Label(tab.title, systemImage: tab.iconImage)
                .foregroundColor(.accentColor)
        }
        .buttonStyle(SettingButtonStyle())
    }
}

// 自定义链接行组件
private struct LinkRow: View {
    let title: String
    let icon: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            Label(title, systemImage: icon)
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.plain)
    }
}

// 自定义按钮样式
private struct SettingButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
