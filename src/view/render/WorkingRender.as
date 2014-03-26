package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.gameSpec.FormulaItemSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.component.PackageIcon;
	
	public class WorkingRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var mesData:Object;
		private static var WAITING:String = "wait";
		private static var WORKING:String = "work";
		private static var Finished:String = "finished";
		public function WorkingRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				mesData = value;
				isTicking = false;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				configLayout();
			}
		}
		private var renderwidth:Number;
		private var renderheight:Number;
		private var workingIndex:int ;
		private function configLayout():void
		{
			renderwidth = width;
			renderheight = height;
			
			container = new Sprite;
			addChild(container);
			workingIndex = mesData.index;
			var mesId:String = mesData.id;
			if(mesId == "null"){
				configNullContainer();
			}else{
				configItemContainer(mesId);
			}
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 30*scale;
			container.addChild(expIcon);
			
			var indexText:TextField = FieldController.createSingleLineDynamicField(30*scale,30*scale,String(workingIndex+1),0x000000,25);
			container.addChild(indexText);
			
		}
		private function configNullContainer():void
		{
			var skin:Image = new Image(Game.assets.getTexture("iconGreenBackSkin"));
			skin.width = renderwidth*0.9;
			skin.height= renderheight*0.9;
			container.addChild(skin);
			skin.x =renderwidth*0.05;
			skin.y =renderheight*0.05;
			
		}
		private var startTime:Number;
		private var endTime:Number;
		private var itemSpec:FormulaItemSpec;
		private function configItemContainer(id:String):void
		{
			var skin:Image = new Image(Game.assets.getTexture("iconBlueBackSkin"));
			skin.width = renderwidth*0.9;
			skin.height= renderheight*0.9;
			container.addChild(skin);
			skin.x =renderwidth*0.05;
			skin.y =renderheight*0.05;
			
			itemSpec = SpecController.instance.getItemSpec(id) as FormulaItemSpec;
			
			var icon:PackageIcon;
			
			var rewardS:String = itemSpec.product;
			var rewardArr:Array = rewardS.split("|");
			var rewardSpec:ItemSpec
			
			if(rewardArr[0]){
				var rewardId:String  = rewardArr[0].split(":")[0];
				rewardSpec= SpecController.instance.getItemSpec(rewardId);
			}
			if(!rewardSpec){
				rewardSpec = itemSpec;
			}
			icon = new PackageIcon(rewardSpec);
			icon.width = renderwidth*0.7;
			icon.height= renderheight*0.7;
			container.addChild(icon);
			icon.x =renderwidth*0.15;
			icon.y =renderheight*0.15;
			
			startTime = getFormulaStartTime();
			endTime = startTime + itemSpec.workTime;
			checkState();
		}
		private var isTicking:Boolean;
		private var curState:String;
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			if(isTicking){
				checkState();
			}
		}
		private function checkState():void
		{
			var systemTime:Number = SystemDate.systemTimeS;
			if(systemTime >= endTime){
				isTicking = false;
				configFinished();
			}else if(systemTime >= startTime){
				isTicking = true;
				configWorking(endTime-systemTime);
			}else{
				isTicking = true;
				configWaiting();
			}
		}
		private function configFinished():void
		{
			if(curState == WORKING){
				DialogController.instance.factoryPanel.refreshHarvestButEnable();
			}
			curState = Finished;
			if(workingText && workingText.parent){
				workingText.parent.removeChild(workingText);
			}
			
			var okIcon:Image = new Image(Game.assets.getTexture("okIcon"));
			container.addChild(okIcon);
			okIcon.width  = 50*scale;
			okIcon.height = 40*scale;
			okIcon.x  =  renderwidth*0.9 - okIcon.width;
			okIcon.y  =  renderheight - okIcon.height;
		}
		private var workingText:TextField;
		
		private function configWorking(leftTime:Number):void
		{
			curState = WORKING;
			if(!workingText){
				workingText = FieldController.createSingleLineDynamicField(renderwidth,renderheight,SystemDate.getTimeLeftString(leftTime),0x000000,25);
				workingText.autoSize = TextFieldAutoSize.VERTICAL;
			}else{
				workingText.text = SystemDate.getTimeLeftString(leftTime);
			}
			container.addChild(workingText);
			workingText.y = renderheight - workingText.height;
			
//			if(cancelBut && cancelBut.parent){
//				cancelBut.parent.removeChild(cancelBut);
//				cancelBut.removeEventListener(Event.TRIGGERED,canceltriggeredHandler);
//				cancelBut = null;
//			}
		}
		
		private function configWaiting():void
		{
			curState = WAITING;
//			if(!cancelBut){
//				cancelBut= new Button();
//				cancelBut.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
//				cancelBut.addEventListener(Event.TRIGGERED, canceltriggeredHandler);
//			}
//			container.addChild(cancelBut);
//			cancelBut.width = cancelBut.height = renderwidth*0.2;
//			cancelBut.x = renderwidth - cancelBut.width ;
		}
		private function canceltriggeredHandler(e:Event):void
		{
			player.removeWorkingFormula(workingIndex);
			DialogController.instance.factoryPanel.refreshWorkingList();
		}
		private function getFormulaStartTime():Number
		{
			var startIndex:int = player.workTimeIndex;
			var formulasArr:Array = player.formulas.split(":");
			var id:String;
			var formulaSpec:FormulaItemSpec;
			var formulaTime:Number = player.workTime;
			if(workingIndex >= startIndex){
				for(startIndex;startIndex< workingIndex;startIndex++){
					id = formulasArr[startIndex];
					formulaSpec = SpecController.instance.getItemSpec(id) as FormulaItemSpec;
					formulaTime += formulaSpec.workTime;
				}
			}else{
				formulaTime = 0;
			}
			return formulaTime;
		}
		private function get player():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
	}
}

