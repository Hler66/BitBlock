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

import config.BAConfig


public class BitBlock extends MovieClip {

    private var ball:Ball;
    private var bat:Bat;
    private var blockArr:Array = new Array();
    private var text:TextField = new TextField();
    private var scoreTxt:TextField = new TextField();
    private var score:Number = 0;

    /** 舞台高度一半 */
    public static var halfStageH:Number;
    /** 舞台宽度一半 */
    public static var halfStageW:Number;
    /** 挡板宽度一半 */
    public static var halfBatW:Number;

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

        halfStageW = stage.stageWidth / 2;
        halfStageH = stage.stageHeight / 2;

        bat = new Bat();
        halfBatW = bat.width / 2
        bat.x = halfStageW - halfBatW;
        bat.y = halfStageH * 2 - 100 - 50;
        addChild(bat)

        scoreTxt.text = "得分：" + String(score)
        scoreTxt.x = halfStageW - halfBatW;
        scoreTxt.y = halfStageH * 2 - 100;
        scoreTxt.textColor = 0xFA0000;
        scoreTxt.scaleY = 2;
        scoreTxt.scaleX = 2;
        addChild(scoreTxt)

        ball = new Ball();
        ball.x = halfStageW;
        ball.y = halfStageH * 2 - 115 - 50;
        addChild(ball)

        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown)
    }

    private function onKDown(e:KeyboardEvent) {
        if (e.keyCode == BAConfig.KEY.TAB) {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKDown)
            addEventListener(Event.ENTER_FRAME, Up)
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onSlideByKeyboard)
        }
    }

    private function Up(e:Event) {
        ball.y -= BAConfig.RATE;
        ball.rotation += BAConfig.AUTOROTATION;
        hit(BAConfig.DIRECTION_Arr[0])
    }

//    右墙壁f
    private function moveBall(e:Event):void {
        if (ball.x + BAConfig.HALF_BALL >= halfStageW * 2) {
            removeEventListener(Event.ENTER_FRAME, moveBall)
            addEventListener(Event.ENTER_FRAME, moveBallBottom)
        } else if (ball.y + BAConfig.HALF_BALL >= halfStageH * 2) {
            /**
             * !!!!！！！！这里是game over的点
             */
            text.text = "通关失败！"
            text.textColor = 0xFA0000
            text.scaleX = 2;
            text.scaleY = 2;
            text.x = halfStageW - text.textWidth;
            text.y = halfStageH - text.textHeight;
            addChild(text)
        }
        ball.x += BAConfig.RATE;
        ball.y += BAConfig.RATE;
        ball.rotation += BAConfig.AUTOROTATION
        hit(BAConfig.DIRECTION_Arr[4])
        hitBat(BAConfig.DIRECTION_Arr[4])
    }

//    下墙壁
    private function moveBallBottom(e:Event) {
        /**
         *
         * !!! 这里是计算角度的点，现在斜率是固定的
         */
        ball.x -= BAConfig.RATE
        ball.y += BAConfig.RATE;
        /**
         * !!!!！！！！这里是game over的点
         */
        if (ball.y + BAConfig.HALF_BALL >= halfStageH * 2) {
            text.text = "通关失败！"
            text.x = halfStageW - text.textWidth;
            text.y = halfStageH - text.textHeight;
            text.scaleX = 2;
            text.scaleY = 2;
            text.textColor = 0xFA0000
            addChild(text)
        } else if (ball.x - 18 <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallBottom);
            addEventListener(Event.ENTER_FRAME, moveBall)
        }
        ball.rotation += BAConfig.AUTOROTATION
        hit(BAConfig.DIRECTION_Arr[2])
        hitBat(BAConfig.DIRECTION_Arr[2])
    }

