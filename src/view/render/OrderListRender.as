package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.gameSpec.CropSpec;
	import model.player.GamePlayer;
	import model.player.SimplePlayer;
	import model.task.TaskData;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import view.panel.AddOrderPanel;
	
	public class OrderListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function OrderListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
					container = null;
				}
				checkOrderData();
			}
		}
		private var renderwidth:Number;
		private var renderheight:Number;
		private var isTaskFinished:Boolean;
		private function checkOrderData():void
		{
			renderwidth = width;
			renderheight = height;
			
			if(player.order){
				configOrderLayout();
			}else{
				configNoOrderLayout();
			}
		}
		
		private var leftTimeText:TextField;
		private var isTimeCord:Boolean;
		private var creatButton:Button;
		private function configNoOrderLayout():void
		{
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,40*scale,player.name +" "+LanguageController.getInstance().getString("order"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			container.addChild(nameText);
			nameText.x = 0 ;
			nameText.y = 0 ;
			
			var mesContainer:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			mesContainer.width = renderwidth*0.9;
			mesContainer.height = renderheight -70*scale ;
			container.addChild(mesContainer);
			mesContainer.x =  renderwidth*0.05;
			mesContainer.y = nameText.y + nameText.height +15*scale;
			
			var str:String = LanguageController.getInstance().getString("noorder");
			var textRequest:TextField = FieldController.createSingleLineDynamicField(mesContainer.width*0.8,mesContainer.height*0.5,str,0x000000,30,true);
			mesContainer.addChild(textRequest);
			textRequest.x = mesContainer.width*0.1;
			
			if(isHome){
				var leftTime:Number =SystemDate.systemTimeS - player.creatOrderTime;
				creatButton = new Button();
				creatButton.label = LanguageController.getInstance().getString("add")+LanguageController.getInstance().getString("order");
				if(leftTime >0){
					var leftTimeStr:String = "("+SystemDate.getTimeLeftString(leftTime) +" "+ LanguageController.getInstance().getString("ago")+")";
					leftTimeText = FieldController.createSingleLineDynamicField(mesContainer.width ,35*scale,leftTimeStr,0x000000,30,true);
					mesContainer.addChild(leftTimeText);
					leftTimeText.y = mesContainer.height *0.5;
					creatButton.defaultSkin = new Image(Game.assets.getTexture("greyButtonSkin"));
					creatButton.y = mesContainer.y + mesContainer.height *0.5 + leftTimeText.height;
					creatButton.isEnabled = false;
					isTimeCord = true;
				}else{
					creatButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
					creatButton.y = mesContainer.height *0.5 ;
				}
				creatButton.addEventListener(Event.TRIGGERED,onAddTriggered);
				creatButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
				creatButton.paddingLeft =creatButton.paddingRight = creatButton.paddingTop =creatButton.paddingBottom =  5;
				container.addChild(creatButton);
				creatButton.validate();
				creatButton.x = container.width/2 - creatButton.width/2 ;
			}
		}
		
		private function configTimeText():void
		{
			var leftTime:Number =SystemDate.systemTimeS - player.creatOrderTime;
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(leftTime) +" "+ LanguageController.getInstance().getString("ago")+")";
			leftTimeText.text = leftTimeStr;
			trace(leftTime);
			if(leftTime >5850){
				isTimeCord = false;
				creatButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				creatButton.isEnabled = true;
			}
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			if(isTimeCord){
				configTimeText();
			}
		}
		private function configOrderLayout():void
		{
			container = new Sprite;
			addChild(container);
			
			var task:TaskData = player.order;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,40*scale,player.name +" "+LanguageController.getInstance().getString("order"),0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			container.addChild(nameText);
			nameText.x = 0 ;
			nameText.y = 0 ;
			
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(SystemDate.systemTimeS - task.creatTime) +" "+ LanguageController.getInstance().getString("ago")+")";
			var timeText:TextField = FieldController.createSingleLineDynamicField(renderwidth ,25*scale,leftTimeStr,0x000000,20,true);
			container.addChild(timeText);
			timeText.x = 0;
			timeText.y = nameText.y + nameText.height;
			
			var requestContainer:Scale9Image = configRequestContainer();
			container.addChild(requestContainer);
			requestContainer.x = renderwidth*0.05;
			requestContainer.y = timeText.y + timeText.height;
			
			var awardsContainer:Scale9Image = configAwardsContainer();
			container.addChild(awardsContainer);
			awardsContainer.x = renderwidth*0.05;
			awardsContainer.y = requestContainer.y + requestContainer.height + 10*scale;
			
			if(!isHome){
				var tradebutton:Button = new Button();
				tradebutton.label = LanguageController.getInstance().getString("close");
				if(isTaskFinished){
					tradebutton.addEventListener(Event.TRIGGERED,onTradeTriggered);
					tradebutton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				}else{
					tradebutton.isEnabled = false;
					tradebutton.defaultSkin = new Image(Game.assets.getTexture("greyButtonSkin"));
				}
				tradebutton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0xffffff);
				tradebutton.paddingLeft =tradebutton.paddingRight =  5;
				tradebutton.paddingTop =tradebutton.paddingBottom =  5;
				container.addChild(tradebutton);
				tradebutton.validate();
				tradebutton.x = renderwidth/2 - tradebutton.width/2 ;
				tradebutton.y = renderheight - tradebutton.height  ;
			}
			
		}
		
		private function onAddTriggered(e:Event):void
		{
			DialogController.instance.showPanel( new AddOrderPanel());
		}
		
		private function onTradeTriggered(e:Event):void
		{
			
		}

		private function configRequestContainer():Scale9Image
		{
			var requestContainer:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			requestContainer.width = renderwidth*0.9;
			
			var str:String = LanguageController.getInstance().getString("request")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(requestContainer.width*0.8,renderheight*0.08,str,0x000000,30,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			requestContainer.addChild(textRequest);
			textRequest.x = requestContainer.width*0.1;
			
			
			var container1:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			requestContainer.addChild(container1);
			container1.width = renderwidth*0.8;
			container1.x = renderwidth *0.05;
			container1.y = renderheight*0.08;
			
			var requstArr:Array = ["10001:20","10002:20","10003:0"];
			var requeststr:String;
			var deep:Number = renderheight*0.01;
			for each(requeststr in requstArr)
			{
				var itemId:String = requeststr.split(":")[0];
				var count:int = requeststr.split(":")[1];
				var render:Sprite = creatRequstRender(itemId,count);
				container1.addChild(render);
				render.y = deep;
				deep+= renderheight*0.11;
			}
			container1.height= deep;
			requestContainer.height= deep+renderheight*0.13;
			return requestContainer;
		}
		private function creatRequstRender(itemid:String,count:int):Sprite
		{
			var requestContainer:Sprite = new Sprite;
			var spec:CropSpec = SpecController.instance.getItemSpec(itemid) as CropSpec;
			var icon:Image = new Image(Game.assets.getTexture(spec.name+"Icon"));
			requestContainer.addChild(icon);
			icon.width = icon.height = renderheight*0.1;
			icon.x = renderwidth*0.1;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.1,spec.name,0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.CENTER;
			requestContainer.addChild(nameText);
			nameText.x = icon.x + icon.width;
			
			
			var ownitem:OwnedItem = player.getOwnedItem(itemid);
			var bool:Boolean = (ownitem.count>=count) ;
			var color :uint = bool?0x00ff00:0xff0000;
			
			var ownText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.1,String(ownitem.count),color,35,true);
			ownText.autoSize = TextFieldAutoSize.HORIZONTAL;
			ownText.hAlign = HAlign.LEFT;
			ownText.vAlign = VAlign.CENTER;
			requestContainer.addChild(ownText);
			ownText.x = renderwidth*0.5;
			
			var requestText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.1," /"+String(count),0x000000,35,true);
			requestText.hAlign = HAlign.LEFT;
			requestText.vAlign = VAlign.CENTER;
			requestContainer.addChild(requestText);
			requestText.x = ownText.x +ownText.width;
			
			if(bool){
				var okIcon:Image = new Image(Game.assets.getTexture("okIcon"));
				requestContainer.addChild(okIcon);
				okIcon.width = okIcon.height = renderheight*0.08;
				okIcon.x  =  renderwidth*0.8 - okIcon.width;
			}
			
			isTaskFinished = (isTaskFinished && bool);
			
			return requestContainer;
		}
		
		private function configAwardsContainer():Scale9Image
		{
			var requestContainer:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			requestContainer.width = renderwidth*0.9;
			
			
			var str:String = LanguageController.getInstance().getString("reward")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(requestContainer.width*0.8,renderheight*0.08,str,0x000000,30,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			requestContainer.addChild(textRequest);
			textRequest.x = requestContainer.width*0.1;
			
			
			var container1:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			requestContainer.addChild(container1);
			container1.width = renderwidth*0.8;
			container1.x = renderwidth *0.05;
			container1.y = renderheight*0.08;
			
			var requstArr:Array = ["10001:20","10002:20","1:500"];
			var requeststr:String;
			var deep:Number = renderheight*0.01;
			for each(requeststr in requstArr)
			{
				var itemId:String = requeststr.split(":")[0];
				var count:int = requeststr.split(":")[1];
				var render:Sprite = creatAwardsRender(itemId,count);
				container1.addChild(render);
				render.y = deep;
				deep+= renderheight*0.07;
			}
			container1.height= deep;
			requestContainer.height= deep+renderheight*0.13;
			return requestContainer;
		}
		private function creatAwardsRender(itemid:String,count:int):Sprite
		{
			var requestContainer:Sprite = new Sprite;
			var name:String;
			if(int(itemid) == Configrations.REWARD_COIN){
				name = "coin";
			}else if(int(itemid) == Configrations.REWARD_LOVE){
				name = "love";
			}else if(int(itemid) == Configrations.REWARD_EXP){
				name = "exp";
			}else{
				var spec:CropSpec = SpecController.instance.getItemSpec(itemid) as CropSpec;
				name = spec.name;
			}
			var icon:Image = new Image(Game.assets.getTexture(name+"Icon"));
			requestContainer.addChild(icon);
			icon.width = icon.height = renderheight*0.06;
			icon.x = renderwidth*0.1;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.06,LanguageController.getInstance().getString(name),0x000000,25,true);
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.CENTER;
			requestContainer.addChild(nameText);
			nameText.x = icon.x + icon.width;
			
			
			var ownText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.06,"×" + String(count),0x000000,25,true);
			ownText.autoSize = TextFieldAutoSize.HORIZONTAL;
			ownText.hAlign = HAlign.LEFT;
			ownText.vAlign = VAlign.CENTER;
			requestContainer.addChild(ownText);
			ownText.x = renderwidth*0.5;
			
			
			
			return requestContainer;
		}
		
		private function get isHome():Boolean
		{
			return GameController.instance.currentPlayer == GameController.instance.localPlayer;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		private function onTriggeredRemove(e:Event):void
		{
			
		}
	}
}

