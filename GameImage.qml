import QtQuick 2.0

Image {
    property var game
    readonly property var assets: game.assets

    anchors.fill: parent
    fillMode: source == (assets.steam || assets.marquee || assets.boxFront)
        ? Image.PreserveAspectCrop
        : Image.PreserveAspectFit

    source: assets.banner || assets.steam || assets.marquee || assets.tile || assets.logo || assets.boxFront
    sourceSize { width: 256; height: 256 }
    asynchronous: true
}
