import SwiftUI

struct ContentView: View {
    @State private var poundsText: String = ""
    @State private var kilogramsText: String = ""
    @State private var isEditingPounds: Bool = false
    @State private var isEditingKilograms: Bool = false
    
    // Barbell weight calculation states
    @State private var barWeight: String = "25"
    @State private var plates2_5: String = "0"
    @State private var plates5: String = "0"
    @State private var plates10: String = "0"
    @State private var plates25: String = "0"
    @State private var plates45: String = "0"
    @State private var totalWeight: Double = 0.0
    @State private var totalWeightKg: Double = 0.0
    
    // Plates Calculator states
    @State private var targetWeight: String = ""
    @State private var finalWeight: Double = 0.0
    @State private var plateCounts: [Int] = [0, 0, 0, 0, 0] // 2.5, 5, 10, 25, 45 lbs plates
    
    let plateWeights = [2.5, 5.0, 10.0, 25.0, 45.0]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pounds <-> Kilogram Converter").font(.headline)) {
                    HStack {
                        TextField("Pounds", text: $poundsText, onEditingChanged: { isEditing in
                            isEditingPounds = isEditing
                            if !isEditing {
                                if let poundsValue = Double(poundsText) {
                                    kilogramsText = String(format: "%.2f", poundsValue * 0.453592)
                                }
                            }
                        })
                        .keyboardType(.decimalPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: poundsText) { newValue in
                            if !isEditingKilograms {
                                convertPoundsToKilograms(newValue)
                            }
                        }
                        
                        Text("Pounds")
                            .frame(minWidth: 60, alignment: .leading)
                    }
                    
                    HStack {
                        TextField("Kilograms", text: $kilogramsText, onEditingChanged: { isEditing in
                            isEditingKilograms = isEditing
                            if !isEditing {
                                if let kilogramsValue = Double(kilogramsText) {
                                    poundsText = String(format: "%.2f", kilogramsValue / 0.453592)
                                }
                            }
                        })
                        .keyboardType(.decimalPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: kilogramsText) { newValue in
                            if !isEditingPounds {
                                convertKilogramsToPounds(newValue)
                            }
                        }
                        
                        Text("Kilograms")
                            .frame(minWidth: 60, alignment: .leading)
                    }
                }
                
                Section(header: Text("Barbell Weight Calculator").font(.headline)) {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Bar Weight")
                            Spacer()
                            TextField("25", text: $barWeight)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("2.5 lbs plates on each side")
                            Spacer()
                            TextField("0", text: $plates2_5)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("5 lbs plates on each side")
                            Spacer()
                            TextField("0", text: $plates5)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("10 lbs plates on each side")
                            Spacer()
                            TextField("0", text: $plates10)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("25 lbs plates on each side")
                            Spacer()
                            TextField("0", text: $plates25)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("45 lbs plates on each side")
                            Spacer()
                            TextField("0", text: $plates45)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        Button(action: calculateTotalWeight) {
                            Text("Calculate Total Weight")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Text("Total Weight: \(String(format: "%.2f", totalWeight)) lbs / \(String(format: "%.2f", totalWeightKg)) kg")
                            .font(.headline)
                            .padding(.top, 10)
                    }
                }
                
                Section(header: Text("Plates Calculator").font(.headline)) {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Bar Weight")
                            Spacer()
                            TextField("25", text: $barWeight)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("Target Weight")
                            Spacer()
                            TextField("Enter target weight", text: $targetWeight)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .frame(maxWidth: 150)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        Button(action: calculatePlateDistribution) {
                            Text("Calculate Plates Needed")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Text("Final Weight: \(String(format: "%.2f", finalWeight)) lbs")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        ForEach(0..<plateWeights.count, id: \.self) { index in
                            HStack {
                                Text("\(Int(plateWeights[index])) lbs plates on each side    ")
                                //Spacer()
                                Text("\(plateCounts[index])")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Gym Calc 💪🏼🧮")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private func convertPoundsToKilograms(_ pounds: String) {
        if let poundsValue = Double(pounds) {
            let kilogramsValue = poundsValue * 0.453592
            kilogramsText = String(format: "%.2f", kilogramsValue)
        } else {
            kilogramsText = ""
        }
    }
    
    private func convertKilogramsToPounds(_ kilograms: String) {
        if let kilogramsValue = Double(kilograms) {
            let poundsValue = kilogramsValue / 0.453592
            poundsText = String(format: "%.2f", poundsValue)
        } else {
            poundsText = ""
        }
    }
    
    private func calculateTotalWeight() {
        let bar = Double(barWeight) ?? 0.0
        let plates2_5Total = (Double(plates2_5) ?? 0.0) * 2 * 2.5
        let plates5Total = (Double(plates5) ?? 0.0) * 2 * 5
        let plates10Total = (Double(plates10) ?? 0.0) * 2 * 10
        let plates25Total = (Double(plates25) ?? 0.0) * 2 * 25
        let plates45Total = (Double(plates45) ?? 0.0) * 2 * 45
        
        totalWeight = bar + plates2_5Total + plates5Total + plates10Total + plates25Total + plates45Total
        totalWeightKg = totalWeight * 0.453592
    }
    
    private func calculatePlateDistribution() {
        guard let targetWeight = Double(targetWeight) else { return }
        
        let bar = Double(barWeight) ?? 0.0
        var remainingWeight = (targetWeight - bar) / 2 // since plates are added on both sides
        var plateCountsTemp: [Int] = [0, 0, 0, 0, 0]
        
        for i in stride(from: plateWeights.count - 1, through: 0, by: -1) {
            let plateCount = Int(floor(remainingWeight / plateWeights[i]))
            plateCountsTemp[i] = plateCount
            remainingWeight -= Double(plateCount) * plateWeights[i]
        }
        
        plateCounts = plateCountsTemp
        finalWeight = bar + plateCounts.enumerated().reduce(0) { sum, pair in
            sum + Double(pair.element) * 2 * plateWeights[pair.offset]
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
