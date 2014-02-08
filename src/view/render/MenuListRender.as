package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.VAlign;
	
	public class MenuListRender extends DefaultListItemRenderer
	{
		public function MenuListRender()
		{
			super();
		}
		
		private var container:Sprite;
		private var name:String;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				name = value.event;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				configLayout();
			}
		}
		private function configLayout():void
		{
			container = new Sprite();
			var renderWidth:Number =  width;
			var renderHeight:Number = height;
			addChild(container);
			
			var icon:Image = new Image(Game.assets.getTexture(name +"Icon"));
			icon.width = icon.height = Math.min(renderHeight*0.8,renderWidth*0.8);
			icon.x = renderWidth/2 - icon.width/2;
			icon.y = renderHeight/2 - icon.height/2 - 10;
			container.addChild(icon);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(300,renderHeight,LanguageController.getInstance().getString(name),0x000000,25,true);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			nameText.vAlign = VAlign.BOTTOM;
			container.addChild(nameText);
			nameText.x = renderWidth/2 - nameText.width/2;
			nameText.y = 0;
		}
		
	}
}


