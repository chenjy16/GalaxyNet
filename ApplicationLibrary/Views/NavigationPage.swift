import Foundation
import Library
import SwiftUI

public enum NavigationPage: Int, CaseIterable, Identifiable {
    public var id: Self {
        self
    }

    case dashboard
    #if os(macOS)
        case groups
        case connections
    #endif
    case profiles
    //case logs
    case settings
}

public extension NavigationPage {
    #if os(macOS)
        static var macosDefaultPages: [NavigationPage] {
            [.logs, .profiles, .settings]
        }
    #endif

    var label: some View {
        Label(title, systemImage: iconImage)
             .tint(.accentColor)  // 使用系统主题色
             .font(.system(size: 16, weight: .medium))  // 统一字体大小和粗细
    }

    var title: String {
        switch self {
        case .dashboard:
            return String(localized: "Dashboard")
        #if os(macOS)
            case .groups:
                return String(localized: "Groups")
            case .connections:
                return NSLocalizedString("Connections", comment: "")
        #endif
        //case .logs:
        //    return String(localized: "Logs")
        case .profiles:
            return String(localized: "Profiles")
        case .settings:
            return String(localized: "Settings")
        }
    }

    private var iconImage: String {
        switch self {
        case .dashboard:
            return "house.fill"
        #if os(macOS)
            case .groups:
                return "rectangle.3.group.fill"
            case .connections:
                return "list.bullet.rectangle.portrait.fill"
        #endif
        //case .logs:
        //    return "doc.text.fill"
        case .profiles:
            return "doc.text.fill"
        case .settings:
            return "gearshape.fill"
        }
    }

    @MainActor
    var contentView: some View {
        viewBuilder {
            switch self {
            case .dashboard:
                DashboardView()
                 .transition(.opacity)  // 添加过渡动画
            #if os(macOS)
                case .groups:
                    GroupListView()
                case .connections:
                    ConnectionListView()
            #endif
            //case .logs:
            //    LogView()
            case .profiles:
                ProfileView()
            case .settings:
                SettingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        #if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
               .navigationBarTitleDisplayMode(.large)  // 大标题样式
        #endif
    }

    #if os(macOS)
        func visible(_ profile: ExtensionProfile?) -> Bool {
            switch self {
            case .groups, .connections:
                return profile?.status.isConnectedStrict == true
            default:
                return true
            }
        }
    #endif
}
