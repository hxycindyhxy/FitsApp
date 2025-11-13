//
//  FitsAppWidge.swift
//  FitsAppWidge
//
//  Created by Cindy Hu on 13/11/2025.
//

import WidgetKit
import SwiftUI

// MARK: - Data Model
struct SimpleEntry: TimelineEntry {
    let date: Date
    let steps: Int
    let distanceKm: Double
    let stepGoal: Int
    let weeklyData: [DaySteps]
    let totalWeeklySteps: Int
}

struct DaySteps: Identifiable {
    let id = UUID()
    let day: String
    let steps: Int
    let distance: Double
}


// MARK: - Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            steps: 3200,
            distanceKm: 1.88,
            stepGoal: 8000,
            weeklyData: generateWeeklyData(),
            totalWeeklySteps: 62614
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            steps: 2727,
            distanceKm: 1.88,
            stepGoal: 8000,
            weeklyData: generateWeeklyData(),
            totalWeeklySteps: 62614
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            steps: 2727,
            distanceKm: 1.88,
            stepGoal: 8000,
            weeklyData: generateWeeklyData(),
            totalWeeklySteps: 62614
        )
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    static func estimateDistance(for steps: Int) -> Double {
        let meters = Double(steps) * 0.78
        return meters / 1000.0
    }
    
    private func generateWeeklyData() -> [DaySteps] {
        return [
            DaySteps(day: "Monday", steps: 8202, distance: 5.8),
            DaySteps(day: "Tuesday", steps: 4189, distance: 3.1),
            DaySteps(day: "Wednesday", steps: 8437, distance: 6.2),
            DaySteps(day: "Thursday", steps: 12633, distance: 9.1),
            DaySteps(day: "Friday", steps: 7676, distance: 5.6),
            DaySteps(day: "Saturday", steps: 8961, distance: 6.5),
            DaySteps(day: "Sunday", steps: 12516, distance: 9.0)
        ]
    }
}



struct FitsAppWidge: Widget {
    let kind: String = "FitsAppWidge"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("Steps")
        .description("Track your steps")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Main Widget Entry View
struct WidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            default:
                SmallWidgetView(entry: entry)
            }
        }
        .containerBackground(Color.clear, for: .widget)
    }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry

    // Colors tuned to your design
    private let bg = Color(red: 0.80, green: 0.79, blue: 0.87)
    private let ringPrimary = Color(red: 0.95, green: 0.43, blue: 0.20)
    private let ringSecondary = Color(red: 0.99, green: 0.88, blue: 0.66)
    private let ringInner = Color.green.opacity(0.45)
    private let stepsColor = Color(red: 0.95, green: 0.43, blue: 0.20)
    private let distanceColor = Color.green

    var body: some View {
        ZStack {
            bg
        
            // Subtle background scene, scaled down and clipped to avoid clutter
            backgroundScene
                .scaleEffect(0.9)
                .clipped()
            
            HStack(alignment: .center, spacing: 5) {
                // Give the rings enough room to breathe
                rings
                    .frame(width: 40, height: 50)
                    .offset(y:-45)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(entry.steps)")
                            .font(.system(size: 14, weight: .bold).monospaced())
                            .foregroundColor(stepsColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .offset(y:-45)
                        
                        Text("STEPS")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(stepsColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .offset(y:-45)
                    }
                    
                    Text("\(entry.distanceKm, format: .number.precision(.fractionLength(2))) KM")
                        .font(.system(size: 14, weight: .bold).monospaced())
                        .foregroundColor(distanceColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .offset(y:-45)
                }
                .frame(width: 100, height: 200)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)

        }
    }
    
    private var rings: some View {
        let progress = min(max(Double(entry.steps) / Double(max(entry.stepGoal, 1)), 0.0), 1.0)
        let innerProgress = min(max(entry.distanceKm / 5.0, 0.0), 1.0)

        return ZStack {
            // Background ring
            Circle()
                .stroke(ringSecondary.opacity(0.85), lineWidth: 8)

            // Steps ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringPrimary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))

            // Inner background ring
            Circle()
                .inset(by: 8)
                .stroke(ringInner.opacity(0.25), lineWidth: 8)

            // Distance ring
            Circle()
                .inset(by: 8)
                .trim(from: 0, to: innerProgress)
                .stroke(ringInner, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .compositingGroup()
    }

    private var backgroundScene: some View {
        GeometryReader { geo in
            ZStack {
                
                Image("Cloud 1")
                    .resizable()
                    .frame(width: 50, height: 15)
                    .aspectRatio(contentMode: .fit)
                    .offset(x:-43, y: 87)
                
                Image("Cloud 1")
                    .resizable()
                    .frame(width: 50, height: 15)
                    .aspectRatio(contentMode: .fit)
                    .offset(x:40, y: 60)
           
                // Small tree near bottom-left
                VStack(spacing: -8) {
                    Ellipse()
                        .fill(Color(red: 0.33, green: 0.43, blue: 0.20))
                        .frame(width: 55, height: 24)
                        .offset(y: 5)
                    Ellipse()
                        .fill(Color(red: 0.54, green: 0.64, blue: 0.35))
                        .frame(width: 66, height: 28)
                        .offset(y: 10)
                    Ellipse()
                        .fill(Color(red: 0.38, green: 0.58, blue: 0.16))
                        .frame(width: 74, height: 32)
                        .offset(y: 15)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.36, green: 0.26, blue: 0.19))
                        .frame(width: 20, height: 45)
                        .offset(y: 20)
                }
                .frame(maxWidth: .infinity)
                .offset(y: geo.size.height * 0.40)
            }
        }
        .allowsHitTesting(false)
    }
}



