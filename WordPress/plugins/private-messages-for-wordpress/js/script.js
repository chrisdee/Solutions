jQuery( document ).ready( function ( $ )
{

	/**
	 * Split string into multiple values, separated by commas
	 *
	 * @param val
	 *
	 * @return array
	 */
	function split( val )
	{
		return val.split( /,\s*/ );
	}

	/**
	 * Extract string Last into multiple values
	 * @param term
	 *
	 */
	function extract_last( term )
	{
		return split( term ).pop();
	}

	$( '#recipient' ).autocomplete( {
		source: function ( request, response )
		{
			var data = {
				action: 'rwpm_get_users',
				term  : extract_last( request.term )
			};
			$.post( ajaxurl, data, function ( r )
			{
				response( r );
			}, 'json' );
		},
		select: function ( event, ui )
		{
			var terms = split( this.value );
			terms.pop();
			terms.push( ui.item.value );
			terms.push( "" );
			this.value = terms.join( "," );
			return false;
		}
	} );

} );