//    左墙壁
    private function moveBallLeft(e:Event) {
        /**
         * !!! 这里是计算角度的点，现在斜率是固定的,x轴和y轴的变化速度
         */
        ball.x -= BAConfig.RATE;
        ball.y -= BAConfig.RATE;
        if (ball.x - BAConfig.HALF_BALL <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallLeft)
            addEventListener(Event.ENTER_FRAME, moveBallTop)
        } else if (ball.y - BAConfig.HALF_BALL <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallLeft)
            addEventListener(Event.ENTER_FRAME, moveBallBottom)
        }
        ball.rotation += BAConfig.AUTOROTATION
        hit(BAConfig.DIRECTION_Arr[3])
        hitBat(BAConfig.DIRECTION_Arr[3])
    }

//    上墙壁
    private function moveBallTop(e:Event) {
        /**
         * !!! 这里是计算角度的点，现在斜率是固定的,x轴和y轴的变化速度
         */
        ball.y -= BAConfig.RATE;
        ball.x += BAConfig.RATE;
        if (ball.y - BAConfig.HALF_BALL <= 0) {
            removeEventListener(Event.ENTER_FRAME, moveBallTop)
            addEventListener(Event.ENTER_FRAME, moveBall)
        } else if (ball.x + BAConfig.HALF_BALL >= halfStageW * 2) {
            removeEventListener(Event.ENTER_FRAME, moveBallTop)
            addEventListener(Event.ENTER_FRAME, moveBallLeft)
        }
        ball.rotation += BAConfig.AUTOROTATION
        hit(BAConfig.DIRECTION_Arr[1])
        hitBat(BAConfig.DIRECTION_Arr[1])
    }

//    滑动条
    private function hitBat(s:String) {
        var batHit:BitmapData = getHitArea(bat);
        var ballHit:BitmapData = getHitArea(ball)
        if (ballHit.hitTest(getHitAreaPoint(ball), 40, batHit, getHitAreaPoint(bat), 40)) {
            if (s == BAConfig.DIRECTION_Arr[2]) {
                removeEventListener(Event.ENTER_FRAME, moveBallBottom)
                addEventListener(Event.ENTER_FRAME, moveBallLeft)
            } else if (s == BAConfig.DIRECTION_Arr[4]) {
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
                score += BAConfig.SCORE;
                scoreTxt.text = "得分：" + String(score)
                if (blockArr.length == 0) {
                    ball.visible = false;
                    removeEventListener(Event.ENTER_FRAME, moveBall)
                    removeEventListener(Event.ENTER_FRAME, moveBallBottom)
                    removeEventListener(Event.ENTER_FRAME, moveBallLeft)
                    removeEventListener(Event.ENTER_FRAME, moveBallTop)
                    var pass:TextField = new TextField();
                    pass.text = "通关成功！"
                    pass.x = halfStageW - pass.textWidth;
                    pass.y = halfStageH - pass.textHeight;
                    pass.textColor = 0x009900
                    pass.scaleX = 2;
                    pass.scaleY = 2;
                    addChild(pass);
                    return;
                }


                if (s === BAConfig.DIRECTION_Arr[3]) {
                    removeEventListener(Event.ENTER_FRAME, moveBallLeft)
                    addEventListener(Event.ENTER_FRAME, moveBallBottom)
                } else if (s === BAConfig.DIRECTION_Arr[1]) {
                    removeEventListener(Event.ENTER_FRAME, moveBallTop)
                    addEventListener(Event.ENTER_FRAME, moveBall)
                } else if (s == BAConfig.DIRECTION_Arr[0]) {
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
        if (e.keyCode == BAConfig.KEY.LEFT) {
            bat.x -= BAConfig.BAT_RATE;
        } else if (e.keyCode == BAConfig.KEY.RIGHT) {
            bat.x += BAConfig.BAT_RATE;
        }
        if (bat.x + halfBatW * 2 >= halfStageH * 2) {
            bat.x = halfStageH * 2 - halfBatW * 2
        } else if (bat.x < 0) {
            bat.x = 0;
        }
    }
}

}
