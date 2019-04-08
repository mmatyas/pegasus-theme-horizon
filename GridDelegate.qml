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
    readonly property int scaleTime: 100

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
        readonly property real extraVOffset: active ? (title.height * 0.5 + activePadding * 0.5) : 0

        width: imgContainer.targetW + extraWidth
        height: imgContainer.targetH + extraHeight
        color: active ? "#eee" : "#55333333"
        radius: activePadding

        anchors.centerIn: parent
        anchors.verticalCenterOffset: extraVOffset

        Behavior on width { NumberAnimation { duration: scaleTime } }
        Behavior on height { NumberAnimation { duration: scaleTime } }
        Behavior on anchors.verticalCenterOffset { NumberAnimation { duration: scaleTime } }

        Item {
            id: imgContainer

            readonly property int targetW: active ? activeImageW : inactiveImageW
            readonly property int targetH: active ? activeImageH : inactiveImageH

            width: targetW
            height: targetH

            anchors.top: parent.top
            anchors.topMargin: active ? activePadding : 0
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on width { NumberAnimation { duration: scaleTime } }
            Behavior on height { NumberAnimation { duration: scaleTime } }
            Behavior on anchors.topMargin { NumberAnimation { duration: scaleTime } }

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

            anchors.bottom: parent.bottom
            anchors.left: imgContainer.left
            anchors.right: imgContainer.right
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
