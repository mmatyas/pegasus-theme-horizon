import QtQuick 2.0

FocusScope {
    id: root

    readonly property int mainWidth: parent.height / 9.0 * 16.0
    readonly property int innerzoneWidth: mainWidth * 0.85
    readonly property int outerzoneWidth: parent.width - innerzoneWidth

    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Item {
        id: paddingTop
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.075
    }

    ListView {
        id: collections

        readonly property var currentData: api.collections.get(currentIndex)

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
        height: headerLabel.height * 2

        Text {
            id: headerLabel
            text: collections.currentData.name
            color: "#ccc"

            font.pixelSize: root.height * 0.055
            font.family: globalFonts.sans
            font.capitalization: Font.AllUppercase

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
        }
    }

    GridView {
        id: grid

        readonly property real cellWidthRatio: 16 / 9

        anchors.top: header.bottom
        anchors.bottom: paddingBottom.top
        anchors.left: parent.left
        anchors.right: parent.right

        flow: GridView.FlowTopToBottom
        focus: true

        preferredHighlightBegin: outerzoneWidth / 2 - cellWidth * 0.05
        preferredHighlightEnd: width - preferredHighlightBegin
        highlightRangeMode: GridView.StrictlyEnforceRange

        cellHeight: height / 3
        cellWidth: cellHeight * cellWidthRatio

        model: collections.currentData.games
        delegate: GridDelegate {
            width: grid.cellWidth
            height: grid.cellHeight
            onClicked: GridView.view.currentIndex = index
        }

        Keys.onPressed: {
            if (event.isAutoRepeat)
                return;

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
    }

    Item {
        id: paddingBottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.15
    }
}
