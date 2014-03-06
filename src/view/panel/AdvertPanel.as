package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.AdvertRender;

	public class AdvertPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		public function AdvertPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.8;
			panelheight = Configrations.ViewPortHeight*0.8;
			scale = Configrations.ViewScale;
			
			var darkSp:Shape = new Shape;
			darkSp.graphics.beginFill(0x000000,0.8);
			darkSp.graphics.drawRect(0,0,Configrations.ViewPortWidth,Configrations.ViewPortHeight);
			darkSp.graphics.endFill();
			addChild(darkSp);
			
			var skinTexture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(20,20,24,24));
			var panelSkin:Scale9Image = new Scale9Image(skinTexture);
			panelSkin.width = panelwidth;
			panelSkin.height = panelheight;
			addChild(panelSkin);
			panelSkin.x =  panelwidth*0.1;
			panelSkin.y =  panelheight*0.1;
			
			configMesContainer();
			
			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.paddingTop =listLayout.paddingBottom= 20*scale;
			listLayout.gap = 10*scale;
			
			var list:List = new List();
			list.layout = listLayout;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			list.backgroundSkin = new Scale9Image(skintextures);
			list.dataProvider = new ListCollection(['advert']);
			list.itemRendererFactory =function tileListItemRendererFactory():AdvertRender
			{
				var renderer:AdvertRender = new AdvertRender();
				renderer.width = panelwidth *0.85;
//				renderer.height =panelheight*0.25;
				return renderer;
			}
			list.width =  panelwidth*0.9;
			list.height =  panelheight *0.65;
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.15;
			list.y = panelheight*0.27;
			
			var button:Button = new Button();
			button.label = LanguageController.getInstance().getString("confirm");
			button.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			button.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			button.paddingLeft =button.paddingRight =  20;
			button.paddingTop =button.paddingBottom =  10;
			addChild(button);
			button.validate();
			button.x = Configrations.ViewPortWidth*0.5 - button.width/2;
			button.y = panelheight*0.95+20*scale;
			button.addEventListener(Event.TRIGGERED,onTriggered);
		}
		
		private function configMesContainer():void
		{
			var container:Sprite =  new Sprite();
			addChild(container);
			container.x = panelwidth*0.1;
			container.y = panelheight*0.12;
			
			var iconName:String ="femaleIcon";
			var icon:Image = new Image(Game.assets.getTexture(iconName));
			container.addChild(icon);
			icon.height = panelheight*0.25;
			icon.scaleX = icon.scaleY;
			icon.x = panelwidth*0.1;
			icon.y = - panelheight*0.1;
			
			var speechSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"), new Rectangle(30, 10, 100, 80)));
			container.addChild(speechSkin);
			speechSkin.width = panelwidth*0.8 - icon.width - 10*scale*2;
			speechSkin.height = panelheight*0.08;
			speechSkin.x = icon.x + icon.width;
			speechSkin.y = panelheight*0.01;
			
			var speechText:TextField = FieldController.createSingleLineDynamicField(speechSkin.width - 10*scale,speechSkin.height,LanguageController.getInstance().getString("versionUp"),0x000000,30,true);
			container.addChild(speechText);
			speechText.x =  icon.x + icon.width + 10*scale;
			speechText.y = speechSkin.y;
			
		}
		
		private function onTriggered(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
				dispose();
			}
		}
	}
}