-- DumpTable : recursive print the passed table
function mc_dumptable( atable, intend )
		if ( intend == nil ) then intend = 1 end

		if ( atable ~= nil and type( atable )=="table" ) then
			for ItemField, FieldContent in pairs( atable ) do
				if type( FieldContent ) == "table" then
					mc_print( string.rep( "  ", intend ) .. ItemField .. " = " .. tostring( FieldContent ) .. " (" .. type( FieldContent ) .. ")" )
					mc_dumptable( FieldContent, intend + 1 );
				else
					mc_print( string.rep( "  ", intend ) .. ItemField .. " = " .. tostring( FieldContent ) .. " (" .. type( FieldContent ) .. ")" )
	  			end
			end
		end
end

function mc_print( OutString )
	if ( gEnableLog ~= nil and gEnableLog == "1" ) then
		d( tostring( OutString ) )		
	end
end

function mc_error( text )
	mc_print( "**ERROR**: " .. ( text ) )
	GUI_WindowMinimized("GW2Console",false)
	GUI_WindowVisible("GW2Console", true)	
end

mc_logstring = ""
function mc_log( arg )	
	if (type( arg ) == "boolean" and arg == true) then		
		mc_logstring = mc_logstring.."("..tostring(arg)..")::"
		return true
	elseif (type( arg ) == "boolean" and arg == false) then		
		mc_logstring = mc_logstring.."("..tostring(arg)..")::"
		return false
	elseif (type( arg ) == "string" and arg == "Running") then		
		mc_logstring = mc_logstring.."("..arg..")::"
		return "Running"
	else	
		mc_logstring = mc_logstring..arg
	end
	--d( debug.traceback())	
end

function mc_GetTraceString()
	local t = mc_logstring
	mc_logstring = ""
	return t
end