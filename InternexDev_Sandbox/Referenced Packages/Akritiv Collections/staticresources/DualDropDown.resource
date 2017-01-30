var dualSelect_TempObjSource, dualSelect_TempObjDestination;
var pattern = "%";
var dualSelect_Items = new Array();
var dualSelect_CheckedElement = new Array();

var showIsPrimaryOnPage = true;

function ShowText(obj,lblSelectedItemText)
{
	var objPrefix = "";
	var arrPrefix = obj.id.split(":");
	for(i = 0; i < arrPrefix.length - 1; i++)
		{
			objPrefix += arrPrefix[i]+":";
		}

	lblText = document.getElementById(objPrefix + lblSelectedItemText);
	lblText.innerHTML = "";
	for (var i = 0; i < obj.length; i ++)
		{
			if (obj[i].selected)
				{ 
					if(lblText.innerHTML == "")
					{
						lblText.innerHTML = obj[i].text ;	
					}
				}
		}
	
}

function dualSelect_SetFilter_OnAvailList(obj,objSource,objDestination)
{
		var objPrefix = "";
		var arrPrefix = obj.id.split(":");
		for(i = 0; i < arrPrefix.length - 1; i++)
		{
				objPrefix += arrPrefix[i]+":";
		}

		var sFilter = document.getElementById(objPrefix + "searchText").value; 
		objAvailList = document.getElementById(objPrefix + objSource);
		objSelectedList = document.getElementById(objPrefix + objDestination);

		if (sFilter != pattern)  //First Wildcard  - do not search
		{   
				var patternPos = 0;
				patternPos = sFilter.indexOf(pattern);


				if (patternPos >= 0)
				{  
						if (! dualSelect_IsElementChecked(objPrefix ))
								{
										dualSelect_FillItemsArray(objPrefix , objAvailList , objSelectedList );
								}

						dualSelect_ClearSelectList(objAvailList );
						if (sFilter.indexOf(pattern) == 0)
								{
										sFilter = sFilter.substring(1,sFilter.length);
								}  

						for (i = 0; i < dualSelect_Items.length; i ++)
						{                           
								if ((!dualSelect_Items[i].isSelected) && (dualSelect_Items[i].elementId == objPrefix ) && (dualSelect_Items[i].text.toLowerCase().indexOf(sFilter.toLowerCase()) >= 0))
								{                  
										objAvailList[objAvailList.length] = new Option(dualSelect_Items[i].text, dualSelect_Items[i].value);
								}   
						}
				}
				else
				{

						if (! dualSelect_IsElementChecked(objPrefix))
								{
										dualSelect_FillItemsArray(objPrefix , objAvailList , objSelectedList );
								}
						dualSelect_ClearSelectList(objAvailList );

						for (i = 0; i < dualSelect_Items.length; i ++)
						{
								if ((!dualSelect_Items[i].isSelected) && (dualSelect_Items[i].elementId == objPrefix ) && (dualSelect_Items[i].text.toLowerCase().indexOf(sFilter.toLowerCase()) == 0)) 
								{
									 objAvailList[objAvailList.length] = new Option(dualSelect_Items[i].text, dualSelect_Items[i].value);
								}   
						}
				}   
		}
}

function dualSelect_ClearSelectList(oSelect)
{
		while (oSelect.length != 0)
		{
				oSelect.remove(0);
		}
}

function dualSelect_IsElementChecked(objPrefix)
{
		for (var i = 0; i < dualSelect_CheckedElement.length; i++)
		{
				if (dualSelect_CheckedElement[i] == objPrefix) 
				{
						return true;
				}
		}
		return false;
}

function DualSelect_ListItem(elementId, text, value, isSelected)
{
		this.elementId = elementId;
		this.text = text;
		this.value = value;
		this.isSelected = isSelected;
}

function dualSelect_FillItemsArray(objPrefix , oAvailList, oSelectedList)
{
		var iLastIndex = dualSelect_Items.length;

		for (var i = 0; i < oAvailList.length; i++)
		{
				dualSelect_Items[iLastIndex] = new DualSelect_ListItem(objPrefix , oAvailList[i].text, oAvailList[i].value, false);
				iLastIndex ++;
		}

		for (var i = 0; i < oSelectedList.length; i ++)
		{
				dualSelect_Items[iLastIndex] = new DualSelect_ListItem(objPrefix , oSelectedList[i].text, oSelectedList[i].value, true);
				iLastIndex ++;
		}

		dualSelect_CheckedElement[dualSelect_CheckedElement.length] = objPrefix ;
}

