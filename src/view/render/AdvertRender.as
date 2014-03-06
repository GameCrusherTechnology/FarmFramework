package view.render
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class AdvertRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var mes:String;
		public function AdvertRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				mes = String(value);
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				configLayout();
			}
		}
		private var renderwidth:Number;
		private function configLayout():void
		{
			renderwidth = width;
//			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var c:Sprite;
			var deep:Number = 0;
			for each(var i:String in GameController.instance.VersionMes){
				c = creatRender(i);
				container.addChild(c);
				c.y = deep;
				deep += (c.height + 20*scale);
			}
			
		}
		
		private function creatRender(dataStr:String):Sprite
		{
			var sContainer:Sprite = new Sprite;
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = renderwidth;
			sContainer.addChild(panelSkin);
			
			var icon:Image = new Image(Game.assets.getTexture("expIcon"));
			icon.width = icon.height = 40*scale;
			sContainer.addChild(icon);
			icon.x = 20*scale;
			icon.y = 10*scale;
			
			var numbertext:TextField = FieldController.createSingleLineDynamicField(icon.width,icon.height,dataStr,0x000000,25,true);
			sContainer.addChild(numbertext);
			numbertext.x = icon.x;
			numbertext.y = icon.y;
			
			
			var text:TextField = FieldController.createSingleLineDynamicField(renderwidth - 30*scale-icon.width,500,LanguageController.getInstance().getString("versionTip"+dataStr),0x000000,25,true);
			text.autoSize = TextFieldAutoSize.VERTICAL;
			sContainer.addChild(text);
			text.x = icon.x+icon.width+5*scale;
			text.y = 10*scale;
			
			panelSkin.height = Math.max(icon.height,text.height)+20*scale;
			return sContainer;
		}
	}
}


