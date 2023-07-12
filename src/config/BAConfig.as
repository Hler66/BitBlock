package config {
import flashx.textLayout.formats.Float;

public class BAConfig {
    /**小球的移动速度*/
    public static const RATE:Number = 5;
    /**小球自身高度或宽度一半*/
    public static const HALF_BALL:Number = 17.5;
    /**小球的自转速度*/
    public static const AUTOROTATION:Number = 20;
    /**小球弹射方向*/
    public static const DIRECTION_Arr:Array = ["up", "top", "bottom", "left", "right"]
    /**挡板移动速度*/
    public static const BAT_RATE:Number = 12;
    /**键盘对应的数值*/
    public static const KEY:Object = {
        LEFT:37,
        RIGHT:39,
        TAB:32
    }
    /**每次得分增加分数*/
    public static const SCORE = 1;

    public function BAConfig() {

    }
}
}
