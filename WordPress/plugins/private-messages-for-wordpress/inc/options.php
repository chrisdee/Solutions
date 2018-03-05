<?php
add_action( 'admin_init', 'rwpm_init' );
add_action( 'admin_menu', 'rwpm_add_menu' );
/**
 * Register plugin option
 *
 * @return void
 */
function rwpm_init()
{
	register_setting( 'rwpm_option_group', 'rwpm_option' );
}

/**
 * Add Option page and PM Menu
 *
 * @return void
 */
function rwpm_add_menu()
{
	global $wpdb, $current_user;

	// Get number of unread messages
	$num_unread = $wpdb->get_var( 'SELECT COUNT(`id`) FROM ' . $wpdb->prefix . 'pm WHERE `recipient` = "' . $current_user->user_login . '" AND `read` = 0 AND `deleted` != "2"' );

	if ( empty( $num_unread ) )
		$num_unread = 0;

	// Option page
	add_options_page( __( 'Private Messages Options', 'pm4wp' ), __( 'Private Messages', 'pm4wp' ), 'manage_options', 'rwpm_option', 'rwpm_option_page' );

	// Add Private Messages Menu
	$icon_url = PM4WP_URL . 'icon.png';
	add_menu_page( __( 'Private Messages', 'pm4wp' ), __( 'Messages', 'pm4wp' ) . "<span class='update-plugins count-$num_unread'><span class='plugin-count'>$num_unread</span></span>", 'read', 'rwpm_inbox', 'rwpm_inbox', $icon_url );

	// Inbox page
	$inbox_page = add_submenu_page( 'rwpm_inbox', __( 'Inbox', 'pm4wp' ), __( 'Inbox', 'pm4wp' ), 'read', 'rwpm_inbox', 'rwpm_inbox' );
	add_action( "admin_print_styles-{$inbox_page}", 'rwpm_admin_print_styles_inbox' );

	// Outbox page
	$outbox_page = add_submenu_page( 'rwpm_inbox', __( 'Outbox', 'pm4wp' ), __( 'Outbox', 'pm4wp' ), 'read', 'rwpm_outbox', 'rwpm_outbox' );
	add_action( "admin_print_styles-{$outbox_page}", 'rwpm_admin_print_styles_outbox' );

	// Send page
	$send_page = add_submenu_page( 'rwpm_inbox', __( 'Send Private Message', 'pm4wp' ), __( 'Send', 'pm4wp' ), 'read', 'rwpm_send', 'rwpm_send' );
	add_action( "admin_print_styles-{$send_page}", 'rwpm_admin_print_styles_send' );
}

/**
 * Enqueue scripts and styles for inbox page
 *
 * @return void
 */
function rwpm_admin_print_styles_inbox()
{
	do_action( 'rwpm_print_styles', 'inbox' );
}

/**
 * Enqueue scripts and styles for outbox page
 *
 * @return void
 */
function rwpm_admin_print_styles_outbox()
{
	do_action( 'rwpm_print_styles', 'outbox' );
}

/**
 * Enqueue scripts and styles for send page
 *
 * @return void
 */
