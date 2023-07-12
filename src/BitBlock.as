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

import flash.utils.setTimeout;

import imc.Ball;

import imc.Bat;
import imc.Fast;
import imc.Long;
import imc.Short;
import imc.Slow;


public class BitBlock extends MovieClip {

    private var ball:Ball;
    private var bat:Bat;
    private var blockArr:Array = new Array();
    private var daoArr:Array = new Array();
    private var text:TextField = new TextField();
    private var scoreTxt:TextField = new TextField();
    private var score:Number = 0;
    private var rate:Number = BAConfig.RATE;


    /** 舞台高度一半 */
    public static var halfStageH:Number;
    /** 舞台宽度一半 */
    public static var halfStageW:Number;
    /** 挡板宽度一半 */
    public static var halfBatW:Number;
    /**初始化加载游戏*/
    public function BitBlock() {
        // constructor code
        for (var j = 0; j < 6; j++) {
            for (var i = 0; i < 7; i++) {
                var stone_orange = new StoneOrange();
                stone_orange.x = 55 * i;
                stone_orange.y = 23 * j;
                stage.addChild(stone_orange);
                blockArr.push(stone_orange);
            }
        }
        genDao();

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
    /**随机产生道具*/
    private function genDao() {
        for (var i = 0; i < 4; i++) {
            var i1 = Math.floor(Math.random() * (5 - 0 + 1)) + 0;
            var j1 = Math.floor(Math.random() * (6 - 0 + 1)) + 0;
            var ia = 7 * j1 + i1;
            var fast = new Fast();
            fast.width = 24;
            fast.height = 24;
            if (blockArr[ia]) {
                blockArr[ia].isDao = true;
            }
            daoArr[ia] = fast
            fast.x = 55 * i1 + 32 - fast.width / 2;
            fast.y = 23 * j1 + 32 - fast.height / 2;
        }
        for (var ii = 0; ii < 5; ii++) {
            var i11 = Math.floor(Math.random() * (5 - 0 + 1)) + 0;
            var j11 = Math.floor(Math.random() * (6 - 0 + 1)) + 0;
            var ia1 = 7 * j11 + i11;
            var slow = new Slow();
            slow.width = 24;
            slow.height = 24;
            if (blockArr[ia1]) {
                blockArr[ia1].isDao = true;
            }
            daoArr[ia1] = slow
            slow.x = 55 * i11 + 32 - slow.width / 2;
            slow.y = 23 * j11 + 32 - slow.height / 2;
        }
        for (var i3 = 0; i3 < 4; i3++) {
            var i21 = Math.floor(Math.random() * (5 - 0 + 1)) + 0;
            var j21 = Math.floor(Math.random() * (6 - 0 + 1)) + 0;
            var ia2 = 7 * j21 + i21;
            var short = new Short();
            short.width = 24;
            short.height = 24;
            if (blockArr[ia2]) {
                blockArr[ia2].isDao = true;
            }
            daoArr[ia2] = short
            short.x = 55 * i21 + 32 - short.width / 2;
            short.y = 23 * j21 + 32 - short.height / 2;
        }
        for (var i4 = 0; i4 < 2; i4++) {
            var i31 = Math.floor(Math.random() * (5 - 0 + 1)) + 0;
            var j31 = Math.floor(Math.random() * (6 - 0 + 1)) + 0;
            var ia3 = 7 * j31 + i31;
            var long = new Long();
            long.width = 24;
            long.height = 24;
            if (blockArr[ia3]) {
                blockArr[ia3].isDao = true;
            }
            daoArr[ia3] = long
            daoArr[ia3] = long
            long.x = 55 * i31 + 32 - long.width / 2;
            long.y = 23 * j31 + 32 - long.height / 2;
        }
    }
    /**开始游戏*/
    private function onKDown(e:KeyboardEvent) {
        if (e.keyCode == BAConfig.KEY.TAB) {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKDown)
            addEventListener(Event.ENTER_FRAME, Up)
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onSlideByKeyboard)
        }
    }
    /**小球初始运动方向*/
    private function Up(e:Event) {
        ball.y -= rate;
        ball.rotation += BAConfig.AUTOROTATION;
        hit(BAConfig.DIRECTION_Arr[0])
    }

    /**道具掉落效果*/
    private function fallNP(d) {
        addEventListener(Event.ENTER_FRAME, function () {
            d.y += BAConfig.RATE + 4;
            var batHit:BitmapData = getHitArea(bat);
            var dHit:BitmapData = getHitArea(d);
            if (batHit.hitTest(getHitAreaPoint(bat), 40, dHit, getHitAreaPoint(d), 40)) {
                stage.removeChild(d)
                if (d is Fast) {
                    rate = 1.5 * BAConfig.RATE;
                    setTimeout(function (){
                        rate = BAConfig.RATE;
                    },6000)
                } else if (d is Slow) {
                    rate = 0.5 * BAConfig.RATE;
                    setTimeout(function (){
                        rate = BAConfig.RATE;
                    },6000)
                } else if (d is Short) {
                    // 有bug
                    bat.width = bat.width / 2;
                    setTimeout(function (){
                        bat.width = bat.width * 2;
                    },6000)
                } else {
                    bat.width = bat.width * 2;
                    setTimeout(function (){
                        bat.width = bat.width / 2;
                    },6000)
                }
            }
        })
    }

    /**撞击右墙壁*/
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
        ball.x += rate;
        ball.y += rate;
        ball.rotation += BAConfig.AUTOROTATION
        hit(BAConfig.DIRECTION_Arr[4])
        hitBat(BAConfig.DIRECTION_Arr[4])
    }

    /**撞击下墙壁*/
    private function moveBallBottom(e:Event) {
        /**
         *
         * !!! 这里是计算角度的点，现在斜率是固定的
         */
        ball.x -= rate
        ball.y += rate;
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

    /**撞击左墙壁*/
    private function moveBallLeft(e:Event) {
        /**
         * !!! 这里是计算角度的点，现在斜率是固定的,x轴和y轴的变化速度
         */
        ball.x -= rate;
        ball.y -= rate;
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

    /**撞击上墙壁*/
    private function moveBallTop(e:Event) {
        /**
         * !!! 这里是计算角度的点，现在斜率是固定的,x轴和y轴的变化速度
         */
        ball.y -= rate;
        ball.x += rate;
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

    /**撞击挡板*/
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

    /**撞击砖块*/
    private function hit(s:String) {
        for (var i = 0; i < blockArr.length; i++) {
            // 像素碰撞
            var ballHit:BitmapData = getHitArea(ball);
            var blockHit:BitmapData = getHitArea(blockArr[i]);
            if (ballHit.hitTest(getHitAreaPoint(ball), 40, blockHit, getHitAreaPoint(blockArr[i]), 40)) {
                blockArr[i].visible = false
                if (blockArr[i].isDao) {
                    stage.addChild(daoArr[i])
                    fallNP(daoArr[i])
                }
                blockArr.splice(i, 1)
                daoArr.splice(i, 1)
                score += BAConfig.SCORE;
                scoreTxt.text = "得分：" + String(score)

                /**最后一个砖块*/
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
    /**滑动挡板*/
    private function onSlideByKeyboard(e:KeyboardEvent) {
//        左键
        if (e.keyCode == BAConfig.KEY.LEFT) {
            bat.x -= BAConfig.BAT_RATE;

        } else if (e.keyCode == BAConfig.KEY.RIGHT) {
            bat.x += BAConfig.BAT_RATE;
        }
        if (bat.x + halfBatW * 2 >= halfStageW * 2) {
            bat.x = halfStageW * 2 - halfBatW * 2
        } else if (bat.x < 0) {
            bat.x = 0;
        }
    }
}

}
