import QtQuick 2.0

Item {
    id: root

    readonly property bool active: GridView.isCurrentItem
    readonly property real widthRatio: 16 / 9
    readonly property int activeImageH: height * 1.06
    readonly property int activeImageW: activeImageH * widthRatio
    readonly property int inactiveImageH: height * 0.86
    readonly property int inactiveImageW: inactiveImageH * widthRatio
    readonly property int activePadding: height * 0.03

    signal clicked()
    signal entered()

    z: active ? 65000 : 0

    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            root.entered();
            return;
        }
    }

    Rectangle {
        readonly property real extraWidth: active ? 2 * activePadding : 0
        readonly property real extraHeight: active ? title.height + 3 * activePadding : 0

        width: imgContainer.width + extraWidth
        height: imgContainer.height + extraHeight
        color: active ? "#eee" : "#55333333"
        radius: activePadding

        anchors.centerIn: parent
        anchors.verticalCenterOffset: active ? (title.height * 0.5 + activePadding * 0.5) : 0

        Item {
            id: imgContainer
            width: active ? activeImageW : inactiveImageW
            height: active ? activeImageH : inactiveImageH

            anchors.top: parent.top
            anchors.topMargin: active ? activePadding : 0
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: img

                readonly property var assets: modelData.assets

                anchors.fill: parent
                fillMode: source == (assets.steam || assets.marquee || assets.boxFront)
                    ? Image.PreserveAspectCrop
                    : Image.PreserveAspectFit

                source: assets.banner || assets.steam || assets.marquee || assets.tile || assets.logo || assets.boxFront
                sourceSize { width: 256; height: 256 }
                asynchronous: true
            }

            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: title.font.pixelSize
                font.family: globalFonts.sans
                font.bold: true

                text: modelData.title
                color: "#eee"
                elide: Text.ElideRight

                visible: img.status != Image.Ready && img.status != Image.Loading
            }
        }

        Text {
            id: title

            anchors.left: imgContainer.left
            anchors.right: imgContainer.right
            anchors.top: imgContainer.bottom
            anchors.margins: activePadding

            font.pixelSize: activeImageH * 0.11
            font.family: globalFonts.sans
            font.bold: true

            text: modelData.title
            elide: Text.ElideRight

            visible: active
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
            onDoubleClicked: root.entered()
        }
    }
}
