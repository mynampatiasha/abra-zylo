<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

class ModelExtensionModuleMobikul extends Model
{
    /**
     * Creates table for storing information regarding mobikul notifications and banners
     * @return null
     */
    public function createTable()
    {
        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_notification` (
			  `notification_id` INT(11) NOT NULL AUTO_INCREMENT,
			  `content` TEXT NOT NULL,
			  `type` INT(1) NOT NULL,
			  `status` INT(1) NOT NULL,
			  `name` VARCHAR(50) NOT NULL,
			  `pro_cat_id` INT(11) NOT NULL,
			  `date_added` DATETIME NOT NULL,
			  `image` VARCHAR(255) NOT NULL,
			  PRIMARY KEY (`notification_id`)
			) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_notification_description` (
			  `notification_id` INT(11) NOT NULL,
			  `title` VARCHAR(255) NOT NULL,
			  `language_id` INT(11) NOT NULL
			) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_banner` (
			`id` int(200) NOT NULL AUTO_INCREMENT,
			`image` varchar(250) NOT NULL,
			`type` varchar(200) NOT NULL,
			`pro_cat_id` int(200) NOT NULL,
			`name` varchar(255) NOT NULL,
			`status` int(10) NOT NULL,
			`sort_order` int(200) NOT NULL,
			PRIMARY KEY (`id`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_banner_description` (
			`id` int(200) NOT NULL,
			`language_id` int(10) NOT NULL,
			`title` varchar(200) NOT NULL
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_send` (
			  `send_id` INT(11) NOT NULL AUTO_INCREMENT,
			  `message_id` DECIMAL(21,0) NOT NULL,
			  `fields` TEXT NOT NULL,
			  `headers` TEXT NOT NULL,
			  `error` TEXT NOT NULL,
			  PRIMARY KEY (`send_id`)
			) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");

		$this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_featured_product` (
				`featured_id` INT(11) NOT NULL AUTO_INCREMENT,
				`product_id` INT(11) NOT NULL,
				PRIMARY KEY (`featured_id`)
		) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");


        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_customer_to_notification` (
			`customer_id` int(11) DEFAULT NULL,
			`android_device_id` varchar(255) DEFAULT NULL,
			`ios_device_id` varchar(255) DEFAULT NULL
			) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");

        $this->db->query("
			  CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_ar` (
			    `product_id` VARCHAR(200) NOT NULL,
			    `android_file` VARCHAR(200) DEFAULT NULL,
			    `ios_file` VARCHAR(200) DEFAULT NULL,
			    `status` INT(1) NOT NULL
			  ) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_category` (
			`category_id` int(11) NOT NULL,
			`category_image` varchar(250) DEFAULT NULL,
			`category_icon` varchar(255) DEFAULT NULL,
			PRIMARY KEY (`category_id`)
			) ENGINE=MyISAM DEFAULT COLLATE=utf8_general_ci;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_custom_collection` (
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`collection_type` varchar(250) DEFAULT NULL,
			`latest_count` int(11) DEFAULT NULL,
			`product_attribute` varchar(250) DEFAULT NULL,
			`price_from` int(11) DEFAULT NULL,
			`price_to` int(11) DEFAULT NULL,
			`manufacturer_id` varchar(250) DEFAULT NULL,
			`product_model` varchar(250) DEFAULT NULL,
			PRIMARY KEY (`id`)
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_custom_collection_description` (
			`id` int(11) NOT NULL,
			`language_id` int(11) NOT NULL,
			`name` varchar(250) DEFAULT NULL
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_custom_collection_to_product` (
			`id` int(11) NOT NULL,
			`product_id` int(11) NOT NULL
			  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        // carousel tables

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Id',
			`type` varchar(255) DEFAULT NULL COMMENT 'Type',
			`product_type` varchar(250) NOT NULL,
			`image_sub_type` varchar(200) NOT NULL,
			`status` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Status',
			`sort_order` int(10) unsigned NOT NULL COMMENT 'Sort Order',
			`image_ids` varchar(255) DEFAULT NULL COMMENT 'Selected Image',
			PRIMARY KEY (`id`)
			  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        $this->db->query("
			    CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_description` (
			`id` int(10) NOT NULL,
			`language_id` int(10) NOT NULL,
			`title` varchar(250) NOT NULL
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_image` (
			`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Id',
			`image` text COMMENT 'File Name',
			`type` varchar(255) DEFAULT NULL COMMENT 'Type',
			`pro_cat_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Product Category Id',
			`name` varchar(250) DEFAULT NULL,
			`status` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Status',
			PRIMARY KEY (`id`)
			  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_image_description` (
			`id` int(10) NOT NULL,
			`language_id` int(10) NOT NULL,
			`title` varchar(250) NOT NULL
			) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_to_categories` (
			`id` int(10) NOT NULL,
			`catagories_id` int(10) NOT NULL
			) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_to_image_id` (
			`id` int(20) NOT NULL,
			`image_id` int(20) NOT NULL
			) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_to_manufacturer` (
			`id` int(10) NOT NULL,
			`manufacturer_id` int(10) NOT NULL
			) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_carousel_to_product` (
			`id` int(10) NOT NULL,
			`product_id` int(10) NOT NULL
			) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        // carousel tables

        $this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_walkthrough` (
			`id` int(250) NOT NULL AUTO_INCREMENT,
			`image` varchar(250) NOT NULL,
			`title` varchar(250) NOT NULL,
			`description` longtext NOT NULL,
			`status` int(250) NOT NULL,
			`sort_order` int(250) NOT NULL,
			PRIMARY KEY (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

        $this->db->query("ALTER TABLE `" . DB_PREFIX . "order` ADD COLUMN `mobikul` INT(11) NOT NULL DEFAULT 0");

		// user icon and banner
		$this->db->query("
		CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_customer_image` (
		`id` int(250) NOT NULL AUTO_INCREMENT,
		`customer_id` int(10) NOT NULL,
		`image` varchar(250) NULL,
		`banner` varchar(250) NULL,
		`date_added` DATETIME NOT NULL,
		PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

		// product set as a new date
		$this->db->query("
		CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "mobikul_product_set_date` (
		`id` int(250) NOT NULL AUTO_INCREMENT,
		`product_id` int(10) NOT NULL,
		`start_date` DATE,
		`close_date` DATE,
		PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
    }
    /**
     * Deletes all the tables associated with mobikul on uninstallation of module
     * @return null
     */
    public function deleteTable()
    {
		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_featured_product`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_notification`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_notification_description`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_banner`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_banner_description`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_category`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_custom_collection`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_customer_to_notification`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_ar`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_custom_collection`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_custom_collection_description`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_custom_collection_to_product`;");

        // carousel tables
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_description`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_image`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_image_description`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_to_categories`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_to_image_id`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_to_manufacturer`;");
        $this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_carousel_to_product`;");
        // carousel tables

        $this->db->query("ALTER TABLE `" . DB_PREFIX . "order` DROP COLUMN mobikul ");

		// user icon and banner
		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_customer_image`;");

		// product set as a new date
		$this->db->query("DROP TABLE IF EXISTS `" . DB_PREFIX . "mobikul_product_set_date`;");
    }

    public function getExtensions($type = '')
    {
        return $this->db->query("SELECT code FROM " . DB_PREFIX . "extension WHERE `type` = '" . $this->db->escape($type) . "'")->rows;
    }
    public function getBannerName($id)
    {
        $sql = "SELECT title from " . DB_PREFIX . "mobikul_banner_description where id=" . $id . " AND language_id=" . $this->config->get('config_language_id');
        $query = $this->db->query($sql)->row;
        if (isset($query['title'])) {
            return $query['title'];
        } else {
            return '';
        }
    }
    public function getCarouselName($id)
    {
        $value = '';
        $sql = "SELECT c.id,cd.title,c.type,c.product_type,c.image_sub_type, c.status,c.sort_order FROM " . DB_PREFIX . "mobikul_carousel c left join " . DB_PREFIX . "mobikul_carousel_description cd on (c.id=cd.id) where cd.id=" . $id . " AND cd.language_id =" . $this->config->get('config_language_id');

        $results = $this->db->query($sql)->row;

        if ($results) {

            if (isset($results['type']) && $results['type'] && $results['type'] == 'Product' && isset($results['product_type']) && $results['product_type']) {

                $value = $results['product_type'];
            }

            if (isset($results['type']) && $results['type'] && $results['type'] == 'Image' && isset($results['image_sub_type']) && $results['image_sub_type']) {

                $value = $results['image_sub_type'];
            }

            $return_carousel = array(
                "id" => $results['id'],
                "title" => $results['title'],
                "value" => $value,
            );
        }

        return $return_carousel;
    }

    public function getConfigHome()
    {
        $value = '';
        $sql = "SELECT c.id,cd.title,c.type,c.product_type,c.image_sub_type, c.status,c.sort_order FROM " . DB_PREFIX . "mobikul_carousel c left join " . DB_PREFIX . "mobikul_carousel_description cd on (c.id=cd.id) where cd.language_id =" . $this->config->get('config_language_id');

        $results = $this->db->query($sql)->rows;

        if ($results) {

            foreach ($results as $result) {
                if (isset($result['type']) && $result['type'] && $result['type'] == 'Product' && isset($result['product_type']) && $result['product_type']) {

                    $value = $result['product_type'];
                }

                if (isset($result['type']) && $result['type'] && $result['type'] == 'Image' && isset($result['image_sub_type']) && $result['image_sub_type']) {

                    $value = $result['image_sub_type'];
                }

                $return_carousel[] = array(
                    "id" => $result['id'],
                    "title" => $result['title'],
                    "value" => $value,
                );
            }

            return $return_carousel;

        }

    }

}
