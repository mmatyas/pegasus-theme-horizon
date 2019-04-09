import QtQuick 2.0

Item {
    id: root

    readonly property real heightRatio: 9 / 16
    readonly property real openDuration: 350
    property var originData
    property rect originCell

    signal closed()

    anchors.fill: parent
    visible: bgshade.opacity > 0.001


    function open(geometry) {
        originCell = geometry;
        state = "open";
    }


    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isCancel(event)) {
            event.accepted = true;
            state = "";
            root.closed();
            return;
        }
    }


    Rectangle {
        id: bgshade
        anchors.fill: parent
        color: "#000"
        opacity: 0.0
    }

    Rectangle {
        id: containerShadow

        readonly property int shadowWidth: originCell.width * 0.015

        anchors.centerIn: container
        width: container.width + 2 * shadowWidth
        height: container.height + 2 * shadowWidth
        radius: container.radius * 1.3

        color: "#000"
        opacity: 0.2
    }

    Rectangle {
        id: container

        clip: true

        property real padding: originCell.height * 0.015

        x: originCell.x
        y: originCell.y
        width: originCell.width
        height: originCell.height
        radius: originCell.height * 0.03
        color: "#eee"

        anchors.horizontalCenter: undefined
        anchors.verticalCenter: undefined

        Item {
            id: img
            width: originCell.width - 2 * originCell.height * 0.015
            height: width * heightRatio

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: parent.padding

            GameImage {
                game: originData
            }
        }

        Text {
            id: title
            text: originData.title
            color: "#282828"

            font.pixelSize: root.height * 0.045
            font.family: globalFonts.sans
            font.capitalization: Font.AllUppercase
            font.weight: Font.Light

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            width: root.width * 0.6 - img.width - 3 * parent.padding
            anchors.top: img.top
            anchors.bottom: img.bottom
            anchors.left: img.right
            anchors.leftMargin: parent.padding
            elide: Text.ElideRight
            wrapMode: Text.Wrap

            opacity: 0.0
            visible: opacity > 0.001
        }

        Text {
            id: desc

            text: originData.description || originData.summary
            color: "#282828"

            horizontalAlignment: Text.AlignJustify

            font.pixelSize: title.font.pixelSize * 0.6
            font.family: globalFonts.sans
            font.weight: Font.Light

            width: root.width * 0.6 - 2 * parent.padding
            anchors.top: img.bottom
            anchors.bottom: parent.bottom
            anchors.margins: parent.padding
            /*anchors.left: parent.left
            anchors.right: parent.right*/
            anchors.horizontalCenter: parent.horizontalCenter
            elide: Text.ElideRight
            wrapMode: Text.Wrap

            opacity: 0.0
            visible: opacity > 0.001
        }
    }


    states: [
        State {
            name: "open"
            PropertyChanges { target: bgshade; opacity: 0.4 }
            PropertyChanges { target: title; opacity: 1.0 }
            PropertyChanges { target: desc; opacity: 1.0 }
            PropertyChanges { target: container; padding: originCell.height * 0.15 }
            PropertyChanges { target: container; x: 0.0 }
            PropertyChanges { target: container; y: 0.0 }
            PropertyChanges { target: container; width: root.width * 0.6 }
            PropertyChanges { target: container; height: root.height * 0.9 }
            AnchorChanges {
                target: container
                anchors.horizontalCenter: root.horizontalCenter
                anchors.verticalCenter: root.verticalCenter
            }
        }
    ]

    transitions: [
        Transition {
            from: ""; to: "open"
            reversible: true
            PropertyAnimation { target: bgshade; properties: "opacity"; duration: openDuration; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: title; properties: "opacity"; duration: openDuration; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: desc; properties: "opacity"; duration: openDuration; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: container; properties: "padding,width,height"; duration: openDuration; easing.type: Easing.InOutQuad }
            AnchorAnimation { targets: container; duration: openDuration; easing.type: Easing.InOutQuad }
        }
    ]
}
