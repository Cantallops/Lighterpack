//
//  Dragable.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/09/29.
//

import SwiftUI

protocol DragableItemProvider {
    func dragableItem() -> NSItemProviderWriting
}

extension View {
    func onDrag(_ item: DragableItemProvider) -> some View {
        self.onDrag {
            NSItemProvider(object: item.dragableItem())
        }
    }
}

extension ForEach where Content: View {
    
}
