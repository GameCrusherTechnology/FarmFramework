package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.AdvertRender;
	import view.render.FormulaRender;
	import view.render.WorkingRender;

	public class FactoryPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		public function FactoryPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.9;
			panelheight = Configrations.ViewPortHeight*0.9;
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
			panelSkin.x =  Configrations.ViewPortWidth*0.05;
			panelSkin.y =  Configrations.ViewPortHeight*0.05;
			
			configTitle();
//			configWorkingList();
			configFormulasList();
			
			var cancelButton:Button = new Button();
			cancelButton.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			cancelButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			addChild(cancelButton);
			cancelButton.width = cancelButton.height = 50*scale;
			cancelButton.x = Configrations.ViewPortWidth*0.95 -cancelButton.width +20*scale;
			cancelButton.y = Configrations.ViewPortHeight*0.05 - 20*scale;
		}
		
		private function configTitle():void
		{
			var titleSkin:Image = new Image(Game.assets.getTexture("titleSkin"));
			addChild(titleSkin);
			titleSkin.width = Configrations.ViewPortWidth *.4;
			titleSkin.scaleY = titleSkin.scaleX;
			titleSkin.x = Configrations.ViewPortWidth/2 - titleSkin.width/2;
			titleSkin.y = Configrations.ViewPortHeight *.01;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(titleSkin.width,titleSkin.height,"Factory",0x000000,35,true);
			addChild(titleText);
			titleText.autoSize = TextFieldAutoSize.VERTICAL;
			titleText.x = titleSkin.x;
			titleText.y = titleSkin.y +titleSkin.height/2 -  titleText.height;
		}
		private function configWorkingList():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20)));
			container.addChild(skin);
			skin.width = panelwidth*0.9;
			skin.height= panelheight*0.25;
			
			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.paddingTop =listLayout.paddingBottom= 20*scale;
			listLayout.gap = 10*scale;
			
			var list:List = new List();
			list.layout = listLayout;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20));
			list.backgroundSkin = new Scale9Image(skintextures);
			list.dataProvider = new ListCollection(['advert']);
			list.itemRendererFactory =function tileListItemRendererFactory():WorkingRender
			{
				var renderer:WorkingRender = new WorkingRender();
				renderer.width = panelwidth *0.15;
				renderer.height =panelheight*0.2;
				return renderer;
			}
			list.width =  panelwidth*0.9;
			list.height =  panelheight *0.65;
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.15;
			list.y = panelheight*0.27;
			
			container.x = Configrations.ViewPortWidth*0.05+panelwidth*0.05;
			container.y = Configrations.ViewPortHeight*0.05+panelheight*0.05;
		}
		
		private function configFormulasList():void
		{
			var container:Sprite = new Sprite();
			addChild(container);
			var skin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(1, 1, 62, 62)));
			container.addChild(skin);
			skin.width = panelwidth*0.9;
			skin.height= panelheight*0.6;
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.manageVisibility = true;
			listLayout.horizontalGap = 4;
			listLayout.verticalGap = Configrations.ViewPortHeight*0.01;
			
			var list:List = new List();
			list.layout = listLayout;
			var goupe:Object = SpecController.instance.getGroup("Formula");
			var spec:ItemSpec;
			var array:Array = [];
			for each(spec in goupe){
				array.push(spec);
			}
			
			list.dataProvider = new ListCollection(array);
			list.itemRendererFactory =function tileListItemRendererFactory():FormulaRender
			{
				var renderer:FormulaRender = new FormulaRender();
				renderer.width = panelwidth *0.65;
				renderer.height =panelheight*0.55;
				return renderer;
			}
			list.width =  panelwidth*0.9;
			list.height =  panelheight *0.65;
			this.addChild(list);
			list.x = panelwidth*0.15;
			list.y = panelheight*0.27;
			
			container.x = Configrations.ViewPortWidth*0.05+panelwidth*0.05;
			container.y = Configrations.ViewPortHeight*0.05+panelheight*0.35;
		}
		
		
		
		private function closeButton_triggeredHandler(e:Event):void
		{
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