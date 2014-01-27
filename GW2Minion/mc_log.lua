-- DumpTable : recursive print the passed table
function mc_dumptable( atable, intend )
		if ( intend == nil ) then intend = 1 end

		if ( atable ~= nil and type( atable )=="table" ) then
			for ItemField, FieldContent in pairs( atable ) do
				if type( FieldContent ) == "table" then
					mc_debug( string.rep( "  ", intend ) .. ItemField .. " = " .. tostring( FieldContent ) .. " (" .. type( FieldContent ) .. ")" )
					mc_dumptable( FieldContent, intend + 1 );
				else
					mc_debug( string.rep( "  ", intend ) .. ItemField .. " = " .. tostring( FieldContent ) .. " (" .. type( FieldContent ) .. ")" )
	  			end
			end
		end
end

function mc_debug( OutString )
	if ( gEnableLog ~= nil and gEnableLog == "1" ) then
		d( tostring( OutString ) )		
	end
end

function mc_error( text )
	mc_debug( "**ERROR**: " .. tostring( text ) )
	GUI_WindowMinimized("GW2Console",false)
	GUI_WindowVisible("GW2Console", true)	
end
