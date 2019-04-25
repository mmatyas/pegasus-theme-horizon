import QtQuick 2.0

Image {
    property var game
    readonly property var assets: game.assets

    anchors.fill: parent
    fillMode: source == assets.tile
        ? Image.PreserveAspectFit
        : Image.PreserveAspectCrop

    source: assets.banner
        || (assets.logo && assets.screenshots && assets.screenshots[0])
        || assets.steam
        || assets.marquee
        || assets.boxFront
        || assets.tile
    sourceSize { width: 256; height: 256 }
    asynchronous: true

    visible: opacity > 0.001
    opacity: status == Image.Ready ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 150 } }

    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.2
        visible: parent.source != assets.tile
    }

    Image {
        anchors.fill: parent
        anchors.margins: parent.width * 0.1
        fillMode: Image.PreserveAspectFit
        source: assets.logo
        sourceSize { width: 256; height: 256 }
        asynchronous: true
    }
}
