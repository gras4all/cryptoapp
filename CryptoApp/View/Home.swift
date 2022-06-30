//
//  Home.swift
//  CryptoApp
//
//  Created by Андрей Груненков on 03.05.2022.
//

import SwiftUI

struct Home: View {
    @State var currentCoin: String = "BTC"
    @Namespace var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    var body: some View {
        VStack{
            
            if let coins = appModel.coins, let coin = appModel.currentCoin {
                //MARK: Sample UI
                HStack(spacing: 15) {
                    Circle()
                        .fill(.red)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bitcoin")
                            .font(.callout)
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomControl(coins: coins)
                
                GraphView(coin: coin)
                
                Controls()
            } else {
                
                ProgressView()
                    .tint(Color("LightGreen"))
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    //MARK: Line graph
    @ViewBuilder
    func GraphView(coin: CryptoModel)->some View{
        LineGraph(data: coin.last_7days_price.price)
            .frame(height: 250)
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
    }
    
    //MARK: Custom segmented control
    @ViewBuilder
    func CustomControl(coins: [CryptoModel])->some View{
        // SAMPLE Data

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15){
                ForEach(coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .contentShape(Rectangle())
                        .background{
                            if currentCoin == coin.symbol.uppercased() {
                                Rectangle()
                                    .fill(Color.gray)
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            appModel.currentCoin = coin
                            withAnimation{currentCoin = coin.symbol.uppercased()}
                        }
                }
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.vertical)
    }
    
    //MARK: Controls
    @ViewBuilder
    func Controls()->some View {
        HStack(spacing: 20){
            Button {} label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    }
            }
            
            Button {} label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.green)
                    }
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
