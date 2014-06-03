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
	import starling.events.Event;
	
	import view.entity.RanchEntity;
	import view.render.RanchAnimalRender;

	public class AnimalRanchPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var ranchEntity:RanchEntity;
		private var list:List;
		public function AnimalRanchPanel(_ranchEntity:RanchEntity)
		{
			ranchEntity = _ranchEntity;
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
			
			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.scrollPositionVerticalAlign  = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.paddingTop =listLayout.paddingBottom =  30*scale;
			listLayout.gap = 10*scale;
			
			list = new List();
			list.layout = listLayout;
			list.width =  panelwidth*0.8;
			list.height = panelheight *0.95 -20*scale;
			list.dataProvider = new ListCollection(ranchEntity.animals);
			list.itemRendererFactory = 
				function tileListItemRendererFactory():RanchAnimalRender
				{
					const renderer:RanchAnimalRender = new RanchAnimalRender()
					renderer.width = panelwidth *0.2;
					renderer.height = panelheight *0.3;
					return renderer;
				};
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.1;
			list.y = 20*scale;
			
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
		
		private function onTriggered(e:Event):void
		{
			if(parent){
				parent.removeChild(this);
				dispose();
			}
		}
	}
}