function DualSelect_MoveElement(obj,TempObjSource,TempObjDestination,isSelected)
{
		try
		{
		var objPrefix = "";
		var arrPrefix  = obj.id.split(":");
		for(i = 0; i < arrPrefix.length - 1; i++)
		{
				objPrefix += arrPrefix[i]+":";
		}

		dualSelect_TempObjSource = document.getElementById(objPrefix + TempObjSource);
		dualSelect_TempObjDestination = document.getElementById(objPrefix + TempObjDestination);
		if (dualSelect_TempObjSource.length == 0)
		{
				return;
		}
		varTotalElements = 0;
		for (var i = 0; i < dualSelect_TempObjSource.length; i ++)
		{
			if (dualSelect_TempObjSource[i].selected)
			{
				varTotalElements = varTotalElements +1;
			}
			
		}
		
		if((dualSelect_TempObjDestination.length + varTotalElements ) > 200 && isSelected== true)
		{
			alert("Cannot add more than 200 items.Please select lesser items.");
			return false;
		}           


		iLast = 0;
		for (var i = 0; i < dualSelect_TempObjSource.length; i ++)
		{
			if (dualSelect_TempObjSource[i].selected)
				{
					
					iLast = i;
					var oNode = document.createElement("Option");
					oNode.text = dualSelect_TempObjSource[i].text;
					oNode.value = dualSelect_TempObjSource[i].value;
					dualSelect_TempObjSource.remove(i);
					nPos = (dualSelect_TempObjDestination.length + 1);
					dualSelect_TempObjDestination.options[nPos-1] = new Option(oNode.text, oNode.value);
					i --;
				}       
		}

		if (dualSelect_TempObjSource.length > 0 && iLast == 0)
		{
				dualSelect_TempObjSource.selectedIndex = 0;
		}
		else if (dualSelect_TempObjSource.length - 1 >= iLast)
		{
				dualSelect_TempObjSource.selectedIndex = iLast;
		}
		else if (dualSelect_TempObjSource.length >= 1)
		{
				dualSelect_TempObjSource.selectedIndex = iLast - 1;
		}

		DualSelect_ClearSelection(dualSelect_TempObjSource);
		dualSelect_TempObjSource.focus;
		if(dualSelect_TempObjDestination.length>0  && showIsPrimaryOnPage)
		{
                                                if(isSelected== true)
			{
				dualSelect_TempObjDestination.options[0].style.color = "red";
			}
			else
			{	if(dualSelect_TempObjSource.length>0)
				{
					dualSelect_TempObjSource.options[0].style.color = "red";
				}
            			}	
		}
		return false;
		}
		catch(e)
		{
				alert(e);
		}
}

function DualSelect_ClearSelection(oSelect)
{
		for (var i = 0; i < oSelect.length; i ++)
				oSelect[i].selected = false;
}

function MoveListItem(obj, TempObjSource, Direction) 
{
		var objPrefix="";
		var arrPrefix= obj.id.split(":");
		for(i=0;i<arrPrefix.length-1;i++)
		{
				objPrefix += arrPrefix[i]+":";
		}
		dualSelect_TempObjSource = document.getElementById(objPrefix + TempObjSource);
		var index = dualSelect_TempObjSource.selectedIndex;

		if (index == -1) 
		{   
				alert("You must first select the item to reorder.");
		}
		else 
		{
				var newIndex = index + ( Direction==true ? -1 : 1);
				if (newIndex < 0) 
				{
						newIndex = dualSelect_TempObjSource.length-1;
				}

				if (newIndex >= dualSelect_TempObjSource.length) 
				{
						newIndex = 0;
				}

				var ItemValue = dualSelect_TempObjSource[index].value;
				var ItemText = dualSelect_TempObjSource[index].text;
				var ItemClass = dualSelect_TempObjSource[index].className;

				// SWAP Items

				dualSelect_TempObjSource[index].value = dualSelect_TempObjSource[newIndex].value;
				dualSelect_TempObjSource[index].text = dualSelect_TempObjSource[newIndex].text;
				dualSelect_TempObjSource[index].className = dualSelect_TempObjSource[newIndex].className;

				dualSelect_TempObjSource[newIndex].value = ItemValue;
				dualSelect_TempObjSource[newIndex].text = ItemText;
				dualSelect_TempObjSource[newIndex].className = ItemClass;

				dualSelect_TempObjSource.selectedIndex = newIndex;
		}
		if(dualSelect_TempObjSource.length>0 && showIsPrimaryOnPage )
		{
			dualSelect_TempObjSource.options[0].style.color = "red";
            
		}
		return false;
}
function getMultiSelectedValues(TempObjSelected)
{
		try
		{
				dualSelect_TempObjSource = document.getElementById(TempObjSelected);
				var selectedNodes;
				if(dualSelect_TempObjSource.length>0)
				{
						selectedNodes = []; 
						for(var i = 0; i < dualSelect_TempObjSource.length;i++)
						{
								selectedNodes.push(dualSelect_TempObjSource[i].value);
						} 
				}
				else
				{
						selectedNodes ="";
				}
		}
		catch(e)
		{
				alert(e);
		}
		return selectedNodes;

}

function changePrimary(selectedList)
        {
            if(selectedList!= null && selectedList.length > 0 && showIsPrimaryOnPage )
            {
                selectedList.options[0].style.color = "red";
            }
        }
