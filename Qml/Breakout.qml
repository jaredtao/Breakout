import QtQuick 2.9
import QtQuick.Controls 2.0

Item {
    id: root
    //每一行的小块颜色
    property var colorList: [
        "red", "green", "blue", "yellow", "white"
    ]
    //每个小块的宽度
    readonly property int breakWidth: 100
    //每个小块的高度
    readonly property int breakHeight: 30
    //一行的小块数
    readonly property int breakCountPerLine: root.width / breakWidth
    //小块总数
    readonly property int breakCounts: breakCountPerLine * colorList.length
    readonly property int breakMargins: 2
    //活着的小块数量，为0则游戏结束
    property int aliveBreakCount: 0
    readonly property int moveSpeed: 20
    //小球移动的x方向
    property int xDir: moveSpeed - parseInt(Math.random() * moveSpeed * 2)
    //小球移动的y方向
    property int yDir: -moveSpeed

    property alias isRunning: gameTimer.running

    property bool win: false
    Item {
        id: grid
        objectName: "grid"
        width: parent.width
        height: breakHeight * (colorList.length + breakMargins)
        Component{
            id: breakConponent
            Rectangle {
                id: oneBreak
                objectName: "break"
                width: breakWidth
                height: breakHeight
                border.width: 1
                border.color: "gray"
            }
        }
        Component.onCompleted: {
            init();
        }
        //创建小块
        function init() {
            for (var i = 0; i < breakCountPerLine; i++) {
                for (var j = 0; j < colorList.length; j++) {
                    var breakOne = breakConponent.createObject(grid);
                    breakOne.x = i * (breakWidth + breakMargins);
                    breakOne.y = j * (breakHeight + breakMargins);
                    breakOne.color = colorList[j];
                }
            }
        }
        //清空所有小块
        function clear() {
            var breaks = grid.children;
            for (var i = 0; i < breaks.length; i++) {
                breaks[i].destroy();
            }
        }
    }

    Ball {
        id: ball
        source: "qrc:/Img/panda-48x48.png"
        Component.onCompleted: {
            x = root.width / 2 - width / 2
            y = controller.y - height
        } 
        running: isRunning
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
            y = root.height - height - 5
        }
        focus: true
        Keys.enabled: true
        Keys.onLeftPressed: {
            if (isRunning && controller.x - 10 >= 0) {
                controller.x -= 10;
            }
        }
        Keys.onRightPressed: {
            if (isRunning && controller.x + 10 + controller.width <= root.width) {
                controller.x+= 10;;
            }
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
        grid.clear();
        grid.init();
        xDir = moveSpeed - parseInt(Math.random() * moveSpeed * 2)
        controller.x = root.width / 2 - controller.width / 2
        controller.y = root.height - controller.height - 5
        ball.x = root.width / 2 - ball.width / 2
        ball.y = controller.y - ball.height
        aliveBreakCount = breakCounts
        win = false;
        console.log("restart")
        gameTimer.restart();
    }
    function gameOver() {
        gameTimer.stop();
        console.log("game over")
        return 0;
    }
    function gameWin() {
        gameTimer.stop();
        win = true;
        console.log("win");
    }
    //检测2个矩形是否碰撞
    function checkCollide(x1, y1, w1, h1, x2, y2, w2, h2) {
        if (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2) {
            return true;
        } else {
            return false;
        }
    }
    function nextStep() {
        var nextX = ball.x + xDir;
        var nextY = ball.y + yDir;
        var collideWall = false;
        if (nextX < 0) { //检查是否碰撞左墙
            xDir = -xDir;
            ball.x = 0;
            collideWall = true;
        } else if (nextX + ball.width > width) { //检查是否碰撞右墙
            xDir = -xDir;
            ball.x = width - ball.width;
            collideWall = true;
        }

        if ( nextY < 0 ) { //检查是否碰撞顶
            yDir = -yDir;
            ball.y = 0;
            collideWall = true;
        } else if (nextY + ball.height > height) { //检查是否碰撞底部
            return gameOver();
        }
        //已经撞墙，不用再考虑其它的碰撞
        if (collideWall) {
            return;
        }
        //检测是否碰撞小块
        var oneBreak = grid.childAt(nextX, nextY);
        if (oneBreak) {
            if (checkCollide(nextX, nextY, ball.width, ball.height,
                             oneBreak.x, oneBreak.y, oneBreak.width, oneBreak.height)) {
                yDir = - yDir;
                oneBreak.visible = false;
                aliveBreakCount--;
                ball.x = nextX;
                ball.y = nextY;
                if (aliveBreakCount === 0) {
                    return gameWin();
                }
                return ;
            }
        }
        if (checkCollide(nextX, nextY, ball.width, ball.height,
                         controller.x, controller.y, controller.width, controller.height)) {//检测是否碰撞控制器
            yDir = - yDir;
            if (ball.x < controller.x) {
                ball.x = controller.x - ball.width;
            } else {
                ball.x = controller.x + controller.width;
            }
            ball.y = controller.y - ball.height;
        } else {
            ball.x = nextX;
            ball.y = nextY;
        }
    }
}
