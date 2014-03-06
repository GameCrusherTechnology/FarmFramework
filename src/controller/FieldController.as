package controller{
    import flash.text.TextFormat;
    
    import gameconfig.Configrations;
    
    import starling.text.TextField;

    public class FieldController {

		public static function get  FONT_FAMILY():String
		{
			if(Configrations.Language== "zh-CN"){
				return "CN_FONT_0";
			}else if(Configrations.Language =="zh-TW"){
				return "TW_FONT_0";
			}else{
				return "myFonts_0";
			}
		}
		
        public static function createBaseField(_arg1:TextFormat):TextField{
			
            var _local2:TextField = new TextField(100,30,"",FONT_FAMILY);
            _local2.touchable = false;
            return (_local2);
        }
		
        public static function createSingleLineDynamicField(width:Number,height:Number,txt:String, _color:uint, _size:Number,_bold:Boolean = false):TextField{
			var _local4:TextField;
			var size:int = Math.round(_size*Configrations.ViewScale);
			_local4 = new TextField(width,height,txt,FONT_FAMILY,size,_color,_bold);
			_local4.touchable = false;
            return (_local4);
        }
		public static function createNoFontField(width:Number,height:Number,txt:String, _color:uint, _size:Number):TextField{
			var size:int = Math.round(_size*Configrations.ViewScale);
			var _local4:TextField = new TextField(width,height,txt);
			_local4.bold = true;
			_local4.touchable = false;
			_local4.color = _color;
			_local4.fontSize = size;
			return (_local4);
		}
		public static function createNameFontField(width:Number,height:Number,txt:String, _color:uint, _size:Number):TextField{
			var size:int = Math.round(_size*Configrations.ViewScale);
			var _local4:TextField = new TextField(width,height,txt);
			_local4.bold = true;
			_local4.touchable = false;
			_local4.color = _color;
			_local4.fontSize = size;
			_local4.fontName = "myFonts_0";
			return (_local4);
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