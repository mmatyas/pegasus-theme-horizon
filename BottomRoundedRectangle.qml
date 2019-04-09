import QtQuick 2.0

Item {
    id: root

    property real leftRadius: 0
    property real rightRadius: 0
    property color baseColor
    property color hoverColor

    readonly property bool isActive: activeFocus || mouse.containsMouse
    readonly property color color: isActive ? hoverColor : baseColor

    signal clicked()

    Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            root.clicked();
        }
    }


    Rectangle {
        // bottom-left circle
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: leftRadius * 2
        height: leftRadius * 2
        color: root.color
        radius: leftRadius
        visible: leftBar.visible
    }

    Rectangle {
        id: leftBar
        anchors.left: parent.left
        anchors.top: parent.top
        width: leftRadius
        height: parent.height - leftRadius
        color: root.color
        visible: leftRadius > 0.001
    }

    Rectangle {
        // bottom-right circle
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: rightRadius * 2
        height: rightRadius * 2
        color: root.color
        radius: rightRadius
        visible: rightBar.visible
    }

    Rectangle {
        id: rightBar
        anchors.right: parent.right
        anchors.top: parent.top
        width: rightRadius
        height: parent.height - rightRadius
        color: root.color
        visible: rightRadius > 0.001
    }

    Rectangle {
        // center
        anchors.left: leftBar.right
        anchors.right: rightBar.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: root.color
    }


    MouseArea {
        id: mouse
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
