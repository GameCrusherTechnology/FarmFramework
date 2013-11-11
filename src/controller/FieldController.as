package controller{
    import flash.system.Capabilities;
    import flash.text.TextFormat;
    
    import gameconfig.Configrations;
    
    import starling.text.TextField;
    import starling.utils.HAlign;

    public class FieldController {

		public static const FONT_FAMILY:String = "myFonts_0";
		
        public static function createBaseField(_arg1:TextFormat):TextField{
			
            var _local2:TextField = new TextField(100,30,"",FONT_FAMILY);
            _local2.touchable = false;
            return (_local2);
        }
		
		private static function getFontName():String
		{
			if(Capabilities.language == "zh-CN"||Capabilities.language =="zh-TW"){
				return null;
			}else{
				return FONT_FAMILY;
			}
		}
		private static function creatTextformat(font:String = null, size:Number =20, color:Object = null, bold:Object = null, italic:Object = null, underline:Object = null, url:String = null, target:String = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null, indent:Object = null, leading:Object = null):TextFormat
		{
			var _font:String = font;
			if(Capabilities.language == "zh-CN"||Capabilities.language =="zh-TW"){
				_font =  null;
			}
			var scale:Number = Math.min(Configrations.ViewPortWidth/1280,Configrations.ViewPortHeight/760);
			var _size:Number = size*scale;
			return new TextFormat(_font,_size,color,bold,italic,underline,url,target,align,leftMargin,rightMargin,indent,leading);
		}
        public static function createSingleLineDynamicField(width:Number,height:Number,txt:String, _color:uint, _size:Number,_bold:Boolean = false):TextField{
			
            var _local4:TextField = new TextField(width,height,txt,FONT_FAMILY,_size,_color,_bold);
            return (_local4);
        }
		public static function createNoFontField(width:Number,height:Number,txt:String, _color:uint, _size:Number):TextField{
			
			var _local4:TextField = new TextField(width,height,txt);
			_local4.bold = true;
			_local4.touchable = false;
			_local4.color = _color;
			_local4.fontSize = _size;
			return (_local4);
		}
        public static function createSingleLineStaticField(_width:int, _text:String, _color:uint, _size:Number, _align:String="left"):TextField{
            var _local6:TextField = createBaseField(creatTextformat(FONT_FAMILY, _size, _color, true, null, null, null, null, _align));
            _local6.width = _width;
            _local6.text = _text;
//            _local6.height = (_local6.height + 5);
            return (_local6);
        }
        public static function createMultiLineStaticField(_arg1:int, _arg2:String, _arg3:uint, _arg4:Number, _arg5:String="left", _arg6:Object=null):TextField{
            var _local7:TextField = createBaseField(creatTextformat(FONT_FAMILY, _arg4, _arg3, true, null, null, null, null, _arg5, null, null, null, _arg6));
            _local7.autoSize = _arg5;
            _local7.width = _arg1;
            _local7.text = _arg2;
            return (_local7);
        }
//        public static function createGoldenTextField(_arg1:TextField, _arg2:Number=3):GradientTextField{
//            var _local3:GradientTextField = new GradientTextField(_arg1, [0xFFFF00, 15501315], [(110 + 20), ((0xFF - 110) + 20)]);
//            _local3.filters = [new GlowFilter(16773227, 1, _arg2, _arg2, 2, 1, true), new DropShadowFilter(2, 90, 0, 0.75, 4, 4, 1)];
//            return (_local3);
//        }
//        public static function createSilverTextField(_arg1:TextField, _arg2:Number=3):GradientTextField{
//            var _local3:GradientTextField = new GradientTextField(_arg1, [0xFFFFFF, 0xA9A9A9, 0xBABABA], [(110 + 20), ((0xFF - 110) + 20), 0xFF]);
//            _local3.filters = [new GlowFilter(0xFFFFFF, 1, _arg2, _arg2, 2, 1, true), new DropShadowFilter(2, 90, 0, 0.75, 4, 4, 1)];
//            return (_local3);
//        }

    }
}