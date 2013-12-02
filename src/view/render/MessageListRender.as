package view.render
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.player.SimplePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MessageListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function MessageListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var playerData:SimplePlayer;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				if(playerData != value.player){
					playerData = value.player;
					if(container){
						if(container.parent){
							container.parent.removeChild(container);
						}
						container = null;
					}
					configLayout();
				}
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var icon:Image= new Image(Game.assets.getTexture((playerData.sex==Configrations.CHARACTER_BOY)?"boyIcon":"girlIcon"));
			icon.height = 40*scale;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,40*scale,playerData.name,0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = iconRight;
			nameText.y = icon.y ;
			
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(renderwidth *0.8,renderheight - 40*scale,playerData.mes,0x000000,25,true);
			container.addChild(titleText);
			titleText.vAlign = VAlign.TOP;
			titleText.x = renderwidth *0.1;
			titleText.y = nameText.y + nameText.height ;
			
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(SystemDate.systemTimeS - playerData.creatTime) +" "+ LanguageController.getInstance().getString("ago")+")";
			var timeText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,25*scale,leftTimeStr,0x000000,20,true);
			container.addChild(timeText);
			timeText.x = iconRight;
			timeText.y =  renderheight - timeText.height ;
			
			
			var visitButton:Button = new Button();
			visitButton.label = LanguageController.getInstance().getString("visit");
			visitButton.addEventListener(Event.TRIGGERED,onTriggeredVisit);
			visitButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			visitButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			visitButton.paddingLeft =visitButton.paddingRight =  20;
			visitButton.paddingTop =visitButton.paddingBottom =  5;
			container.addChild(visitButton);
			visitButton.validate();
			visitButton.x = renderwidth - visitButton.width-10*scale;
			visitButton.y =  renderheight*0.1;
			
			var removeButton:Button = new Button();
			removeButton.addEventListener(Event.TRIGGERED,onTriggeredRemove);
			removeButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			removeButton.width = removeButton.height = 30*scale;
			container.addChild(removeButton);
			removeButton.validate();
			removeButton.x = renderwidth - removeButton.width-10*scale;
			removeButton.y =  renderheight*0.95 - removeButton.height;
			
		}
		
		private function onTriggeredAccept(e:Event):void
		{
			
		}
		private function onTriggeredVisit(e:Event):void
		{
			
		}
		private function onTriggeredRemove(e:Event):void
		{
			
		}
	}
}

