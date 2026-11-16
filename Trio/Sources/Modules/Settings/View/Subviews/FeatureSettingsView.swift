//
//  FeatureSettingsView.swift
//  Trio
//
//  Created by Deniz Cengiz on 26.07.24.
//
import Foundation
import SwiftUI
import Swinject

struct FeatureSettingsView: BaseView {
    let resolver: Resolver

    @ObservedObject var state: Settings.StateModel

    @Environment(\.colorScheme) var colorScheme
    @Environment(AppState.self) var appState

    @AppStorage("backgroundKeepAlive.mode") private var keepAliveMode: String = BackgroundKeepAlive.Mode.smart.rawValue
    @AppStorage("backgroundKeepAlive.stallMinutes") private var stallMinutes: Int = 10
    @AppStorage("backgroundKeepAlive.maxSessionMinutes") private var maxSessionMinutes: Int = 45

    var body: some View {
        Form {
            Section(
                header: Text("Trio Features"),
                content: {
                    Text("Treatments").navigationLink(to: .treatmentsSettings, from: self)
                    Text("Shortcuts").navigationLink(to: .shortcutsConfig, from: self)
                    Text("Remote Control").navigationLink(to: .remoteControlConfig, from: self)
                }
            )
            .listRowBackground(Color.chart)

            Section(
                header: Text("Trio Personalization"),
                content: {
                    Text("User Interface").navigationLink(to: .userInterfaceSettings, from: self)
                    Text("App Icons").navigationLink(to: .iconConfig, from: self)
                }
            )
            .listRowBackground(Color.chart)

            Section(
                header: Text("后台保活"),
                content: {
                    Picker("保活模式", selection: $keepAliveMode) {
                        ForEach(BackgroundKeepAlive.Mode.allCases) { mode in
                            Text(mode.title).tag(mode.rawValue)
                        }
                    }
                    if keepAliveMode == BackgroundKeepAlive.Mode.smart.rawValue {
                        Stepper(
                            "无数据 \(stallMinutes) 分钟后启动保活",
                            value: $stallMinutes,
                            in: 5 ... 60,
                            step: 5
                        )
                        Stepper(
                            "最长保活 \(maxSessionMinutes) 分钟",
                            value: $maxSessionMinutes,
                            in: 15 ... 180,
                            step: 15
                        )
                    }
                    Text("Trio 在后台保持运行，CGM 掉线后能更快重连。智能模式只在数据停更时启动，仍会带来额外耗电。")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            )
            .listRowBackground(Color.chart)
            Section(
                header: Text("Anonymized Data Sharing"),
                content: {
                    Text("App Diagnostics").navigationLink(to: .appDiagnostics, from: self)
                }
            )
            .listRowBackground(Color.chart)
        }
        .scrollContentBackground(.hidden)
        .background(appState.trioBackgroundColor(for: colorScheme))
        .navigationTitle("Feature Settings")
        .navigationBarTitleDisplayMode(.automatic)
    }
}
