<?php
global $wpdb;

// Drop PM table and plugin option when uninstall
$wpdb->query( "DROP table {$wpdb->prefix}pm" );
delete_option( 'rwpm_option' );