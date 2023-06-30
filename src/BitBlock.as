package {

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.*;
import flash.events.KeyboardEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;

public class BitBlock extends MovieClip {

    private var ball:Ball;
    private var bat:Bat;
    private var blockArr:Array = new Array();
    private static const RATE:Number = 5;
    private var text:TextField = new TextField();
    private var scoreTxt:TextField = new TextField();
    private var score:Number = 0;

    public function BitBlock() {
        // constructor code
        for (var j = 0; j < 6; j++) {
            for (var i = 0; i < 7; i++) {
                var stone_orange = new StoneOrange();
                stone_orange.x = 55 * i;
                stone_orange.y = 23 * j;
                stage.addChild(stone_orange);
                blockArr.push(stone_orange)
            }
        }

        bat = new Bat();
        bat.x = stage.stageWidth / 2 - bat.width / 2;
        bat.y = stage.stageHeight - 100 - 50;
        addChild(bat)

        scoreTxt.text = "得分：" + String(score)
        scoreTxt.x = stage.stageWidth / 2 - bat.width / 2;
        scoreTxt.y = stage.stageHeight - 100;
        scoreTxt.textColor = 0xFA0000;
        scoreTxt.scaleY = 2;
        scoreTxt.scaleX = 2;
        addChild(scoreTxt)

        ball = new Ball();
        ball.x = stage.stageWidth / 2;
        ball.y = stage.stageHeight - 115 - 50

        addChild(ball)



        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown)

    }

    private function onKDown(e:KeyboardEvent) {
        if (e.keyCode == 32) {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKDown)
            addEventListener(Event.ENTER_FRAME, Up)
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onSlideByKeyboard)
        }
    }

    private function Up(e:Event) {
        ball.y -= 5;
        ball.rotation += 20;
        hit("up")
    }

//    右墙壁f
    private function moveBall(e:Event):void {
        if (ball.x + 17.5 >= 395) {
            removeEventListener(Event.ENTER_FRAME, moveBall)
            addEventListener(Event.ENTER_FRAME, moveBallBottom)
        } else if (ball.y + 17.5 >= 500) {
            /**
             * !!!!！！！！这里是game over的点
             */
            text.text = "通关失败！"
            text.textColor = 0xFA0000
            text.scaleX = 2;
            text.scaleY = 2;
            text.x = stage.stageWidth / 2 - text.textWidth;
            text.y = stage.stageHeight / 2 - text.textHeight;
            addChild(text)
        }
        ball.x += RATE;
        ball.y += RATE;
        ball.rotation += 20
        hit("right")
        hitBat("right")
    }

//    下墙壁
    private function moveBallBottom(e:Event) {
        /**
         *
         * !!! 这里是计算角度的点，现在斜率是固定的
         */
        ball.x -= RATE
        ball.y += RATE;
        /**
         * !!!!！！！！这里是game over的点
         */
        if (ball.y + 17.5 >= 500) {
            text.text = "通关失败！"
            text.x = stage.stageWidth / 2 - text.textWidth;
            text.y = stage.stageHeight / 2 - text.textHeight;
            text.scaleX = 2;
            text.scaleY = 2;
            text.textColor = 0xFA0000
            addChild(text)
        } else if (ball.x - 18 <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallBottom);
            addEventListener(Event.ENTER_FRAME, moveBall)
        }
        ball.rotation += 20
        hit("bottom")
        hitBat("bottom")
    }

//    左墙壁
    private function moveBallLeft(e:Event) {
        /**
         *
         * !!! 这里是计算角度的点，现在斜率是固定的
         */
        ball.x -= RATE;
        ball.y -= RATE;
        if (ball.x - 17.5 <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallLeft)
            addEventListener(Event.ENTER_FRAME, moveBallTop)
        } else if (ball.y - 17.5 <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallLeft)
            addEventListener(Event.ENTER_FRAME, moveBallBottom)
        }
        ball.rotation += 20
        hit("left")
        hitBat("left")
    }

