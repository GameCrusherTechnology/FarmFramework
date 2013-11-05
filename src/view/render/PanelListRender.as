package view.render
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.display.DisplayObject;
	
	import view.panel.ProfilePanel;
	
	public class PanelListRender extends DefaultListItemRenderer
	{
		public function PanelListRender()
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			var panel:DisplayObject ;
			if(value.name == "profile"){
				panel = new ProfilePanel();
			}
			addChild(panel);
		}
	}
}


