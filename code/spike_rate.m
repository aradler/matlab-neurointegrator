function rate = spike_rate( Vs, ts )
	[~, locs] = findpeaks( Vs );
	
	rate = zeros( size( ts ) );
	lastLoc = 0;
	for n = 2:length( rate )
		if any( locs == n )
			rate( n ) = 1 / (ts( n ) - ts( lastLoc ));
			lastLoc = n;
		else
			rate( n ) = rate( n-1 );
		end
	end
end