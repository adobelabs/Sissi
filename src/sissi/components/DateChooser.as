package sissi.components
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	import sissi.core.UIComponent;
	import sissi.utils.DateUtil;
	
	public class DateChooser extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 * IUIComponent的宽度
		 * @return 
		 */		
		override public function get width():Number
		{
			return dateChooserCellWidth * 7;
		}
		override public function set width(value:Number):void
		{
		}
		/**
		 * IUIComponent的宽度
		 * @return 
		 */		
		override public function get height():Number
		{
			return sundayCellHeight + dateCellHeight * 6;
		}
		override public function set height(value:Number):void
		{
		}
		//----------------------------------
		// sundayTextFormat
		//----------------------------------
		private var sundayTextStyleChanged:Boolean;
		private var _sundayTextFormat:TextFormat;
		public function get sundayTextFormat():TextFormat
		{
			return _sundayTextFormat;
		}
		public function set sundayTextFormat(value:TextFormat):void
		{
			if(!value)
				return;
			_sundayTextFormat = value;
			sundayTextStyleChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//----------------------------------
		// dateOfThisMonthCellTextFormat
		//----------------------------------
		private var dateOfThisMonthCellTextStyleChanged:Boolean;
		private var _dateOfThisMonthCellTextFormat:TextFormat;
		public function get dateOfThisMonthCellTextFormat():TextFormat
		{
			return _dateOfThisMonthCellTextFormat;
		}

		public function set dateOfThisMonthCellTextFormat(value:TextFormat):void
		{
			if(!value)
				return;
			_dateOfThisMonthCellTextFormat = value;
			dateOfThisMonthCellTextStyleChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//----------------------------------
		// dateOfOtherMonthCellTextFormat
		//----------------------------------
		private var dateOfOtherMonthCellTextStyleChanged:Boolean;
		private var _dateOfOtherMonthCellTextFormat:TextFormat;
		public function get dateOfOtherMonthCellTextFormat():TextFormat
		{
			return _dateOfOtherMonthCellTextFormat;
		}
		
		public function set dateOfOtherMonthCellTextFormat(value:TextFormat):void
		{
			if(!value)
				return;
			_dateOfOtherMonthCellTextFormat = value;
			dateOfOtherMonthCellTextStyleChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}

		
		//----------------------------------
		//  firstDayOfWeek
		//----------------------------------
		/**
		 *  @private
		 *  Storage for the firstDayOfWeek property.
		 */
		private var _firstDayOfWeek:int = 0; // Sunday
		private var firstDayOfWeekChanged:Boolean = true;
		/**
		 *  星期的第一天指的是哪天。
		 * 0代表星期天
		 */
		public function get firstDayOfWeek():int
		{
			return _firstDayOfWeek;
		}
		/**
		 *  @private
		 */
		public function set firstDayOfWeek(value:int):void
		{
			if (value < 0 || value > 6)
				return;
			if (value == _firstDayOfWeek)
				return;
			_firstDayOfWeek = value;
			firstDayOfWeekChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * DateChooser
		 * @param dateChooserCellWidth 格子宽度
		 * @param sundayCellHeight 星期几高度
		 * @param dateCellHeight 日期高度
		 * @param hGap 横间隔
		 * @param vGap 竖间隔
		 */		
		public function DateChooser(dateChooserCellWidth:Number = 45, sundayCellHeight:Number = 20, dateCellHeight:Number = 30, hGap:Number = 0, vGap:Number = 0)
		{
			super();
			this.dateChooserCellWidth = dateChooserCellWidth;
			this.sundayCellHeight = sundayCellHeight;
			this.dateCellHeight = dateCellHeight;
			this.dateChooserHGap = hGap;
			this.dateChooserVGap = vGap;
		}
		private var dateChooserCellWidth:Number;
		private var sundayCellHeight:Number;
		private var dateCellHeight:Number;
		private var dateChooserHGap:Number;
		private var dateChooserVGap:Number;
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		/**
		 * 先进行元素生成。
		 * sundayCellGrid一直都有7个元素块，星期一到星期日只不过是值的改变。
		 * dateCellGrid的元素块一直都会有7*6共42块。
		 * 关于日期，一个星期有7天，一个月最多有31天，那么最大的星期范围有6，
		 * 也就是某个月的第一天是某星期的最后一天，那么加上紧接着的4个星期28天，已经29天，那么还有可能2天（最大31天），共牵扯到6个星期
		 */		
		override protected function createChildren():void
		{
			if(!sundayCellGrid)
			{
				sundayCellGrid = new UIComponent();
				sundayCellGrid.mouseEnabled = false;
				addChild(sundayCellGrid);
				
				createSundayCells();
			}
			if(!dateCellGrid)
			{
				dateCellGrid = new UIComponent();
				dateCellGrid.mouseEnabled = false;
				dateCellGrid.y = sundayCellGrid.y + sundayCellHeight;
				addChild(dateCellGrid);
				
				createDateCells();
			}
		}
		
		//--------------------------------------
		// 星期一到星期日相关
		//--------------------------------------
		/**
		 * 星期显示
		 */		
		private var sundayTxts:Array = ["日", "一", "二", "三", "四", "五", "六"];
		/**
		 * 放星期一到星期日的容器
		 */		
		private var sundayCellArray:Array;
		/**
		 * 放星期一到星期日的容器
		 */		
		private var sundayCellGrid:UIComponent;
		
		private function createSundayCells():void
		{
			sundayCellArray = [];
			for (var sundayIndex:int = 0; sundayIndex < 7; sundayIndex++)
			{
				var sundayItemRenderer:DisplayObject = new Label();
				sundayItemRenderer.width = dateChooserCellWidth;
				sundayItemRenderer.height = sundayCellHeight;
				sundayCellArray[sundayIndex] = sundayCellGrid.addChild(sundayItemRenderer);
				
				if(sundayIndex == 0)
					sundayItemRenderer.x = 0;
				else
					sundayItemRenderer.x = sundayIndex * (dateChooserCellWidth + dateChooserHGap);
			}
		}
		
		//--------------------------------------
		// 1-31的日期相关
		//--------------------------------------
		/**
		 * 1-31的日期容器
		 */		
		private var dateCellArray:Array;
		/**
		 * 1-31的日期容器
		 */		
		private var dateCellGrid:UIComponent;
		
		private function createDateCells():void
		{
			dateCellArray = [];
			// Calendar days
			for (var columnIndex:int = 0; columnIndex < 7; columnIndex++)
			{
				dateCellArray[columnIndex] = [];
				for (var rowIndex:int = 0; rowIndex < 6; rowIndex++)
				{
					var dateItemRenderer:Label = new Label();
					dateItemRenderer.setSize(dateChooserCellWidth, dateCellHeight);
					dateItemRenderer.text = "xxx"
					dateCellArray[columnIndex][rowIndex] = dateCellGrid.addChild(dateItemRenderer);
					
					if(columnIndex == 0)
						dateItemRenderer.x = 0;
					else
						dateItemRenderer.x = columnIndex * (dateChooserCellWidth + dateChooserHGap);
					if(rowIndex == 0)
						dateItemRenderer.y = 0;
					else
						dateItemRenderer.y = rowIndex * (dateCellHeight + dateChooserVGap);
				}
			}
		}
		
		override protected function commitProperties():void
		{
			if(firstDayOfWeekChanged)
			{
				setFirstDayOfWeek();
				
				firstDayOfWeekChanged = false;
			}
			var currentDate:Date = new Date();
			setSelectedMonthAndYear(currentDate.getFullYear(), currentDate.getMonth());
		}
		
		/**
		 * 设置星期几
		 */		
		private function setFirstDayOfWeek():void
		{
			var firstDay:int = _firstDayOfWeek;
			// Set up the days of the new month.
			for (var dayIndex:int = 0; dayIndex < 7; dayIndex++)
			{
				var sundayLabel:Label = sundayCellArray[dayIndex];
				if(!_sundayTextFormat)
				{
					sundayLabel.defaultTextFormat = new TextFormat("simsun", 12, null, true, null, null, null, null, "center");
				}
				else
				{
					sundayLabel.defaultTextFormat = _sundayTextFormat;
				}
				
				sundayLabel.text = firstDay >= 7 ? sundayTxts[firstDay - 7] : sundayTxts[firstDay];
				firstDay++;
			}
		}
		
		/**
		 * 设置当前的年月
		 * @param monthVal
		 * @param selectedMonth
		 */		
		private function setSelectedMonthAndYear(selectedYear:int, selectedMonth:int):void
		{
			var otherMonthTextFormat:TextFormat;
			if(_dateOfOtherMonthCellTextFormat)
				otherMonthTextFormat = _dateOfOtherMonthCellTextFormat;
			else
				otherMonthTextFormat = new TextFormat("simsun", 12, 0x888888, null, null, null, null, null, "right");
			
			var thisMonthTextFormat:TextFormat;
			if(_dateOfThisMonthCellTextFormat)
				thisMonthTextFormat = _dateOfThisMonthCellTextFormat;
			else
				thisMonthTextFormat = new TextFormat("simsun", 12, 0, null, null, null, null, null, "right");
			
//			var dayNumber:int; // 1 - 31
			var columnIndex:int; // 0 - 6
			var rowIndex:int; // 0 - 5
			
			var offset:int = getOffsetOfMonth(selectedYear, selectedMonth);
			
			//Previous Month
			//先前的一个月，可以根据offset来进行是否要判断
			if(offset > 0)
			{
				var previousMonthDate:Object = DateUtil.getNewIncrementDate(selectedYear, selectedMonth, 0, -1);
				var previousMonthDays:int = DateUtil.getNumberOfDaysInMonth(previousMonthDate.year, previousMonthDate.month);
				
				for (columnIndex = 0; columnIndex < offset; columnIndex++)
				{
					var previousMonthLabel:Label = dateCellArray[columnIndex][rowIndex];//this["dayBlock" + columnIndex+"label" + rowIndex];
					previousMonthLabel.text = previousMonthDays.toString();
					previousMonthLabel.defaultTextFormat = otherMonthTextFormat;
					previousMonthDays--;
					// Disable the day.
//					disabledArrays[columnIndex][rowIndex] = true;
					
//					removeSelectionIndicator(columnIndex,rowIndex);
				}
			}
			
			//Selected Month
			var selectedMonthDays:int = DateUtil.getNumberOfDaysInMonth(selectedYear, selectedMonth);
			var i:int;
			// Set up the days of the new month.
			for (var dayNumber:int = 1; dayNumber <= selectedMonthDays; dayNumber++)
			{
				var cellDate:Date = new Date(selectedYear, selectedMonth, dayNumber);
				i = offset + dayNumber - 1;
				columnIndex = i % 7;
				rowIndex = Math.floor(i / 7);
				
				var selectedMonthLabel:Label = dateCellArray[columnIndex][rowIndex];//this["dayBlock" + columnIndex+"label" + rowIndex];
				selectedMonthLabel.text = dayNumber.toString();
				selectedMonthLabel.defaultTextFormat = thisMonthTextFormat;
			}
			
			//Next Month
			var nextMonthDate:Object = DateUtil.getNewIncrementDate(selectedYear, selectedMonth, 0, 1);
			var nextMonthDays:int = DateUtil.getNumberOfDaysInMonth(nextMonthDate.year, nextMonthDate.month);
			var nextDay:int = 1;
			
			for (rowIndex; rowIndex < 6; rowIndex++)
			{
				for (columnIndex; columnIndex < 7; columnIndex++)
				{
					var nextMonthLabel:Label = dateCellArray[columnIndex][rowIndex];
					nextMonthLabel.text = nextDay.toString();
					nextMonthLabel.defaultTextFormat = otherMonthTextFormat;
					nextDay++;
				}
				columnIndex = 0;
			}
		}
		
		
		/**
		 * 偏移日
		 * @param year 年
		 * @param month 月
		 * @return 传入的当前月第一天是星期几与上个月的偏移日。
		 */		
		private function getOffsetOfMonth(year:int, month:int):int
		{
			// Determine whether the 1st of the month is a Sunday, Monday, etc.
			// and then determine which column of the grid where it appears.
			var first:Date = new Date(year, month, 1);
			var offset:int = first.getDay() - _firstDayOfWeek;
			return offset < 0 ? offset + 7 : offset;
		}
	}
}