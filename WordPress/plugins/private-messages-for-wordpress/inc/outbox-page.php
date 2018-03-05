<?php
/**
 * Outbox page
 */
function rwpm_outbox()
{
    global $wpdb, $current_user;

    // if view message
    if (isset($_GET['action']) && 'view' == $_GET['action'] && !empty($_GET['id'])) {
        $id = $_GET['id'];

        check_admin_referer("rwpm-view_outbox_msg_$id");

        // select message information
        $msg = $wpdb->get_row('SELECT * FROM ' . $wpdb->prefix . 'pm WHERE `id` = "' . $id . '" LIMIT 1');
        $msg->recipient = $wpdb->get_var("SELECT display_name FROM $wpdb->users WHERE user_login = '$msg->recipient'");
        ?>
    <div class="wrap">
        <h2><?php _e('Outbox \ View Message', 'pm4wp'); ?></h2>

        <p><a href="?page=rwpm_outbox"><?php _e('Back to outbox', 'pm4wp'); ?></a></p>
        <table class="widefat fixed" cellspacing="0">
            <thead>
            <tr>
                <th class="manage-column" width="20%"><?php _e('Info', 'pm4wp'); ?></th>
                <th class="manage-column"><?php _e('Message', 'pm4wp'); ?></th>
                <th class="manage-column" width="15%"><?php _e('Action', 'pm4wp'); ?></th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><?php printf(__('<b>Recipient</b>: %s<br /><b>Date</b>: %s', 'pm4wp'), $msg->recipient, $msg->date); ?></td>
                <td><?php printf(__('<p><b>Subject</b>: %s</p><p>%s</p>', 'pm4wp'), stripcslashes($msg->subject), nl2br(stripcslashes($msg->content))); ?></td>
                <td>
						<span class="delete">
							<a class="delete"
                               href="<?php echo wp_nonce_url("?page=rwpm_outbox&action=delete&id=$msg->id", 'rwpm-delete_outbox_msg_' . $msg->id); ?>"><?php _e('Delete', 'pm4wp'); ?></a>
						</span>
                </td>
            </tr>
            </tbody>
            <tfoot>
            <tr>
                <th class="manage-column" width="20%"><?php _e('Info', 'pm4wp'); ?></th>
                <th class="manage-column"><?php _e('Message', 'pm4wp'); ?></th>
                <th class="manage-column" width="15%"><?php _e('Action', 'pm4wp'); ?></th>
            </tr>
            </tfoot>
        </table>
    </div>
    <?php
        // don't need to do more!
        return;
    }

    // if delete message
    if (isset($_GET['action']) && 'delete' == $_GET['action'] && !empty($_GET['id'])) {
        $id = $_GET['id'];

        if (!is_array($id)) {
            check_admin_referer("rwpm-delete_outbox_msg_$id");
            $id = array($id);
        } else {
            check_admin_referer("rwpm-bulk-action_outbox");
        }
        $error = false;
        foreach ($id as $msg_id) {
            // check if the recipient has deleted this message
            $recipient_deleted = $wpdb->get_var('SELECT `deleted` FROM ' . $wpdb->prefix . 'pm WHERE `id` = "' . $msg_id . '" LIMIT 1');
            // create corresponding query for deleting message
            if ($recipient_deleted == 2) {
                $query = 'DELETE from ' . $wpdb->prefix . 'pm WHERE `id` = "' . $msg_id . '"';
            } else {
                $query = 'UPDATE ' . $wpdb->prefix . 'pm SET `deleted` = "1" WHERE `id` = "' . $msg_id . '"';
            }

            if (!$wpdb->query($query)) {
                $error = true;
            }
        }
        if ($error) {
            $status = __('Error. Please try again.', 'pm4wp');
        } else {
            $status = _n('Message deleted.', 'Messages deleted.', count($id), 'pm4wp');
        }
    }

    // show all messages
    $msgs = $wpdb->get_results('SELECT `id`, `recipient`, `subject`, `date` FROM ' . $wpdb->prefix . 'pm WHERE `sender` = "' . $current_user->user_login . '" AND `deleted` != 1 ORDER BY `date` DESC');
    ?>
<div class="wrap">
    <h2><?php _e('Outbox', 'pm4wp'); ?></h2>
    <?php
    if (!empty($status)) {
        echo '<div id="message" class="updated fade"><p>', $status, '</p></div>';
    }
    if (empty($msgs)) {
        echo '<p>', __('You have no items in outbox.', 'pm4wp'), '</p>';
    } else {
        $n = count($msgs);
        echo '<p>', sprintf(_n('You wrote %d private message.', 'You wrote %d private messages.', $n, 'pm4wp'), $n), '</p>';
        ?>
        <form action="" method="get">
            <?php wp_nonce_field('rwpm-bulk-action_outbox'); ?>
            <input type="hidden" name="action" value="delete"/> <input type="hidden" name="page" value="rwpm_outbox"/>

            <div class="tablenav">
                <input type="submit" class="button-secondary" value="<?php _e('Delete Selected', 'pm4wp'); ?>"/>
            </div>

            <table class="widefat fixed" cellspacing="0">
                <thead>
                <tr>
                    <th class="manage-column check-column"><input type="checkbox"/></th>
                    <th class="manage-column" width="10%"><?php _e('Recipient', 'pm4wp'); ?></th>
                    <th class="manage-column"><?php _e('Subject', 'pm4wp'); ?></th>
                    <th class="manage-column" width="20%"><?php _e('Date', 'pm4wp'); ?></th>
                </tr>
                </thead>
                <tbody>
                    <?php
                    foreach ($msgs as $msg) {
                        $msg->recipient = $wpdb->get_var("SELECT display_name FROM $wpdb->users WHERE user_login = '$msg->recipient'");
                        ?>
                    <tr>
                        <th class="check-column"><input type="checkbox" name="id[]" value="<?php echo $msg->id; ?>"/>
                        </th>
                        <td><?php echo $msg->recipient; ?></td>
                        <td>
                            <?php
                            echo '<a href="', wp_nonce_url("?page=rwpm_outbox&action=view&id=$msg->id", 'rwpm-view_outbox_msg_' . $msg->id), '">', stripcslashes($msg->subject), '</a>';
                            ?>
                            <div class="row-actions">
							<span>
								<a href="<?php echo wp_nonce_url("?page=rwpm_outbox&action=view&id=$msg->id", 'rwpm-view_outbox_msg_' . $msg->id); ?>"><?php _e('View', 'pm4wp'); ?></a>
							</span>
							<span class="delete">
								| <a class="delete"
                                     href="<?php echo wp_nonce_url("?page=rwpm_outbox&action=delete&id=$msg->id", 'rwpm-delete_outbox_msg_' . $msg->id); ?>"><?php _e('Delete', 'pm4wp'); ?></a>
							</span>
                            </div>
                        </td>
                        <td><?php echo $msg->date; ?></td>
                    </tr>
                        <?php

                    }
                    ?>
                </tbody>
                <tfoot>
                <tr>
                    <th class="manage-column check-column"><input type="checkbox"/></th>
                    <th class="manage-column"><?php _e('Recipient', 'pm4wp'); ?></th>
                    <th class="manage-column"><?php _e('Subject', 'pm4wp'); ?></th>
                    <th class="manage-column"><?php _e('Date', 'pm4wp'); ?></th>
                </tr>
                </tfoot>
            </table>
        </form>
        <?php

    }
    ?>
</div>
<?php
}
?>
