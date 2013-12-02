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
	
	public class InfoListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function InfoListRender()
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
				playerData = value.player;
				if(!container){
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
			icon.height = renderheight*0.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 40*scale;
			container.addChild(expIcon);
			expIcon.x = iconRight;
			expIcon.y = icon.y ;
			
			var levelText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,40*scale,"200",0x000000,20,true);
			container.addChild(levelText);
			levelText.x = iconRight;
			levelText.y = icon.y ;
			
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,40*scale,playerData.name,0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = iconRight+expIcon.width+10*scale;
			nameText.y = icon.y ;
			
			
			var mes:String ;
			if(playerData.type == SimplePlayer.REQUEST_FRIEND){
				mes = LanguageController.getInstance().getString("invited") + " "+ LanguageController.getInstance().getString("you");
			}else{
				mes = LanguageController.getInstance().getString("helped")  + " "+ LanguageController.getInstance().getString("you");
			}
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,40*scale,mes,0x000000,35,true);
			container.addChild(titleText);
			titleText.x = iconRight;
			titleText.y = nameText.y + nameText.height ;
			
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(SystemDate.systemTimeS - playerData.creatTime) +" "+ LanguageController.getInstance().getString("ago")+")";
			var timeText:TextField = FieldController.createSingleLineDynamicField(renderwidth - iconRight,30*scale,leftTimeStr,0x000000,25,true);
			container.addChild(timeText);
			timeText.x = iconRight;
			timeText.y = titleText.y + titleText.height ;
			
			
			var visitButton:Button = new Button();
			if(playerData.type == SimplePlayer.REQUEST_FRIEND){
				visitButton.label = LanguageController.getInstance().getString("accept");
				visitButton.addEventListener(Event.TRIGGERED,onTriggeredAccept);
			}else{
				visitButton.label = LanguageController.getInstance().getString("visit");
				visitButton.addEventListener(Event.TRIGGERED,onTriggeredVisit);
			}
			visitButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			visitButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
			visitButton.paddingLeft =visitButton.paddingRight =  20;
			visitButton.paddingTop =visitButton.paddingBottom =  5;
			container.addChild(visitButton);
			visitButton.validate();
			visitButton.x = renderwidth - visitButton.width-10*scale;
			visitButton.y =  renderheight/2;
			
		}
		
		private function onTriggeredAccept(e:Event):void
		{
			
		}
		private function onTriggeredVisit(e:Event):void
		{
			
		}
	}
}

