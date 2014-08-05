package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class PetSearchPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var coinCount:int;
		private var hasRob:Boolean;
		
		public function PetSearchPanel(coin:int,_hasRob:Boolean=false)
		{
			coinCount = coin;
			hasRob = _hasRob;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Math.min(1800,Configrations.ViewPortWidth*0.8);
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			addChild(panelSkin);
			panelSkin.x = Configrations.ViewPortWidth/2  - panelSkin.width/2;
			panelSkin.y = Configrations.ViewPortHeight*0.15;
			
			
			var deep:Number = Configrations.ViewPortHeight*0.15+30*scale;
			
			var dogIcon:Image = new Image(Game.assets.getTexture("DogIcon"));
			dogIcon.width = dogIcon.height = 80*scale;
			addChild(dogIcon);
			dogIcon.y = deep;
			
			var dogText:TextField = FieldController.createSingleLineDynamicField(200,dogIcon.height,LanguageController.getInstance().getString("findTip"),0x000000,30,true);
			dogText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(dogText);
			dogText.x = Configrations.ViewPortWidth/2 - dogText.width/2;
			dogText.y = deep;
			
			dogIcon.x = dogText.x - dogIcon.width - 10*scale;
			
			var coinIcon:Image = new Image(Game.assets.getTexture("coinIcon"));
			coinIcon.width = coinIcon.height = 50*scale;
			addChild(coinIcon);
			coinIcon.x = dogText.x+dogText.width + 10*scale;
			coinIcon.y = deep+15*scale;
			
			var coinText:TextField = FieldController.createSingleLineDynamicField(200,dogIcon.height,"×"+coinCount,0x000000,30,true);
			coinText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(coinText);
			coinText.x = coinIcon.x+coinIcon.width + 10*scale;
			coinText.y = deep;
			
			var leftP:Number = dogIcon.x - 50*scale;
			var rightP:Number = coinText.x+ coinText.width + 50*scale;
			
			deep += dogIcon.height+15*scale;
			
			if(hasRob){
				
				var whiteSp:Shape = new Shape();
				whiteSp.graphics.lineStyle(2,0xEDCC97,1);
				whiteSp.graphics.moveTo(dogIcon.x,deep);
				whiteSp.graphics.lineTo(coinText.x + coinText.width,deep);
				whiteSp.graphics.endFill();
				addChild(whiteSp);
				
				deep+= 15*scale;
				
				var dogIcon1:Image = new Image(Game.assets.getTexture("HuskyIcon"));
				dogIcon1.width = dogIcon1.height = 80*scale;
				addChild(dogIcon1);
				dogIcon1.y = deep;
				dogIcon1.x = dogIcon.x;
				
				var dogText1:TextField = FieldController.createSingleLineDynamicField(200,dogIcon.height,LanguageController.getInstance().getString("InterceptTip"),0x000000,30,true);
				dogText1.autoSize = TextFieldAutoSize.HORIZONTAL;
				addChild(dogText1);
				dogText1.x = dogText.x;
				dogText1.y = deep;
				
				var tipIcon:Image = new Image(Game.assets.getTexture("InterceptIcon"));
				tipIcon.width = tipIcon.height = 80*scale;
				addChild(tipIcon);
				tipIcon.x = dogText1.x+dogText1.width + 10*scale;
				tipIcon.y = deep;
				
				deep += dogIcon1.height+20*scale;
				
				rightP = Math.max(rightP,tipIcon.x +tipIcon.width + 30*scale);
				
			}
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  5;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth/2 - button.width/2;
			button.y =  deep+20*scale;
			button.addEventListener(Event.TRIGGERED,onTriggered);
			
			panelSkin.height = button.y + button.height + 20*scale - Configrations.ViewPortHeight*0.15;
			var L:Number = Math.max(Configrations.ViewPortWidth/2 - leftP,rightP - Configrations.ViewPortWidth/2);
			panelSkin.x = Configrations.ViewPortWidth/2 - L;
			panelSkin.width = 2*L;
		}
		
		private function onTriggered(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}