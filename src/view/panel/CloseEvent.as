package view.panel
{
	import starling.events.Event;

	public class CloseEvent extends Event
	{
		public static var OK:String = "ok";
		public static var CANCEL:String = "cancel";
		public var closetype:String;
		public function CloseEvent(type:String)
		{
			closetype = type;
			super(Event.CLOSE);
		}
	}
}