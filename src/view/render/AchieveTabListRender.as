	package view.render
	{
		import controller.FieldController;
		
		import feathers.controls.TextArea;
		import feathers.controls.renderers.DefaultListItemRenderer;
		
		import gameconfig.Configrations;
		import gameconfig.LanguageController;
		
		import starling.display.Image;
		import starling.display.Sprite;
		import starling.text.TextField;
		import starling.text.TextFieldAutoSize;
		
		public class AchieveTabListRender extends DefaultListItemRenderer
		{
			private var scale:Number;
			private var mes:String;
			public function AchieveTabListRender()
			{
				super();
				scale = Configrations.ViewScale;
			}
			
			private var container:Sprite;
			override public function set data(value:Object):void
			{
				super.data = value;
				if(value){
					mes = String(value.name);
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
				var image:Image = new Image(Game.assets.getTexture(mes+"Icon"));
				addChild(image);
				image.width = image.height = 45*scale;
				image.x = width/2 - image.width/2;
				image.y = height/2 - image.height/2;
				
				var text:TextField = FieldController.createSingleLineDynamicField(100,50,LanguageController.getInstance().getString(mes),0x000000,25,true);
				text.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				addChild(text);
				text.x = width/2 - text.width/2;
				text.y = height-text.height;
			}
			
		}
	}
	
	
