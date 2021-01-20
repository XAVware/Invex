//
//  DollarAmountView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/23/20.
//

import SwiftUI
//Make 3/4 screen height
struct DollarAmountView: View {
    @State var amount: String = "0"
    
    @State var closingAction: () -> Void
        
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.closingAction()
                }) {
                    Text(" X ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                }
                .frame(width: 80, height: 60)
                
                Text("Cost of package")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                
                Button(action: {
                    self.closingAction()
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                }
                .frame(width: 80, height: 60)
            }
            .padding()
            .frame(height: 60)
            
            
            Text("$ \($amount.wrappedValue)")
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 72, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "365cc4"))
            
            Spacer()
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    ForEach(1 ... 3, id: \.self) { value in
                        
                        Button(action: {
                            self.numberTapped(value: "\(value)")
                        }) {
                            Text("\(value)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .font(.system(size: 42, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                        }
                        .frame(width: 100, height: 70)
                        
                        if value != 3 { Divider() }
                        
                    } //: ForEach
                    
                } //: HStack
                .frame(height: 80)
                
                Divider()
                
                HStack(spacing: 0) {
                    ForEach(4 ... 6, id: \.self) { value in
                        Button(action: {
                            self.numberTapped(value: "\(value)")
                        }) {
                            Text("\(value)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .font(.system(size: 42, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                        }
                        .frame(width: 100, height: 70)
                        
                        if value != 6 { Divider() }
                        
                    } //: ForEach
                } //: HStack
                .frame(height: 80)
                
                Divider()
                
                HStack(spacing: 0) {
                    ForEach(7 ... 9, id: \.self) { value in
                        Button(action: {
                            self.numberTapped(value: "\(value)")
                        }) {
                            Text("\(value)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .font(.system(size: 42, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                        }
                        .frame(width: 100, height: 70)
                        
                        if value != 9 { Divider() }
                        
                    } //: ForEach
                } //: HStack
                .frame(height: 80)
                
                Divider()
                
                HStack(spacing: 0) {
                    Button(action: {
                        self.numberTapped(value: ".")
                    }) {
                        Text(".")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .font(.system(size: 42, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                            
                    }
                    .frame(width: 100, height: 70)
                    
                    Divider()
                    
                    Button(action: {
                        self.numberTapped(value: "0")
                    }) {
                        Text("0")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .font(.system(size: 42, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                    }
                    .frame(width: 100, height: 70)
                    
                    Divider()
                    
                    Button(action: {
                        self.numberTapped(value: "-")
                    }) {
                        Image(systemName: "delete.left.fill")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .padding(.vertical, 3)
                            .accentColor(Color(hex: "365cc4"))
                    }
                    .frame(width: 100, height: 70)
                    
                } //: HStack
                .frame(height: 80)
                
            } //: VStack - Number Pad
            .padding()
            .frame(width: 300)
            
        }
        .background(Color.white)
        .cornerRadius(9)
        .frame(width: 500, height: 550, alignment: .center)
    }
    
    
    func numberTapped(value: String) {
        var tempAmount: String = self.amount
        //Order is very important
        
        if value == "." {
            guard !tempAmount.contains(".") else {
                print("Amount already contains decimal -- Returning")
                return
            }
        }
        
        
        
        if value == "-" {
            guard tempAmount != "0" else {
                print("Backspace Attempted but amount is 0")
                return
            }
            
            guard tempAmount.count != 1 else {
                self.amount = "0"
                print("Final number deleted, returning to zero")
                return
            }
            
            
            self.amount = String(tempAmount.dropLast())
            return
        }
        
        
        if tempAmount == "0" && value != "0" {
            guard value != "." && value != "-"  else {
                print("Returning -- . or - entered while amount is 0")
                return
            }
            tempAmount = value
            self.amount = tempAmount
            print("Original zero value replaced with new amount")
            return
        } else if tempAmount == "0" && value == "0" {
            print("Returning -- tempAmount == 0 && value == 0")
            return
        } else {
            tempAmount.append(value)
        }
        
//        let formattedAmount = String(format: "%.2f", tempAmount)

        self.amount = tempAmount
    }
    
    
}



struct DollarAmountView_Previews: PreviewProvider {
    static var previews: some View {
        DollarAmountView(closingAction: {
            //
        })
            .previewLayout(.fixed(width: 500, height: 550))
    }
}
