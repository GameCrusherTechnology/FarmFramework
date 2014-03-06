package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	import controller.TaskController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.gameSpec.CropSpec;
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import service.command.task.FinishTaskCommand;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class TaskPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var panelSkin:Scale9Image;
		private var button:Button;
		private var isTaskFinished:Boolean = true;
		
		private var requestVec:Vector.<OwnedItem> = new Vector.<OwnedItem>;
		private var rewardVec:Vector.<OwnedItem> = new Vector.<OwnedItem>;
		
		public function TaskPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(Configrations.ViewPortWidth*0.86,2000);
			panelheight = Math.min(Configrations.ViewPortHeight*0.9,1500);
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			panelSkin = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight/2 - panelSkin.height/2;
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = Configrations.ViewPortHeight*0.05;
			cancelButton.x = panelSkin.x +panelSkin.width - cancelButton.width -5;
			cancelButton.y = panelSkin.y +5;
			
			configMesContainer();
			configRequestContainer();
			configRewardContainer();
			configButton();
			
			
		}
		private function configMesContainer():void
		{
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(container);
			container.width = panelwidth*0.9;
			container.height= panelheight*0.15;
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = panelSkin.y + panelheight*0.05;
			
			var iconName:String = (task.npc == Configrations.NPC_MALE)?"maleIcon":"femaleIcon";
			var icon:Image = new Image(Game.assets.getTexture(iconName));
			container.addChild(icon);
			icon.height = container.height *.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = container.height *.1;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 150, 80)));
			container.addChild(speechSkin);
			speechSkin.width = container.width - icon.width - 10*scale*2;
			speechSkin.height = container.height *.8;
			speechSkin.x = icon.x + icon.width;
			speechSkin.y = container.height *.1;
			
			var mesNam:String;
			if(task.npc == Configrations.NPC_MALE){
				mesNam = "taskTip02";
			}else{
				mesNam = "taskTip01";
			}
			var speechText:TextField = FieldController.createSingleLineDynamicField(speechSkin.width - 10*scale,container.height *.8,LanguageController.getInstance().getString(mesNam),0x000000,30,true);
			container.addChild(speechText);
			speechText.x =  icon.x + icon.width + 10*scale;
			speechText.y = container.height *.1;
			
		}
		private function configRequestContainer():void
		{
			var container:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(container);
			container.width = panelwidth*0.9;
			container.height= panelheight*0.4;
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = panelSkin.y + panelheight*0.22;
			
			
			var container1:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(container1);
			container1.width = panelwidth*0.8;
			container1.height= panelheight*0.33;
			container1.x = panelwidth *0.05;
			container1.y = panelheight*0.06;
			
			
			var str:String = LanguageController.getInstance().getString("request")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(container.width*0.8,panelheight*0.06,str,0x000000,30,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			container.addChild(textRequest);
			textRequest.x = container.width*0.05;
			
			var requstArr:Array = task.requstStr.split("|");;
			
			var requeststr:String;
			var deep:Number = panelheight*0.01;
			for each(requeststr in requstArr)
			{
				var itemId:String = requeststr.split(":")[0];
				var count:int = requeststr.split(":")[1];
				var render:Sprite = creatRequstRender(itemId,count);
				container1.addChild(render);
				render.y = deep;
				deep+= panelheight*0.11;
				requestVec.push(new OwnedItem(itemId,count));
			}
		}
		private function configButton():void
		{
			button = new Button();
			var taskName:String = "confirm";
			if(isTaskFinished && !task.getIsExpired()){
				taskName = "getReward";
			}
			button.label = LanguageController.getInstance().getString(taskName);
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  10;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  panelSkin.y + panelheight*0.9;
			button.addEventListener(Event.TRIGGERED,onTriggered);
		}
		
		private function creatRequstRender(itemid:String,count:int):Sprite
		{
			var container:Sprite = new Sprite;
			var spec:CropSpec = SpecController.instance.getItemSpec(itemid) as CropSpec;
			var icon:Image = new Image(Game.assets.getTexture(spec.name+"Icon"));
			container.addChild(icon);
			icon.width = icon.height = panelheight*0.1;
			icon.x = panelwidth*0.1;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.1,spec.cname,0x000000,35,true);
			nameText.hAlign = HAlign.LEFT;
			nameText.vAlign = VAlign.CENTER;
			container.addChild(nameText);
			nameText.x = icon.x + icon.width;
			
			
			var ownitem:OwnedItem = player.getOwnedItem(itemid);
			var bool:Boolean = (ownitem.count>=count) ;
			var color :uint = bool?0x00ff00:0xff0000;
			
			var ownText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.1,String(ownitem.count),color,35,true);
			ownText.autoSize = TextFieldAutoSize.HORIZONTAL;
			ownText.hAlign = HAlign.LEFT;
			ownText.vAlign = VAlign.CENTER;
			container.addChild(ownText);
			ownText.x = panelwidth*0.5;
			
			var requestText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.1," /"+String(count),0x000000,35,true);
			requestText.hAlign = HAlign.LEFT;
			requestText.vAlign = VAlign.CENTER;
			container.addChild(requestText);
			requestText.x = ownText.x +ownText.width;
			
			if(bool){
				var okIcon:Image = new Image(Game.assets.getTexture("okIcon"));
				container.addChild(okIcon);
				okIcon.width = okIcon.height = panelheight*0.08;
				okIcon.x  =  panelwidth*0.8 - okIcon.width;
			}
			
			isTaskFinished = (isTaskFinished && bool);
			
			return container;
		}
		private function configRewardContainer():void
		{
			var reqwardContainer:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20)));
			addChild(reqwardContainer);
			reqwardContainer.width = panelwidth*0.9;
			reqwardContainer.height= panelheight*0.24;
			reqwardContainer.x = Configrations.ViewPortWidth/2 - reqwardContainer.width/2;
			reqwardContainer.y = panelSkin.y + panelheight*0.64;
			
			var str:String = LanguageController.getInstance().getString("reward")+" :";
			var textRequest:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.8,panelheight*0.06,str,0x000000,30,true);
			textRequest.hAlign = HAlign.LEFT;
			textRequest.vAlign = VAlign.BOTTOM;
			reqwardContainer.addChild(textRequest);
			textRequest.x = reqwardContainer.width*0.05;
			
			var sp:Sprite = new Sprite;
			var rewardArr:Array = task.rewards.split("|");;
			var rewardstr:String;
			var left:Number = 0;
			for each(rewardstr in rewardArr)
			{
				var rewardType:int = rewardstr.split(":")[0];
				var count:int = rewardstr.split(":")[1];
				var render:Sprite = creatRewardRender(rewardType,count);
				sp.addChild(render);
				render.x = left;
				left +=render.width+50*scale;
				rewardVec.push(new OwnedItem(String(rewardType),count));
			}
			reqwardContainer.addChild(sp);
			sp.x = reqwardContainer.width/2 - sp.width/2;
			sp.y = textRequest.y + textRequest.height ;
			
			
			var leftTimeText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.45,panelheight*0.08,LanguageController.getInstance().getString("lefttime")+" ",0x000000,35,true);
			leftTimeText.hAlign = HAlign.RIGHT;
			reqwardContainer.addChild(leftTimeText);
			leftTimeText.x = 0;
			leftTimeText.y = sp.y+sp.height;
			
			var time :int = getLeftTime();
			var color :uint = (time >0)?0x00ff00:0xff0000;
			timeText = FieldController.createSingleLineDynamicField(panelwidth*0.45,panelheight*0.08,SystemDate.getTimeLeftString(time),color,35,true);
			timeText.hAlign = HAlign.LEFT;
			reqwardContainer.addChild(timeText);
			timeText.x = panelwidth*0.45;
			timeText.y = sp.y+sp.height;
			if(time >0){
				timeText.addEventListener(Event.ENTER_FRAME,onTimeTick);
			}else{
				
			}
		}
		
		private var timeText:TextField;
		private function onTimeTick(e:Event):void
		{
			var time:int = getLeftTime();
			if(time >0){
				timeText.text = SystemDate.getTimeLeftString(getLeftTime());
			}else{
				
			}
		}
		private function getLeftTime():int
		{
			return Math.max(0,Configrations.ORDER_EXPIRED-( SystemDate.systemTimeS - task.creatTime));
		}
		private function creatRewardRender(type:int,count:int):Sprite
		{
			var renderContainer:Sprite = new Sprite;
			var iconName:String;
			if(type == Configrations.REWARD_COIN){
				iconName = "coinIcon";
			}else if(type == Configrations.REWARD_EXP){
				iconName = "expIcon";
			}else{
				iconName = "loveIcon";
			}
			var expicon:Image = new Image(Game.assets.getTexture(iconName));
			renderContainer.addChild(expicon);
			expicon.width = expicon.height = panelheight*0.1;
			
			var expText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.4,panelheight*0.1,"×"+String(count),0x000000,25,true);
			expText.hAlign = HAlign.LEFT;
			expText.autoSize = TextFieldAutoSize.HORIZONTAL;
			expText.vAlign = VAlign.CENTER;
			renderContainer.addChild(expText);
			expText.x = expicon.x + expicon.width;
			return renderContainer;
		}
		private var isCommanding:Boolean;
		private function onTriggered(e:Event):void
		{
			if(!isCommanding){
				if(task.getIsExpired()){
					TaskController.instance.initTask();
					close();
				}
				if(isTaskFinished){
					new FinishTaskCommand(onFinishedTask);
					isCommanding = true;
				}else{
					close();
				}
			}
		}
		private function closeButton_triggeredHandler(e:Event):void
		{
			close();
		}
		private function onFinishedTask():void
		{
			isCommanding = false;
			var item:OwnedItem;
			for each(item in requestVec){
				player.deleteItem(item);
			}
			
			for each (item in rewardVec) 
			{
				if(int(item.itemid) == Configrations.REWARD_COIN){
					player.addCoin(item.count);
				}else if(int(item.itemid) == Configrations.REWARD_EXP){
					player.addExp(item.count);
				}else if(int(item.itemid) == Configrations.REWARD_LOVE){
					player.addLove(item.count);
				}else{
					player.addItem(item);
				}
			}
			GameController.instance.localPlayer.npc_order = null;
			TaskController.instance.initTask();
			close();
		}
		private function get task():TaskData
		{
			return GameController.instance.localPlayer.npc_order;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		private function close():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}