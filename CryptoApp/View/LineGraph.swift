//
//  LineGraph.swift
//  CryptoApp
//
//  Created by Андрей Груненков on 03.05.2022.
//

import SwiftUI

struct LineGraph: View {
    // Number of plots...
    var data: [Double]
    
    @State var currentPlot = ""
    
    //Offset...
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    
    @State var translation: CGFloat = 0
    
    var body: some View {
        
        GeometryReader {proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                
                //width...
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack{
                
                
                //Converting plot as points...
                
                //Path ....
                Path{ path in
                    
                    //drawing the points...
                    path.move(to: CGPoint(x: 0, y: 0))
                    
                    path.addLines(points)
                    
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                
                    // Gradient...
                    LinearGradient(colors: [
                        Color.blue,
                        Color.yellow
                    ], startPoint: .leading, endPoint: .trailing)
                
                )
                // Path Background Coloring...
                FillBG()
                // Clipping the shape
                    .clipShape(
                    
                        Path{path in
                            // drawing the point
                            path.move(to: CGPoint(x: 0, y: 0))
                            
                            path.addLines(points)
                            
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
                    //.padding(.top, 15)
            }
            .overlay(
                // Drag indicator...
                VStack(spacing: 0) {
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.yellow, in: Capsule())
                        //.offset(x: translation < 10 ? 30 : 0)
                        //.offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 1, height: 45)
                        .padding(.top, 0)
                    
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 22, height: 22)
                        .overlay(
                        
                            Circle()
                                .fill(Color.black)
                                .frame(width: 10, height: 10)
                            
                        )
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 1, height: 55)
                    
                }
                    .frame(width: 80, height: 170)
                // 170 / 2 = 85 - 15 => circle ring size...
                    .offset(y: 70)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0)
            )
            
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                
                withAnimation{ showPlot = true }
                
                let translation = value.location.x
                
                // Getting index
                
                let minIndex = min(Int((translation / width).rounded() - 1), data.count - 1)
                
                let index = (minIndex < 0) ? 0 : minIndex
                
                currentPlot = "$ \(data[index])"
                self.translation = translation
                
                offset = CGSize(width: points[index].x - 140, height: points[index].y - height - 30)
                
            }).onEnded({ value in
                
                withAnimation{ showPlot = false }
                
            }))
            
        }
        .overlay(
            VStack(alignment: .leading) {
                
                let max = data.max() ?? 0
                
                Text("$ \(Int(max))")
                    .font(.caption.bold())
                
                Spacer()
                
                Text("$ 0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal,  10)
    }
    
    @ViewBuilder
    func FillBG()->some View{
        LinearGradient(colors: [
            Color.white.opacity(0.3),
            Color.blue.opacity(0.3),
            Color.white.opacity(0.3)
        ], startPoint: .top,
        endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
