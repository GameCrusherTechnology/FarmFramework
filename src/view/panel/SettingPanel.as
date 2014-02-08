package view.panel
{
	import controller.FieldController;
	import controller.VoiceController;
	
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class SettingPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var musictoggle:ToggleSwitch;
		private var soundToggle:ToggleSwitch;
		
		private var renderHeight:Number;
		private var renderButtonWidth:Number;
		public function SettingPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			var scale:Number = Configrations.ViewScale;
			renderHeight = 50*scale;
			renderButtonWidth= panelwidth*0.2;
			
			var bottomH:Number = panelheight*0.15;
			var bgSkin:Shape = new Shape;
			bgSkin.graphics.lineStyle(2,0xEDCC97,1);
			bgSkin.graphics.beginFill(0xffffff,0.3);
			bgSkin.graphics.drawRect(panelwidth*0.05,panelheight*0.05,panelwidth*0.9,panelheight*0.9);
			bgSkin.graphics.moveTo(panelwidth*0.1,panelheight*0.1);
			bgSkin.graphics.lineTo(panelwidth*0.8,panelheight*0.1);
			bgSkin.graphics.endFill();
			addChild(bgSkin);
			
			var musicText:TextField = FieldController.createSingleLineDynamicField(panelwidth/2,50,LanguageController.getInstance().getString("music")+":",0x000000,35,true);
			musicText.hAlign = HAlign.RIGHT;
			musicText.vAlign = VAlign.CENTER;
			addChild(musicText);
			musicText.x =  0;
			musicText.y = bottomH;
			musictoggle = creatToggle();
			if(!VoiceController.MUSIC_DISABLE){
				musictoggle.isSelected = false;
			}
			addChild(musictoggle);
			musictoggle.x = panelwidth/2 +20*scale;
			musictoggle.y = bottomH;
			musictoggle.addEventListener(Event.CHANGE,onMusicChange);
			
			bottomH += (renderHeight+10);
			
			var musicText1:TextField = FieldController.createSingleLineDynamicField(panelwidth/2,50,LanguageController.getInstance().getString("sound")+":",0x000000,35,true);
			musicText1.hAlign = HAlign.RIGHT;
			musicText1.vAlign = VAlign.CENTER;
			addChild(musicText1);
			musicText1.x =  0;
			musicText1.y = bottomH;
			soundToggle = creatToggle();
			if(!VoiceController.SOUND_DISABLE){
				soundToggle.isSelected = false;
			}
			addChild(soundToggle);
			soundToggle.x = panelwidth/2 +20*scale;
			soundToggle.y = bottomH;
			bottomH += (renderHeight+50);
			soundToggle.addEventListener(Event.CHANGE,onSoundChange);
			
			bgSkin.graphics.moveTo(panelwidth*0.1,bottomH);
			bgSkin.graphics.lineTo(panelwidth*0.8,bottomH);
			bgSkin.graphics.endFill();
			
			var tipText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.8, panelheight - bottomH ,LanguageController.getInstance().getString("gameTip01"),0x000000,30,true);
			addChild(tipText);
			tipText.x = panelwidth*0.1;
			tipText.y = bottomH + 10*scale;
		}
		
		private function creatToggle():ToggleSwitch
		{
			var toggle:ToggleSwitch = new ToggleSwitch();
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;
			toggle.isSelected = true;
			toggle.defaultLabelProperties.textFormat =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
			toggle.width = renderButtonWidth;
			toggle.height =  renderHeight;
			var onImage1:Image = new Image(Game.assets.getTexture("okButtonSkin"));
			var onImage2:Image = new Image(Game.assets.getTexture("offButtonSkin"));
			toggle.onTrackProperties.defaultSkin =onImage1;
			toggle.offTrackProperties.defaultSkin = onImage2;
			return toggle;
		}
		
		private function onMusicChange( event:Event ):void
		{
			var toggle:ToggleSwitch = ToggleSwitch( event.currentTarget );
			VoiceController.instance.setMusic(toggle.isSelected);
		}
		
		private function onSoundChange( event:Event ):void
		{
			var toggle:ToggleSwitch = ToggleSwitch( event.currentTarget );
			VoiceController.instance.setSound(toggle.isSelected);
		}
		
	}
}