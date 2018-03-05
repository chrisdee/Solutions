<?php
/**
 * Send form page
 */
function rwpm_send()
{
	global $wpdb, $current_user;
	?>
<div class="wrap">
    <h2><?php _e( 'Send Private Message', 'pm4wp' ); ?></h2>
	<?php
	$option = get_option( 'rwpm_option' );
	if ( $_REQUEST['page'] == 'rwpm_send' && isset( $_POST['submit'] ) )
	{
		$error = false;
		$status = array();

		// Check if total pm of current user exceed limit
		$role = $current_user->roles[0];
		$sender = $current_user->user_login;
		$total = $wpdb->get_var( 'SELECT COUNT(*) FROM ' . $wpdb->prefix . 'pm WHERE `sender` = "' . $sender . '" OR `recipient` = "' . $sender . '"' );
		if ( ( $option[$role] != 0 ) && ( $total >= $option[$role] ) )
		{
			$error = true;
			$status[] = __( 'You have exceeded the limit of mailbox. Please delete some messages before sending another.', 'pm4wp' );
		}

		// Get input fields with no html tags and all are escaped
		$subject = strip_tags( $_POST['subject'] );
		$content = $_POST['content'] ;
		$recipient = $option['type'] == 'autosuggest' ? explode( ',', $_POST['recipient'] ) : $_POST['recipient'];
		$recipient = array_map( 'strip_tags', $recipient );

		// Allow to filter content
		$content = apply_filters( 'rwpm_content_send', $content );
		
		// Remove slash automatically in wp
		$subject = stripslashes( $subject );
		$content = stripslashes( $content );
		$recipient = array_map( 'stripslashes', $recipient );

		// Escape sql
		$subject = esc_sql( $subject );
		$content = esc_sql( $content );
		$recipient = array_map( 'esc_sql', $recipient );

		// Remove duplicate and empty recipient
		$recipient = array_unique( $recipient );
		$recipient = array_filter( $recipient );
		
		// Check input fields
		if ( empty( $recipient ) )
		{
			$error = true;
			$status[] = __( 'Please enter username of recipient.', 'pm4wp' );
		}
		if ( empty( $subject ) )
		{
			$error = true;
			$status[] = __( 'Please enter subject of message.', 'pm4wp' );
		}
		if ( empty( $content ) )
		{
			$error = true;
			$status[] = __( 'Please enter content of message.', 'pm4wp' );
		}

		if ( !$error )
		{
			$numOK = $numError = 0;
			foreach ( $recipient as $rec )
			{
				// get user_login field
				$rec = $wpdb->get_var( "SELECT user_login FROM $wpdb->users WHERE display_name = '$rec' LIMIT 1" );
				$new_message = array(
					'id'        => NULL,
					'subject'   => $subject,
					'content'   => $content,
					'sender'    => $sender,
					'recipient' => $rec,
					'date'      => current_time( 'mysql' ),
					'read'      => 0,
					'deleted'   => 0
				);
				// insert into database
				if ( $wpdb->insert( $wpdb->prefix . 'pm', $new_message, array( '%d', '%s', '%s', '%s', '%s', '%s', '%d', '%d' ) ) )
				{
					$numOK++;
					unset( $_REQUEST['recipient'], $_REQUEST['subject'], $_REQUEST['content'] );

					// send email to user
					if ( $option['email_enable'] )
					{
						$sender = $wpdb->get_var( "SELECT display_name FROM $wpdb->users WHERE user_login = '$sender' LIMIT 1" );

						// replace tags with values
						$tags = array( '%BLOG_NAME%', '%BLOG_ADDRESS%', '%SENDER%', '%INBOX_URL%' );
						$replacement = array( get_bloginfo( 'name' ), get_bloginfo( 'admin_email' ), $sender, admin_url( 'admin.php?page=rwpm_inbox' ) );

						$email_name = str_replace( $tags, $replacement, $option['email_name'] );
						$email_address = str_replace( $tags, $replacement, $option['email_address'] );
						$email_subject = str_replace( $tags, $replacement, $option['email_subject'] );
						$email_body = str_replace( $tags, $replacement, $option['email_body'] );

						// set default email from name and address if missed
						if ( empty( $email_name ) )
							$email_name = get_bloginfo( 'name' );

						if ( empty( $email_address ) )
							$email_address = get_bloginfo( 'admin_email' );

						$email_subject = strip_tags( $email_subject );
						if ( get_magic_quotes_gpc() )
						{
							$email_subject = stripslashes( $email_subject );
							$email_body = stripslashes( $email_body );
						}
						$email_body = nl2br( $email_body );

						$recipient_email = $wpdb->get_var( "SELECT user_email from $wpdb->users WHERE display_name = '$rec'" );
						$mailtext = "<html><head><title>$email_subject</title></head><body>$email_body</body></html>";

						// set headers to send html email
						$headers = "To: $recipient_email\r\n";
						$headers .= "From: $email_name <$email_address>\r\n";
						$headers .= "MIME-Version: 1.0\r\n";
						$headers .= 'Content-Type: ' . get_bloginfo( 'html_type' ) . '; charset=' . get_bloginfo( 'charset' ) . "\r\n";

						wp_mail( $recipient_email, $email_subject, $mailtext, $headers );
					}
				}
				else
				{
					$numError++;
				}
			}

			$status[] = sprintf( _n( '%d message sent.', '%d messages sent.', $numOK, 'pm4wp' ), $numOK ) . ' ' . sprintf( _n( '%d error.', '%d errors.', $numError, 'pm4wp' ), $numError );
		}

		echo '<div id="message" class="updated fade"><p>', implode( '</p><p>', $status ), '</p></div>';
	}
	?>
	<?php do_action( 'rwpm_before_form_send' ); ?>
    <form method="post" action="" id="send-form" enctype="multipart/form-data">
	    <input type="hidden" name="page" value="rwpm_send" />
        <table class="form-table">
            <tr>
                <th><?php _e( 'Recipient', 'pm4wp' ); ?></th>
                <td>
					<?php
					// if message is not sent (by errors) or in case of replying, all input are saved

					$recipient = !empty( $_POST['recipient'] ) ? $_POST['recipient'] : ( !empty( $_GET['recipient'] )
						? $_GET['recipient'] : '' );

					// strip slashes if needed
					$subject = isset( $_REQUEST['subject'] ) ? ( get_magic_quotes_gpc() ? stripcslashes( $_REQUEST['subject'] )
						: $_REQUEST['subject'] ) : '';
					$subject = urldecode( $subject );  // for some chars like '?' when reply

					if ( empty( $_GET['id'] ) )
					{
						$content = isset( $_REQUEST['content'] ) ?  $_REQUEST['content']  : '';
					}
					else
					{
						$id = $_GET['id'];
						$msg = $wpdb->get_row( 'SELECT * FROM ' . $wpdb->prefix . 'pm WHERE `id` = "' . $id . '" LIMIT 1' );

						$content = '<p>&nbsp;</p>';
						$content .= '<p>---</p>';
						$content .= '<p><em>' . __( 'In: ', 'pm4wp' ) . $msg->date . "\t" . $msg->sender . __( ' Wrote:', 'pm4wp' ) . '</em></p>';
						$content .= wpautop( $msg->content );
						$content  = stripslashes( $content );
					}
					// if auto suggest feature is turned on
					if ( $option['type'] == 'autosuggest' )
					{
						?>
                        <input id="recipient" type="text" name="recipient" class="large-text" />
						<?php

					}
					else // classic way: select recipient from dropdown list
					{
						// Get all users of blog
						$args = array(
							'order'   => 'ASC',
							'orderby' => 'display_name' );
						$values = get_users( $args );
						$values = apply_filters( 'rwpm_recipients', $values );
						?>
						<select name="recipient[]" multiple="multiple" size="5">
							<?php
							foreach ( $values as $value )
							{
								$selected = ( $value->display_name == $recipient ) ? ' selected="selected"' : '';
								echo "<option value='$value->display_name'$selected>$value->display_name</option>";
							}
							?>
						</select>
						<?php
					}
					?>
                </td>
            </tr>
            <tr>
                <th><?php _e( 'Subject', 'pm4wp' ); ?></th>
                <td><input type="text" name="subject" value="<?php echo $subject; ?>" class="large-text" /></td>
            </tr>
            <tr>
                <th><?php _e( 'Content', 'pm4wp' ); ?></th>
                <th><?php  wp_editor( $content, 'rw-text-editor', $settings = array( 'textarea_name' => 'content' ) );?></th>
            </tr>
	        <?php do_action( 'rwpm_form_send' ); ?>
        </table>
	    <p class="submit"><input type="submit" value="Send" class="button-primary" id="submit" name="submit"></p>
    </form>
	<?php do_action( 'rwpm_after_form_send' ); ?>
</div>
<?php

}