function rwpm_admin_print_styles_send()
{
    wp_enqueue_style( 'jquery-ui', 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css' );
	wp_enqueue_style( 'rwpm_css', PM4WP_CSS_URL . 'style.css' );
	wp_enqueue_script( 'rwpm_js', PM4WP_JS_URL . 'script.js', array( 'jquery-ui-autocomplete' ) );

	do_action( 'rwpm_print_styles', 'send' );
}

/**
 * Option page
 * Change number of PMs for each group
 */
function rwpm_option_page() {
	?>
<div class="wrap">
	<h2><?php _e( 'Private Messages Options', 'pm4wp' ); ?></h2>

	<div style="width:600px;float:left">
		<form method="post" action="options.php">

			<?php
			settings_fields( 'rwpm_option_group' );
			$option = get_option( 'rwpm_option' );

			if ( empty( $option['hide_update'] ) ) {
				echo '<div class="updated">',
				'<p><strong>', __( '1. The plugin goes with a page template for front-end usage.', 'pm4wp' ), '</strong></p>',
				'<p>', __( 'Copy file <code>pm4wp-template.php</code> to your theme folder and create a page with template <code>Private Messages</code>', 'pm4wp' ), '</p>',
				'<p>', __( 'The template is just the backbone. You should modify it to fit your theme.', 'pm4wp' ), '</p>',
				'<p></p><p><strong>', __( '2. You can send to multiple recipients now.', 'pm4wp' ), '</strong></p>',
				'</div>';
				echo '<input type="checkbox" name="rwpm_option[hide_update]"> ', __( 'Don\'t show this message next time', 'pm4wp' );
			}

			echo '<h3>', __( 'Please set numbers of private messages for each user role:', 'pm4wp' ), '</h3>';
			echo '<p>', __( '<b><i>0</i></b> means <b><i>unlimited</i></b>', 'pm4wp' ), '</p>';
			echo '<p>', __( '<b><i>-1</i></b> means <b><i>not allowed</i></b> to send PM', 'pm4wp' ), '</p>';


			?>
			<table class="form-table">
				<tr>
					<th><?php _e( 'Administrator', 'pm4wp' ); ?></th>
					<td>
						<input type="text" name="rwpm_option[administrator]" value="<?php echo $option['administrator']; ?>"/>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'Editor', 'pm4wp' ); ?></th>
					<td><input type="text" name="rwpm_option[editor]" value="<?php echo $option['editor']; ?>"/></td>
				</tr>
				<tr>
					<th><?php _e( 'Author', 'pm4wp' ); ?></th>
					<td><input type="text" name="rwpm_option[author]" value="<?php echo $option['author']; ?>"/></td>
				</tr>
				<tr>
					<th><?php _e( 'Contributor', 'pm4wp' ); ?></th>
					<td>
						<input type="text" name="rwpm_option[contributor]" value="<?php echo $option['contributor']; ?>"/>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'Subscriber', 'pm4wp' ); ?></th>
					<td><input type="text" name="rwpm_option[subscriber]" value="<?php echo $option['subscriber']; ?>"/>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'How do you want to choose recipient?', 'pm4wp' ); ?></th>
					<td>
						<input type="radio" name="rwpm_option[type]" value="dropdown" <?php if ( $option['type'] == 'dropdown' )
							echo 'checked="checked"'; ?> /><?php _e( 'Dropdown list', 'pm4wp' ); ?>
						<input type="radio" name="rwpm_option[type]" value="autosuggest" <?php if ( $option['type'] == 'autosuggest' )
							echo 'checked="checked"'; ?> /><?php _e( 'Auto suggest from user input', 'pm4wp' ); ?>
					</td>
				</tr>
			</table>

			<h3><?php _e( 'Email template:', 'pm4wp' ); ?></h3>

			<table class="form-table">
				<tr>
					<th><?php _e( 'Enable sending email when user receive new PM?', 'pm4wp' ); ?></th>
					<td>
						<input type="radio" name="rwpm_option[email_enable]" value="1" <?php if ( $option['email_enable'] )
							echo 'checked="checked"'; ?> /> <?php _e( 'Yes', 'pm4wp' ); ?>
						<input type="radio" name="rwpm_option[email_enable]" value="0" <?php if ( !$option['email_enable'] )
							echo 'checked="checked"'; ?> /> <?php _e( 'No', 'pm4wp' ); ?>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'From name (optional)', 'pm4wp' ); ?></th>
					<td><input type="text" name="rwpm_option[email_name]" value="<?php echo $option['email_name']; ?>"/>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'From email (optional)', 'pm4wp' ); ?></th>
					<td>
						<input type="text" name="rwpm_option[email_address]" value="<?php echo $option['email_address']; ?>"/>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'Subject', 'pm4wp' ); ?></th>
					<td>
						<input type="text" name="rwpm_option[email_subject]" value="<?php echo $option['email_subject']; ?>"/>
					</td>
				</tr>
				<tr>
					<th><?php _e( 'Body', 'pm4wp' ); ?></th>
					<td>
						<textarea name="rwpm_option[email_body]" rows="10" cols="50"><?php echo $option['email_body']; ?></textarea><br/>
						<?php _e( 'Allowed HTML tags: ', 'pm4wp' ); ?> a, br, b, i, u, img, ul, ol, li, hr
					</td>
				</tr>
				<tr>
					<th><strong><?php _e( 'Available tags', 'pm4wp' ); ?></strong></th>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<th>%BLOG_NAME%</th>
					<td><?php _e( 'Blog name', 'pm4wp' ) ?></td>
				</tr>
				<tr>
					<th>%BLOG_ADDRESS%</th>
					<td><?php _e( 'Email address of blog', 'pm4wp' ) ?></td>
				</tr>
				<tr>
					<th>%SENDER%</th>
					<td><?php _e( 'Sender name', 'pm4wp' ) ?></td>
				</tr>
				<tr>
					<th>%INBOX_URL%</th>
					<td><?php _e( 'URL of inbox', 'pm4wp' ) ?></td>
				</tr>
			</table>

			<p class="submit">
				<input type="submit" name="submit" class="button-primary" value="<?php _e( 'Save Changes', 'pm4wp' ) ?>"/>
			</p>

		</form>

	</div>
	<div style="width:200px;float:right;border:1px solid #ccc;padding:10px">
		<h3><?php _e( 'Donation', 'pm4wp' ); ?></h3>

		<p><?php _e( 'This plugin has cost me countless hours of work, if you use it, please donate a token of your appreciation!', 'pm4wp' ); ?></p>

		<a href="http://www.deluxeblogtips.com/donate" target="_blank"><img src="https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif" /></a>
	</div>
</div>
	<?php
}
