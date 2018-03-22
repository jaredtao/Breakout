import QtQuick 2.9
import QtQuick.Controls 2.0

Item {
    id: root
    //每一行的小块颜色
    property var colorList: [
        "red", "red", "green", "green", "blue", "blue", "yellow", "yellow", "white", "white"
    ]
    //每个小块的宽度
    readonly property int breakWidth: 100
    //每个小块的高度
    readonly property int breakHeight: 30
    //一行的小块数
    readonly property int breakCountPerLine: root.width / breakWidth
    //小块总数
    readonly property int breakCounts: breakCountPerLine * colorList.length
    //每个小块状态，是否可见
    property var breaksVisible: {
        var arr = new Array(breakCounts);
        for (var i = 0; i < breakCounts; i++) {
            arr[i] = true;
        }
        return arr
    }
    //活着的小块数量，为0则游戏结束
    property int aliveBreakCount: 0
    readonly property int moveSpeed: 20
    //小球移动的x方向
    property int xDir: moveSpeed - parseInt(Math.random() * moveSpeed * 2)
    //小球移动的y方向
    property int yDir: -moveSpeed


    Grid {
        spacing: 2
        width: parent.width
        columns: breakCountPerLine
        Repeater {
            model: breakCounts
            Rectangle {
                id: oneBreak
                visible: breaksVisible[index]
                objectName: "break"
                width: breakWidth
                height: breakHeight
                border.width: 1
                border.color: "gray"
                color: colorList[parseInt(index / breakCountPerLine)]

            }
        }
    }

    Image {
        id: ball
        source: "qrc:/Img/panda-48x48.png"
        Component.onCompleted: {
            x = root.width / 2 - width / 2
            y = controller.y - height
        }
        Behavior on x {NumberAnimation{ duration: 200}}
        Behavior on y {NumberAnimation{ duration: 200}}
    }
    Rectangle {
        id: controller
        objectName: "controller"
        width: 120
        height: 25
        radius: 10
        color: "lightgray"
        Component.onCompleted: {
            x = root.width / 2 - width / 2
            y = root.height - height
        }
        focus: true
        Keys.enabled: true
        Keys.onLeftPressed: {
            controller.x -= 10;
        }
        Keys.onRightPressed: {
            controller.x+= 10;;
        }
        Keys.onSpacePressed: {
            restart();
        }
    }
    Timer {
        id: gameTimer
        interval: 1000 / 60
        repeat: true
        running: false
        onTriggered: {
            nextStep();
        }
    }
    Fps {
        id: fptItem
        x: 10
    }
    function restart() {

        xDir = moveSpeed - parseInt(Math.random() * moveSpeed * 2)
        controller.x = root.width / 2 - controller.width / 2
        controller.y = root.height - controller.height
        ball.x = root.width / 2 - ball.width / 2
        ball.y = controller.y - ball.height
        aliveBreakCount = breakCounts

        console.log("restart")
        gameTimer.restart();
    }
    function nextStep() {
        console.log("nextStep")
        var nextX = ball.x + xDir;
        var nextY = ball.y + yDir;
        //检测撞小块

        //检测撞控制器


        //检测水平方向撞墙
        if (nextX <= 0 )  {
            ball.x = 0;
            xDir = -xDir;
        } else if (nextX + ball.width >= root.width) {
            ball.x = root.width - ball.width;
            xDir = -xDir;
        } else {
            ball.x = nextX;
        }

        //检测竖直方向撞墙
        if (nextY <= 0) {
            ball.y = 0
            yDir = -yDir;
        } else if (nextY + ball.height >= root.height) {
            //game over
            return gameOver();
        } else {
            ball.y = nextY;
        }
    }
    function gameOver() {
        gameTimer.stop();
        console.log("game over")
    }
}