//    上墙壁
    private function moveBallTop(e:Event) {
        /**
         *
         * !!! 这里是计算角度的点，现在斜率是固定的
         */
        ball.y -= RATE;
        ball.x += RATE;
        if (ball.y - 17.5 <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallTop)
            addEventListener(Event.ENTER_FRAME, moveBall)
        } else if (ball.x + 17.5 >= 395) {
            removeEventListener(Event.ENTER_FRAME, moveBallTop)
            addEventListener(Event.ENTER_FRAME, moveBallLeft)
        }
        ball.rotation += 20
        hit("top")
        hitBat("top")
    }

//    滑动条
    private function hitBat(s:String) {
        var batHit:BitmapData = getHitArea(bat);
        var ballHit:BitmapData = getHitArea(ball)
        if (ballHit.hitTest(getHitAreaPoint(ball), 40, batHit, getHitAreaPoint(bat), 40)) {
            if (s == "bottom") {
                removeEventListener(Event.ENTER_FRAME, moveBallBottom)
                addEventListener(Event.ENTER_FRAME, moveBallLeft)
            } else if (s == "right") {
                removeEventListener(Event.ENTER_FRAME, moveBall)
                addEventListener(Event.ENTER_FRAME, moveBallTop)
            }
        }
    }

//    砖块
    private function hit(s:String) {
        for (var i = 0; i < blockArr.length; i++) {
//            像素位图
            var ballHit:BitmapData = getHitArea(ball);
            var blockHit:BitmapData = getHitArea(blockArr[i]);
            if (ballHit.hitTest(getHitAreaPoint(ball), 40, blockHit, getHitAreaPoint(blockArr[i]), 40)) {
                blockArr[i].visible = false
                blockArr.splice(i, 1)
                score += 1;
                scoreTxt.text = "得分：" + String(score)
                if (blockArr.length == 0) {
                    ball.visible = false;
                    removeEventListener(Event.ENTER_FRAME, moveBall)
                    removeEventListener(Event.ENTER_FRAME, moveBallBottom)
                    removeEventListener(Event.ENTER_FRAME, moveBallLeft)
                    removeEventListener(Event.ENTER_FRAME, moveBallTop)
                    var pass:TextField = new TextField();
                    pass.text = "通关成功！"
                    pass.x = stage.stageWidth / 2 - pass.textWidth;
                    pass.y = stage.stageHeight / 2 - pass.textHeight;
                    pass.textColor = 0x009900
                    pass.scaleX = 2;
                    pass.scaleY = 2;
                    addChild(pass);
                    return;
                }


                if (s === "left") {
                    removeEventListener(Event.ENTER_FRAME, moveBallLeft)
                    addEventListener(Event.ENTER_FRAME, moveBallBottom)
                } else if (s === "top") {
                    removeEventListener(Event.ENTER_FRAME, moveBallTop)
                    addEventListener(Event.ENTER_FRAME, moveBall)
                } else if (s == "up") {
                    removeEventListener(Event.ENTER_FRAME, Up)
                    addEventListener(Event.ENTER_FRAME, moveBall)
                }
            }
        }
    }

    private function getHitArea(r:DisplayObject):BitmapData {
        var rect:Rectangle = r.getBounds(r.parent);
        var bmpData:BitmapData = new BitmapData(r.width, r.height, true, 0);
        var matrix:Matrix = r.transform.matrix;
        matrix.tx -= rect.left;
        matrix.ty -= rect.top;
        bmpData.draw(r, matrix);
        return bmpData;
    }

    private function getHitAreaPoint(r:DisplayObject):Point {
        var rect:Rectangle = r.getBounds(r.parent);
        return rect.topLeft;
    }

    private function onSlideByKeyboard(e:KeyboardEvent) {
//        左键
        if (e.keyCode == 37) {
            bat.x -= 10;
        } else if (e.keyCode == 39) {
            bat.x += 10;
        }
        if (bat.x + bat.width >= stage.stageWidth) {
            bat.x = stage.stageWidth - bat.width
        } else if (bat.x < 0) {
            bat.x = 0;
        }
    }
}

}
