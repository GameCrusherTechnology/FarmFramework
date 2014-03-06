package view.render
{
	import controller.FieldController;
	import controller.FriendInfoController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.SimplePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class FriendListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function FriendListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		public var playerData:SimplePlayer;
		private var id:String;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				id = String(value);
				if(String(value) != "refresh"){
					playerData =FriendInfoController.instance.getUser(String(value));
				}
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
			var renderwidth:Number = width;
			var renderheight:Number = height;
			this.isSelected = true;
			container = new Sprite;
			addChild(container);
			
			if(playerData){
				var icon:Image= new Image(Game.assets.getTexture(playerData.headIconName));
				icon.height = renderheight*0.7;
				icon.scaleX = icon.scaleY;
				icon.x = renderwidth/2 - icon.width/2;
				icon.y = renderheight*0.2;
				container.addChild(icon);
				
				var nameText:TextField = FieldController.createNoFontField(1000, 30*scale,playerData.name,0x000000,18);
				nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(nameText);
				nameText.y = 0;
				nameText.x = renderwidth/2 - nameText.width/2;
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				expIcon.width = expIcon.height = 30*scale;
				container.addChild(expIcon);
				expIcon.x = 5*scale;
				expIcon.y = icon.y;
				
				
				var levelText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,30*scale,String(Configrations.expToGrade(playerData.exp)),0x000000,20,true);
				container.addChild(levelText);
				levelText.x = 5*scale;
				levelText.y = expIcon.y ;
			}else{
				var icon:Image= new Image(Game.assets.getTexture("iconBlueBackSkin"));
				icon.height = renderheight*0.8;
				icon.width = renderwidth*0.8;
				icon.x = renderwidth*0.1;
				icon.y = renderheight*.1;
				container.addChild(icon);
				
				var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight,LanguageController.getInstance().getString("find"),0x000000,30);
				container.addChild(nameText);
				
			}
			
		}
	}
}


