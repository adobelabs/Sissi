package sissi.components
{
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sissi.core.UITextField;
	
	public class TextInput extends UITextField
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function TextInput(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super(textFormat, textStroke, textValue, isHTML);
			type = TextFieldType.INPUT;
			selectable = true;
			tabEnabled = true;
//			addEventListener(Event.CHANGE, textField_changeHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  LifeCycle
		//
		//--------------------------------------------------------------------------
		//------------------------------------------------
		//
		// createChildren
		//
		//------------------------------------------------
		//------------------------------------------------
		//
		// commitProperties
		//
		//------------------------------------------------
//		override protected function commitProperties():void
//		{
//			
//		}
		//------------------------------------------------
		//
		// updateDisplayList
		//
		//------------------------------------------------
//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//		{
//			
//		}
		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		public function setFous():void
		{
			if(stage)
			{
				stage.focus = this;
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  Only gets called on keyboard not programmatic setting of text.
		 */
//		private function textField_changeHandler(event:Event):void
//		{
//			// Stop this bubbling "change" event
//			// and dispatch another one that doesn't bubble.
//			event.stopImmediatePropagation();
//			dispatchEvent(new Event(Event.CHANGE));
//		}
	}
}