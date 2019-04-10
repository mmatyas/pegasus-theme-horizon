import QtQuick 2.0

Item {
    id: root

    property real leftRadius: 0
    property real rightRadius: 0
    property color baseColor
    property color hoverColor

    readonly property bool isActive: activeFocus || mouse.containsMouse
    readonly property real gradientFactor: 0.3

    property color color: isActive ? hoverColor : baseColor
    Behavior on color { ColorAnimation { duration: 150 }}

    signal clicked()

    Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            root.clicked();
        }
    }

    function gradientAt(percent) {
        return Qt.darker(root.color, 1.0 + gradientFactor * percent)
    }


    Rectangle {
        id: leftCircle

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: leftRadius * 2
        height: leftRadius * 2
        radius: leftRadius

        visible: leftBar.visible
        gradient: Gradient {
            GradientStop { position: 0.0; color: gradientAt(leftCircle.height / root.height) }
            GradientStop { position: 1.0; color: gradientAt(1.0) }
        }
    }

    Rectangle {
        id: leftBar

        anchors.left: parent.left
        anchors.top: parent.top
        width: leftRadius
        height: parent.height - leftRadius

        visible: leftRadius > 0.001
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.color }
            GradientStop { position: 1.0; color: gradientAt(leftBar.height / root.height) }
        }
    }

    Rectangle {
        id: rightCircle

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: rightRadius * 2
        height: rightRadius * 2
        radius: rightRadius

        visible: rightBar.visible
        gradient: Gradient {
            GradientStop { position: 0.0; color: gradientAt(rightCircle.height / root.height) }
            GradientStop { position: 1.0; color: gradientAt(1.0) }
        }
    }

    Rectangle {
        id: rightBar

        anchors.right: parent.right
        anchors.top: parent.top
        width: rightRadius
        height: parent.height - rightRadius

        visible: rightRadius > 0.001
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.color }
            GradientStop { position: 1.0; color: gradientAt(rightBar.height / root.height) }
        }
    }

    Rectangle {
        // center
        anchors.left: leftBar.right
        anchors.right: rightBar.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        gradient: Gradient {
            GradientStop { position: 0.0; color: root.color }
            GradientStop { position: 1.0; color: gradientAt(1.0) }
        }
    }


    MouseArea {
        id: mouse
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
