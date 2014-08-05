package view.panel
{
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.text.TextFormatAlign;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.VoiceController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
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
		
		private var scale:Number;
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
			scale = Configrations.ViewScale;
			renderHeight = 50*scale;
			renderButtonWidth= panelwidth*0.2;
			
			var bottomH:Number = panelheight*0.15;
			var bgSkin:Shape = new Shape;
			bgSkin.graphics.lineStyle(2,0xEDCC97,1);
			bgSkin.graphics.beginFill(0xffffff,0.3);
			bgSkin.graphics.drawRect(panelwidth*0.05,panelheight*0.05,panelwidth*0.9,panelheight*0.9);
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
			
			var tipText:TextField = FieldController.createSingleLineDynamicField(panelwidth/2,panelheight*0.12 ,LanguageController.getInstance().getString("language")+":",0x000000,35,true);
			tipText.hAlign = HAlign.RIGHT;
			tipText.vAlign = VAlign.CENTER;
			addChild(tipText);
			tipText.x = 0;
			tipText.y = bottomH + 10*scale;
			
			lanList = configLanguage();
			lanList.addEventListener(Event.CHANGE,onChange);
			addChild(lanList);
			lanList.x = panelwidth/2 +20*scale;
			lanList.y = bottomH + 10*scale;
			
			bottomH =lanList.y + panelheight*0.12 + 5*scale;
			
			var tipText2:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.12 ,LanguageController.getInstance().getString("needRebootGame"),0xff0000,25,true);
			addChild(tipText2);
			tipText2.x = 0;
			tipText2.y = bottomH ;
			
		}
		private var lanList:PickerList;
		private function configLanguage():PickerList
		{
			var _list:PickerList = new PickerList();
			
			var lanObj:SharedObject = SharedObject.getLocal(Configrations.SHARE_LANGUAGE);
			var language:String;
			if(lanObj && lanObj.data && lanObj.data.obj){
				language = lanObj.data.obj;
			}else{
				language = Capabilities.language;
			}
			language = getCurLan(language);
			_list.prompt = language;
			_list.dataProvider = new ListCollection(["English","German","Turkish","Russian","Simplified Chinese","Traditional Chinese"]);
			_list.selectedIndex = -1;
			const listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.horizontalCenter = 0;
			listLayoutData.verticalCenter = 0;
			_list.layoutData = listLayoutData;
			
			_list.typicalItem = { text:  LanguageController.getInstance().getString("SelectItem") };
			_list.labelField = "text";
			
			
			_list.popUpContentManager = new DropDownPopUpContentManager();
			_list.listFactory = function():List
			{
				var list:List = new List();
				list.height =200*scale;
				list.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.labelField = "text";
					var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
					renderer.defaultSkin = new Scale9Image(skintextures);
					renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
					renderer.height=60*scale;
					return renderer;
				};
				return list;
			};
			
			_list.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.height = panelheight*0.12;
				button.width = _list.width;
				button.defaultSkin = new Image( Game.assets.getTexture("greenButtonSkin") );
				button.paddingTop = button.paddingBottom = 20*scale;
				button.paddingLeft = button.paddingRight = 40*scale;
				button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return button;
			};
			return _list;
		}
		
		private function onChange(e:Event):void{
			var language:String = lanList.selectedItem as String;
			language = setCurLan(language);
			var lanObj:SharedObject = SharedObject.getLocal(Configrations.SHARE_LANGUAGE);
			lanObj.data.obj = language;
			lanObj.flush();
			
			GameController.instance.refreshLanguage();
		}
		
		private function getCurLan(s:String):String
		{
			var language:String;
			if(s == "zh-CN"){
				language  = "Simplified Chinese";
			}else if(s == "zh-TW"){
				language  = "Traditional Chinese";
			}
			else if(s == "ru"){
				language = "Russian";
			}
			else if(s == "tr"){
				language = "Turkish";
			}
			else if(s == "de"){
				language = "German";
			}
			else{
				language = "English";
			}
			return language;
		}
		private function setCurLan(language:String):String
		{
			var lan:String;
			if(language == "Simplified Chinese"){
				lan  = "zh-CN";
			}else if(language == "Traditional Chinese"){
				lan  = "zh-TW";
			}
			else if(language == "Russian"){
				lan = "ru";
			}
			else if(language == "Turkish"){
				lan = "tr";
			}
			else if(language == "German"){
				lan = "de";
			}
			else{
				lan = "en";
			}
			
			return lan;
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