function rate = spike_rate( Vs, ts )	
	rate = zeros( size( ts ) );
	lastLoc = 1;
	for n = 2:length( rate )
		if Vs( n ) < 0 && Vs ( n-1 ) > 0
			rate( n ) = 1 / (ts( n ) - ts( lastLoc ));
			lastLoc = n;
		else
			rate( n ) = rate( n-1 );
		end
	end
end