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
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				playerData =FriendInfoController.instance.getUser(value as String);
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
			
			container = new Sprite;
			addChild(container);
			
			var icon:Image= new Image(Game.assets.getTexture((playerData.sex==Configrations.CHARACTER_BOY)?"boyIcon":"girlIcon"));
			icon.height = renderheight*0.8;
			icon.scaleX = icon.scaleY;
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderheight*0.2;
			container.addChild(icon);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,30*scale,playerData.name,0x000000,20,true);
			container.addChild(nameText);
			nameText.y = 0 ;
			
			
			var mes:String;
			if(playerData.title){
				var titlesArr:Array = playerData.title.split("|");
				mes = LanguageController.getInstance().getTitle(titlesArr[0],titlesArr[1]);
			}else{
				mes = LanguageController.getInstance().getString("noTitle");
			}
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(renderwidth ,30*scale,mes,0x000000,15,true);
			container.addChild(titleText);
			titleText.x = 0;
			titleText.y = renderheight - titleText.height ;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 30*scale;
			container.addChild(expIcon);
			expIcon.x = 5*scale;
			expIcon.y = icon.y;
			
			
			var levelText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,30*scale,String(Configrations.expToGrade(playerData.exp)),0x000000,20,true);
			container.addChild(levelText);
			levelText.x = 5*scale;
			levelText.y = expIcon.y ;
			
			
		}
	}
}


