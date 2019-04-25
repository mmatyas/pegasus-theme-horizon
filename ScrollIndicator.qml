import QtQuick 2.0

Rectangle {
    id: longScrollMark

    function start() {
        timer.start();
    }

    function stop() {
        timer.stop();
        active = false;
    }

    property alias letter: text.text
    property int maxSize

    property bool active: false
    property int size: active ? maxSize : minSize
    readonly property int minSize: 2
    readonly property color baseColor: '#26b'

    width: size
    height: size
    radius: width * 0.5
    gradient: Gradient {
        GradientStop { position: 0.0; color: baseColor }
        GradientStop { position: 1.0; color: Qt.darker(baseColor, 1.2) }
    }
    visible: size > minSize

    Behavior on size { NumberAnimation { duration: 100 } }


    Timer {
        id: timer
        interval: 2000
        onTriggered: parent.active = true
    }

    Rectangle {
        width: size * 1.06
        height: width
        radius: width * 0.5
        color: '#000'

        opacity: 0.3
        z: -1
        anchors.centerIn: parent
    }

    Text {
        id: text

        anchors.centerIn: parent

        font.pixelSize: parent.maxSize * 0.6
        font.family: globalFonts.sans
        font.capitalization: Font.AllUppercase
        font.weight: Font.Light
        color: "#eee"

        opacity: parent.active ? 1.0 : 0.0
        visible: opacity > 0.001

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
}
