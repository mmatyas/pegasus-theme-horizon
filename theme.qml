import QtQuick 2.12

FocusScope {
    id: root

    readonly property int mainWidth: Math.min(height / 9.0 * 16.0, width)
    readonly property int innerzoneWidth: mainWidth * 0.82
    readonly property int outerzoneWidth: width - innerzoneWidth

    function key_is_arrow(key) {
        return key == Qt.Key_Left
            || key == Qt.Key_Right
            || key == Qt.Key_Up
            || key == Qt.Key_Down;
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.1; color: "#30383f" }
            GradientStop { position: 0.8; color: "#08080f" }
        }
    }

    Item {
        id: paddingTop
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.1
    }

    ListView {
        id: collections

        readonly property var currentData: model.get(currentIndex)

        visible: false
        model: api.collections
        delegate: Item {}

        keyNavigationWraps: true
    }

    Item {
        id: header
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: paddingTop.bottom
        width: root.innerzoneWidth
        height: headerLabel.height * 1.5

        Text {
            id: headerLabel
            text: collections.currentData.name
            color: "#ccc"

            font.pixelSize: root.height * 0.055
            font.family: globalFonts.sans
            font.capitalization: Font.AllUppercase
            font.weight: Font.Light

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            elide: Text.ElideRight
        }
    }

    GridView {
        id: grid

        readonly property var currentData: model.get(currentIndex)
        readonly property real cellWidthRatio: 16 / 9
        readonly property int containedWidth: Math.floor((width - preferredHighlightBegin) / cellWidth) * cellWidth
        readonly property real cellBorder: cellHeight * 0.075

        anchors.top: header.bottom
        anchors.bottom: paddingBottom.top
        anchors.left: parent.left
        anchors.right: parent.right

        flow: GridView.FlowTopToBottom
        focus: true

        preferredHighlightBegin: outerzoneWidth / 2 - cellBorder
        preferredHighlightEnd: preferredHighlightBegin + containedWidth
        highlightRangeMode: GridView.StrictlyEnforceRange
        highlightMoveDuration: 160

        cellHeight: height / 3
        cellWidth: (cellHeight * 0.85 * cellWidthRatio) + cellBorder * 2

        model: collections.currentData.games
        delegate: GridDelegate {
            width: grid.cellWidth
            height: grid.cellHeight
            onClicked: GridView.view.currentIndex = index
            onEntered: {
                const coords = mapToItem(root, geometry.x, geometry.y);
                const geometry2 = Qt.rect(coords.x, coords.y, geometry.width, geometry.height);
                info.focus = true;
                info.open(geometry2);
            }
        }

        Keys.onPressed: {
            if (event.isAutoRepeat)
                return;

            if (key_is_arrow(event.key)) {
                scrollIndicator.start();
                return;
            }
            if (api.keys.isPrevPage(event)) {
                event.accepted = true;
                collections.decrementCurrentIndex();
                return;
            }
            if (api.keys.isNextPage(event)) {
                event.accepted = true;
                collections.incrementCurrentIndex();
                return;
            }
        }
        Keys.onReleased: {
            if (event.isAutoRepeat)
                return;

            if (key_is_arrow(event.key)) {
                scrollIndicator.stop();
                return;
            }
        }
    }

    ScrollIndicator {
        id: scrollIndicator

        maxSize: root.height * 0.11
        letter: grid.currentData.title.charAt(0)

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: grid.bottom
    }

    GameInfoScreen {
        id: info
        originData: grid.currentData
        onClosed: grid.focus = true
    }

    Item {
        id: paddingBottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.15
    }
}
