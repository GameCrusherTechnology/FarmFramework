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

	public class ConfirmPanel extends PanelScreen
	{
			private var mes:String;
			private var onConfirmFun:Function;
			private var onCancelFun:Function;
			public function ConfirmPanel(str:String,onConfirm:Function,onCancel:Function)
			{
				mes = str;
				onConfirmFun = onConfirm;
				onCancelFun = onCancel;
				addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			}
			protected function initializeHandler(event:Event):void
			{
				
				var scale:Number = Configrations.ViewScale;
				
				var darkSp:Shape = new Shape;
				darkSp.graphics.beginFill(0x000000,0.8);
				darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
				darkSp.graphics.endFill();
				addChild(darkSp);
				
				var backgroundSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
				var bsSkin:Scale9Image = new Scale9Image(backgroundSkinTextures);
				addChild(bsSkin);
				
				var mesText:TextField = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth/2,Configrations.ViewPortHeight/2,
					mes,0xff0000,35,true);
				addChild(mesText);
				mesText.autoSize = TextFieldAutoSize.VERTICAL;
				mesText.x = Configrations.ViewPortWidth*0.25;
				mesText.y = Configrations.ViewPortHeight/2 - mesText.height - 20*scale;
				mesText.touchable = false;
				
				var button:Button = new Button();
				button.label = LanguageController.getInstance().getString("confirm");
				button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				button.paddingLeft =button.paddingRight =  20;
				button.paddingTop =button.paddingBottom =  10;
				addChild(button);
				button.validate();
				button.x = Configrations.ViewPortWidth/2 + 10*scale;
				button.y =  Configrations.ViewPortHeight/2 + 10*scale;
				button.addEventListener(Event.TRIGGERED,onTriggered);
				
				var button1:Button = new Button();
				button1.label = LanguageController.getInstance().getString("cancel");
				button1.defaultSkin = new Image(Game.assets.getTexture("cancelButtonSkin"));
				button1.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				button1.paddingLeft =button1.paddingRight =  20;
				button1.paddingTop =button1.paddingBottom =  10;
				addChild(button1);
				button1.validate();
				button1.x = Configrations.ViewPortWidth/2 -button1.width -10*scale;
				button1.y =  Configrations.ViewPortHeight/2 + 10*scale;
				button1.addEventListener(Event.TRIGGERED,onTriggeredCanel);
				
				bsSkin.width = Math.max(mesText.width , button.x + button.width -button1.x) +30*scale;
				bsSkin.height = button1.y +button1.height - mesText.y + 30*scale;
				bsSkin.x = Configrations.ViewPortWidth/2 - bsSkin.width/2;
				bsSkin.y = mesText.y - 15*scale;
			}
			private function onTriggered(e:Event):void
			{
				onConfirmFun();
				destroy();
				
			}
			private function onTriggeredCanel(e:Event):void
			{
				onCancelFun();
				destroy();
			}
			private function destroy():void
			{
				if(parent){
					parent.removeChild(this);
				}
			}
	}
}