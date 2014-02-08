package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.AchieveListRender;

	public class AchievePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var list:List;
		public function AchievePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.68;
			var scale:Number = Configrations.ViewScale;

			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.scrollPositionVerticalAlign  = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.paddingTop =listLayout.paddingBottom =  30*scale;
			listLayout.gap = 10*scale;
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			var backG:Scale9Image = new Scale9Image(skintextures);
			this.addChild(backG);
			backG.width =  panelwidth*0.8;
			backG.height = panelheight *0.95 ;
			backG.x = panelwidth*0.1;
			backG.y =  10*scale;
			
			list = new List();
			list.layout = listLayout;
			list.dataProvider = menuArr;
			list.width =  panelwidth*0.8;
			list.height = panelheight *0.95 -20*scale;
			list.itemRendererFactory = 
				function tileListItemRendererFactory():AchieveListRender
			{
				const renderer:AchieveListRender = new AchieveListRender()
				renderer.width = panelwidth *0.7;
				renderer.height = Math.min(panelheight *0.2,100);
				return renderer;
			};
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.1;
			list.y = 20*scale;
			
			var achIcon:Image = new Image(Game.assets.getTexture("achieveIcon"));
			achIcon.width = achIcon.height = 80*scale;
			addChild(achIcon);
			achIcon.x =  achIcon.y = 0;
			
			var totalP:int = Configrations.getTotalAchievePoint(GameController.instance.currentPlayer.achieve);
			var countText:TextField = FieldController.createSingleLineDynamicField(300,300,"×"+totalP,0x000000,25,true);
			countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(countText);
			countText.x = achIcon.x + achIcon.width - countText.width/2;
			countText.y = achIcon.y + achIcon.height - countText.height;
		}
		
		private function get menuArr():ListCollection
		{
			var goupe:Object = SpecController.instance.getGroup("AchieveItem");
			var spec:ItemSpec;
			var array:Array = [];
			for each(spec in goupe){
				array.push({item_id:spec.item_id});
			}
			array.sortOn("item_id");
			return new ListCollection(array);
		}
	}
}