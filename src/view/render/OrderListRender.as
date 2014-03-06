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
	import model.task.TaskData;
	
	import service.command.task.FinishOrder;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
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
				refreshData();
			}
		}
		
		private function refreshData():void
		{
			if(container){
				if(container.parent){
					container.parent.removeChild(container);
				}
				container = null;
			}
			checkOrderData();
		}
		private var renderwidth:Number;
		private var renderheight:Number;
		private var isTaskFinished:Boolean=true;
		private function checkOrderData():void
		{
			renderwidth = width;
			renderheight = height;
			
			if(player.my_order){
				configOrderLayout();
			}else{
				configNoOrderLayout();
			}
		}
		
		private var isTimeCord:Boolean;
		private var creatButton:Button;
		private function configNoOrderLayout():void
		{
			container = new Sprite;
			addChild(container);
			
			var mesContainer:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			mesContainer.width = renderwidth;
			mesContainer.height = renderheight;
			container.addChild(mesContainer);
			
			
			var nameTextStr:String;
			if(isHome){
				nameTextStr = LanguageController.getInstance().getString("my") +" "+LanguageController.getInstance().getString("order");
			}else{
				nameTextStr = player.name +" "+LanguageController.getInstance().getString("order");
			}
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,40*scale,nameTextStr,0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			mesContainer.addChild(nameText);
			nameText.x = 0 ;
			nameText.y = 0 ;
			
			var whiteSp:Shape = new Shape();
			mesContainer.addChild(whiteSp);
			whiteSp.graphics.lineStyle(3,0xEDCC97,1);
			whiteSp.graphics.moveTo(renderwidth*0.1,nameText.y+nameText.height +5*scale);
			whiteSp.graphics.lineTo(renderwidth*0.9,nameText.y+nameText.height +5*scale);
			whiteSp.graphics.endFill();
			
			var str:String = LanguageController.getInstance().getString("noorder");
			var textRequest:TextField = FieldController.createSingleLineDynamicField(mesContainer.width*0.8,mesContainer.height*0.5,str,0x000000,30,true);
			mesContainer.addChild(textRequest);
			textRequest.x = mesContainer.width*0.1;
			
			if(isHome){
				creatButton = new Button();
				creatButton.label = LanguageController.getInstance().getString("creat") +" "+LanguageController.getInstance().getString("order");
				creatButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				creatButton.y = mesContainer.y + mesContainer.height *0.5 ;
				creatButton.paddingLeft =creatButton.paddingRight =  20;
				creatButton.paddingTop =creatButton.paddingBottom =  5;
				creatButton.addEventListener(Event.TRIGGERED,onAddTriggered);
				creatButton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				container.addChild(creatButton);
				creatButton.validate();
				creatButton.x = container.width/2 - creatButton.width/2 ;
			}
		}
		
//		private function configTimeText():void
//		{
//			var leftTime:Number =SystemDate.systemTimeS - player.my_order_time;
//			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(leftTime) +" "+ LanguageController.getInstance().getString("ago")+")";
//			leftTimeText.text = leftTimeStr;
//			if(leftTime >5850){
//				isTimeCord = false;
//				creatButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
//				creatButton.isEnabled = true;
//			}
//		}
		private function configOrderLayout():void
		{
			container = new Sprite;
			addChild(container);
			
			var task:TaskData = player.my_order;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var name:String ;
			if(isHome){
				name = LanguageController.getInstance().getString("my") +" "+LanguageController.getInstance().getString("order");
			}else{
				name = player.name +" "+LanguageController.getInstance().getString("order");
			}
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,40*scale,name,0x000000,35,true);
			nameText.hAlign = HAlign.CENTER;
			container.addChild(nameText);
			nameText.x = 0 ;
			nameText.y = 0 ;
			
			var leftTime:int = Math.max(0,Configrations.ORDER_EXPIRED - (SystemDate.systemTimeS - task.creatTime));
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(leftTime) +" "+ LanguageController.getInstance().getString("left")+")";
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
				tradebutton.label = LanguageController.getInstance().getString("trade");
				if(isTaskFinished){
					tradebutton.addEventListener(Event.TRIGGERED,onTradeTriggered);
					tradebutton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				}else{
					tradebutton.isEnabled = false;
					tradebutton.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin"));
				}
				tradebutton.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				tradebutton.paddingLeft =tradebutton.paddingRight =  20;
				tradebutton.paddingTop =tradebutton.paddingBottom =  5;
				container.addChild(tradebutton);
				tradebutton.validate();
				tradebutton.x = renderwidth/2 - tradebutton.width/2 ;
				tradebutton.y = awardsContainer.y +awardsContainer.height+10*scale ;
			}
			
		}
		private var addOrderPanel:AddOrderPanel;
		private function onAddTriggered(e:Event):void
		{
			addOrderPanel = new AddOrderPanel();
			DialogController.instance.showPanel(addOrderPanel);
			addOrderPanel.addEventListener(Event.CLOSE,onCloseOrderPanel);
		}
		private function onCloseOrderPanel(e:Event):void
		{
			addOrderPanel.removeEventListener(Event.CLOSE,onCloseOrderPanel);
			addOrderPanel = null;
			refreshData();
		}
		private var isCommanding:Boolean;
		private function onTradeTriggered(e:Event):void
		{
			if(!isCommanding){
				player.cur_mes_dataid++;
				new FinishOrder(player.gameuid,player.cur_mes_dataid,onFinishedOrder,0);
				isCommanding = true;
			}
		}
		
		private function onFinishedOrder():void
		{
			isCommanding = false;
//			var player:GamePlayer = GameController.instance.currentPlayer;
//			var orderdata:TaskData = player.my_order;
//			if(GameController.instance.isHomeModel){
//				var reqestArr:Array = orderdata.requstStr.split("|");
//				var itemStr:String;
//				for each(itemStr in reqestArr){
//					var itemArr :Array = itemStr.split(":");
//					player.addItem(new OwnedItem(itemArr[0],itemArr[1]));
//				}
//			}
			player.my_order = null;
			refreshData();
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
			
			var requstArr:Array = player.my_order.requstStr.split("|");
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
			
			
			var ownitem:OwnedItem = localplayer.getOwnedItem(itemid);
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
			
			var requstArr:Array = player.my_order.rewards.split("|");
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
			icon.x = renderwidth*0.4 - icon.width - 10*scale;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.06,LanguageController.getInstance().getString(name),0x000000,25,true);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.CENTER;
			requestContainer.addChild(nameText);
			nameText.x = icon.x - nameText.width;
			
			var ownText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderheight*0.06,"×" + String(count),0x000000,25,true);
			ownText.autoSize = TextFieldAutoSize.HORIZONTAL;
			ownText.hAlign = HAlign.LEFT;
			ownText.vAlign = VAlign.CENTER;
			requestContainer.addChild(ownText);
			ownText.x = renderwidth*0.4;
			
			
			
			return requestContainer;
		}
		
		private function get isHome():Boolean
		{
			return GameController.instance.isHomeModel;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		private function get localplayer():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function onTriggeredRemove(e:Event):void
		{
			
		}
	}
}

