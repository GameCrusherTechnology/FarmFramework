package view.component.progressbar{
	import flash.geom.Point;
	
	import starling.display.Shape;
	import starling.events.Event;

    public class TimerLine extends Shape {

        public static const TIMER_STOPPED:String = "timerStopped";
        public static const TIMER_WARNING:String = "timerWarning";
        private static const DIMMED_ALPHA:Number = 0.3;
        private static const LINE_THICKNESS:Number = 5;
        private static const COLOR_BLUE:uint = 37887;
        private static const COLOR_ORANGE:uint = 0xFF5700;
        private static const COLOR_HIGHLIGHT:uint = 0xFFFFFF;

        private var m_cPoints:Array;
        private var m_cPointProgress:Array;
        private var m_nColor:uint;
        private var m_nThickness:Number;
        private var m_nLineColor:uint = 37887;
        private var m_nSpentColor:uint = 37887;
        private var m_nSpentAlpha:Number = 0.8;

        public function TimerLine(_arg1:Number=5){
            this.m_nThickness = _arg1;
        }
        public static function pushShapeArc(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:Array):void{
            var _local8:Number = _arg4;
            var _local9:Number = ((_arg5 - _arg4) / _arg6);
            var _local10:uint;
            while (_local10 <= _arg6) {
                _arg7.push(new Point((_arg1 + (Math.sin(_local8) * _arg3)), (_arg2 + (Math.cos(_local8) * _arg3))));
                _local8 = (_local8 + _local9);
                _local10++;
            };
        }

        public function set lineColor(_arg1:uint):void{
            this.m_nLineColor = _arg1;
        }
        public function set spentColor(_arg1:uint):void{
            this.m_nSpentColor = _arg1;
        }
        public function set spentAlpha(_arg1:Number):void{
            this.m_nSpentAlpha = _arg1;
        }
        public function set shape(_arg1:Array):void{
            this.m_cPoints = _arg1;
            var _local2:Number = 0;
            var _local3:int;
            while (_local3 < (this.m_cPoints.length - 1)) {
                _local2 = (_local2 + this.pointDistance((this.m_cPoints[_local3] as Point), (this.m_cPoints[(_local3 + 1)] as Point)));
                _local3++;
            };
            var _local4:Number = 0;
            this.m_cPointProgress = new Array(this.m_cPoints.length);
            var _local5:int;
            while (_local5 < (this.m_cPoints.length - 1)) {
                this.m_cPointProgress[_local5] = (_local4 / _local2);
                _local4 = (_local4 + this.pointDistance((this.m_cPoints[_local5] as Point), (this.m_cPoints[(_local5 + 1)] as Point)));
                _local5++;
            };
            this.m_cPointProgress[(this.m_cPoints.length - 1)] = 1;
        }
        public function reset():void{
            this.m_nColor = this.m_nLineColor;
            this.updateGraphics(0);
        }
        public function update(s:Number):void{
			trace("timeline" + s);
            this.updateGraphics(s);
        }
        private function pointDistance(_arg1:Point, _arg2:Point):Number{
            var _local3:Number = (_arg2.x - _arg1.x);
            var _local4:Number = (_arg2.y - _arg1.y);
            return (Math.sqrt(((_local3 * _local3) + (_local4 * _local4))));
        }
        private function updateGraphics(_arg1:Number):void{
            var _local4:Point;
            var _local5:Point;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            if (this.m_cPoints == null){
                return;
            };
            graphics.clear();
            graphics.lineStyle(this.m_nThickness, this.m_nSpentColor, this.m_nSpentAlpha);
            graphics.moveTo(this.m_cPoints[0].x, this.m_cPoints[0].y);
            var _local2:Boolean;
            var _local3:int;
            while (_local3 < (this.m_cPoints.length - 1)) {
                _local4 = this.m_cPoints[_local3];
                _local5 = this.m_cPoints[(_local3 + 1)];
                if (((!(_local2)) && ((_arg1 < this.m_cPointProgress[(_local3 + 1)])))){
                    _local6 = (this.m_cPointProgress[(_local3 + 1)] - this.m_cPointProgress[_local3]);
                    _local7 = (_arg1 - this.m_cPointProgress[_local3]);
                    _local8 = (_local7 / _local6);
                    _local9 = (_local4.x + ((_local5.x - _local4.x) * _local8));
                    _local10 = (_local4.y + ((_local5.y - _local4.y) * _local8));
                    graphics.lineTo(_local9, _local10);
                    graphics.lineStyle(this.m_nThickness, this.m_nColor, 1);
                    _local2 = true;
                };
                graphics.lineTo(_local5.x, _local5.y);
                _local3++;
            };
        }

    }
}