import QtQuick 2.0

Item {
    id: root

    readonly property bool active: GridView.isCurrentItem
    readonly property real widthRatio: 16 / 9
    readonly property int activeImageH: height * 1.06
    readonly property int activeImageW: activeImageH * widthRatio
    readonly property int inactiveImageH: height * 0.85
    readonly property int inactiveImageW: inactiveImageH * widthRatio
    readonly property int activePadding: height * 0.03
    readonly property int scaleTime: 100

    signal clicked()
    signal entered(rect geometry)

    z: active ? 65000 : 0

    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            const coords = mapToItem(root, container.x, container.y);
            const geometry = Qt.rect(coords.x, coords.y, container.width, container.height);
            root.entered(geometry);
            return;
        }
    }

    Rectangle {
        id: shadow

        readonly property int shadowWidth: container.width * 0.015

        anchors.centerIn: container
        width: container.width + 2 * shadowWidth
        height: container.height + 2 * shadowWidth
        radius: container.radius * 1.3

        color: "#000"
        opacity: 0.2
    }

    Rectangle {
        id: container

        readonly property real extraWidth: active ? 2 * activePadding : 0
        readonly property real extraHeight: active ? title.height + 3 * activePadding : 0
        readonly property real extraVOffset: active ? (title.height * 0.5 + activePadding * 0.5) : 0

        width: imgContainer.targetW + extraWidth
        height: imgContainer.targetH + extraHeight
        color: active ? "#eee" : "transparent"
        radius: activePadding

        anchors.centerIn: parent
        anchors.verticalCenterOffset: extraVOffset

        Behavior on width { NumberAnimation { duration: scaleTime } }
        Behavior on height { NumberAnimation { duration: scaleTime } }
        Behavior on anchors.verticalCenterOffset { NumberAnimation { duration: scaleTime } }

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

            GameImage {
                id: img
                game: modelData
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

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
            onDoubleClicked: {
                const coords = mapToItem(root, container.x, container.y);
                const geometry = Qt.rect(coords.x, coords.y, container.width, container.height);
                root.entered(geometry);
            }
        }
    }
}
