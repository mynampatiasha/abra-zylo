<?php
class ModelMobikulCarousels extends Model
{

	/**
	 * list all carosels
	 * @param array $data contains data regarding a carosels
	 */
	public function getcarousels($data = array(), $total = false)
	{
		$sql = "SELECT c.id,cd.title,c.type,c.status,c.sort_order FROM " . DB_PREFIX . "mobikul_carousel c left join " .  DB_PREFIX . "mobikul_carousel_description cd on (c.id=cd.id) where cd.language_id =" . $this->config->get('config_language_id');

		if (isset($data['filter_status'])) {
			$sql .= " AND c.status='" . $data['filter_status'] . "'";
		}
		if (isset($data['filter_title'])) {
			$sql .= " AND cd.title LIKE '%" . $data['filter_title'] . "%'";
		}
		if (isset($data['filter_id_from'])) {
			$sql .= " AND c.id >= " . $data['filter_id_from'];
		}
		if (isset($data['filter_id_to'])) {
			$sql .= " AND c.id <= " . $data['filter_id_to'];
		}
		if (isset($data['filter_type'])) {
			$sql .= " AND c.type='" . $data['filter_type'] . "'";
		}
		if (isset($data['filter_sort_order'])) {
			$sql .= " AND c.sort_order='" . $data['filter_sort_order'] . "'";
		}

		if (isset($data['sort'])) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY c.id";
		}

		if (isset($data['order'])) {
			$sql .= " " . $data['order'];
		} else {
			$sql .= " ASC";
		}

		if ($total) {

			$result = $this->db->query($sql)->num_rows;
			return $result;
		}
		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$result = $this->db->query($sql)->rows;

		return $result;
	}

	public function getcarouselsById($carousel_id)
	{

		$return_array = array();
		if ($carousel_id) {

			$sql = "SELECT c.id,cd.title,c.type,c.product_type, c.image_sub_type, c.status,c.sort_order FROM " . DB_PREFIX . "mobikul_carousel c left join " .  DB_PREFIX . "mobikul_carousel_description cd on (c.id=cd.id) where cd.language_id =" . $this->config->get('config_language_id') . " AND c.id=" .  (int)$carousel_id;

			$carousel = $this->db->query($sql)->row;


			$carousel_title_query = $this->db->query("Select * from " . DB_PREFIX . "mobikul_carousel_description where id=" . $carousel_id)->rows;

			$carousel_title = array();
			if ($carousel_title_query) {
				foreach ($carousel_title_query as $title) {
					$carousel_title[$title['language_id']] = $title['title'];
				}
			}

			if (!empty($carousel['image']) && $carousel['image']) {
				if (is_file(DIR_IMAGE . $carousel['image']))
					$image = $carousel['image'];
				else
					$image = 'no_image.png';
			} else {
				$image = 'no_image.png';
			}
			$this->load->model('tool/image');


			$return_array = array(
				"id" => $carousel['id'],
				"title" => $carousel_title,
				"type" => $carousel['type'],
				"image_sub_type" => $carousel['image_sub_type'],
				"product_type" => $carousel['product_type'],				
				"status" => $carousel['status'],
				"sort_order" => $carousel['sort_order'],
				"manufacturer" =>  $this->getManufacturerById($carousel_id),
				"catagories" =>  $this->getCategoriesById($carousel_id),
				"products" =>  $this->getProductById($carousel_id),
				"images" =>  $this->getImagesById($carousel_id),
			);
		}
		return $return_array;
	}


	public function getManufacturerById($carousel_id)
	{
		$sql = "SELECT ocm.manufacturer_id,ocm.name FROM `" . DB_PREFIX . "mobikul_carousel_to_manufacturer` cm LEFT JOIN " . DB_PREFIX . "manufacturer ocm on cm.manufacturer_id= ocm.manufacturer_id where id=" .  $carousel_id;

		$result = $this->db->query($sql)->rows;
		if ($result)
			return $result;
		else
			return $result;
	}
	public function getCategoriesById($carousel_id)
	{
		$sql = "SELECT mc.catagories_id,cd.name from " . DB_PREFIX . "mobikul_carousel_to_categories mc LEFT JOIN " . DB_PREFIX . "category_description cd on mc.catagories_id=cd.category_id WHERE cd.language_id='" .  $this->config->get('config_language_id')  . "' AND mc.id=" .  $carousel_id;

		$result = $this->db->query($sql)->rows;
		if ($result)
			return $result;
		else
			return $result;
	}

	public function getProductById($carousel_id)
	{
		$sql = "SELECT product_id FROM " . DB_PREFIX . "mobikul_carousel_to_product WHERE id=" . $carousel_id;
		$result = $this->db->query($sql)->rows;
		if ($result)
			return $result;
		else
			return $result;
	}

	public function getImagesById($carousel_id)
	{
		$sql = "SELECT image_id FROM " . DB_PREFIX . "mobikul_carousel_to_image_id WHERE id=" . $carousel_id;
		$result = $this->db->query($sql)->rows;
		if ($result)
			return $result;
		else
			return $result;
	}


	public function getcarouselImage($data = array(), $total = false)
	{

		$sql = "SELECT ci.id,cid.title,ci.status,ci.image FROM " . DB_PREFIX . "mobikul_banner ci left join " .  DB_PREFIX . "mobikul_banner_description cid on (ci.id=cid.id) where cid.language_id =" . $this->config->get('config_language_id');

		if (isset($data['filter_carousel_image_status'])) {
			$sql .= " AND ci.status='" . $data['filter_carousel_image_status'] . "'";
		}
		if (isset($data['filter_carousel_image_title'])) {
			$sql .= " AND cid.title='" . $data['filter_carousel_image_title'] . "'";
		}

		if (isset($data['filter_carousel_image_id_from'])) {
			$sql .= " AND ci.id >= " . $data['filter_carousel_image_id_from'];
		}
		if (isset($data['filter_carousel_image_id_to'])) {
			$sql .= " AND ci.id <= " . $data['filter_carousel_image_id_to'];
		}


		if (isset($data['sort']) && $data['sort']) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY ci.id";
		}

		if (isset($data['order']) && $data['order']) {
			$sql .= " " . $data['order'];
		} else {
			$sql .= " ASC";
		}

		if ($total) {

			$result = $this->db->query($sql)->num_rows;
			return $result;
		}

		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$result = $this->db->query($sql)->rows;

		return $result;
	}
	






	public function addcarousels($data = array())
	{
	
		$product_type =  (isset($data['product_type']) && $data['product_type']) ? $data['product_type'] : '';
		$status =  (isset($data['status']) && $data['status']) ? $data['status'] : 0;
		$sort_order =  (isset($data['sort_order']) && $data['sort_order']) ? $data['sort_order'] : 0;

		$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel SET type = '" . $data['type'] . "', product_type = '" . $product_type  . "', status = '" . $status . "', sort_order = '" . $sort_order . "'";
		$carousel = $this->db->query($sql);
		$carousel_id = $this->db->getLastId();

		if ($data['title'] &&  $carousel) {
			foreach ($data['title'] as $language_id => $title) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_description SET id = '" .  $carousel_id . "', language_id = '" . $language_id . "', title = '" .   $this->db->escape($title) . "'";
				$this->db->query($sql);
			}
		}
       if(isset($data['product_id'])){
		  if ($data['product_id'] &&  $carousel) {
			foreach ($data['product_id'] as $product_id) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_product SET id = '" .  $carousel_id . "', product_id = '" . $product_id . "'";
				$this->db->query($sql);
			}
		}
		}
		if(isset($data['manufacturer_id'])){
		if ($data['manufacturer_id']  && $data['type'] == 'Product' &&  $carousel) {

			foreach ($data['manufacturer_id'] as $manufacturer_id) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_manufacturer SET id = '" .  $carousel_id . "', manufacturer_id = '" . $manufacturer_id . "'";
				$this->db->query($sql);
			}
		}
	   }
	  if(isset($data['image_manufacturer_id'])){	
	   if ($data['image_manufacturer_id']  && $data['type'] == 'Image' &&  $carousel) {
		
			foreach ($data['image_manufacturer_id'] as $manufacturer_id) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_manufacturer SET id = '" .  $carousel_id . "', manufacturer_id = '" . $manufacturer_id . "'";
				$this->db->query($sql);
			}
		}
	}
	if(isset($data['catagories_id'])){
		if ($data['catagories_id'] && $data['type'] == 'Product' &&  $carousel) {
		
			foreach ($data['catagories_id'] as $catagories_id) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_categories SET id = '" .  $carousel_id . "', catagories_id = '" . $catagories_id . "'";
				$this->db->query($sql);
			}
		}
	}
		if(isset($data['image_catagories_id'])){
		if ($data['image_catagories_id'] && $data['type'] == 'Image' &&  $carousel) {
	
			foreach ($data['image_catagories_id'] as $catagories_id) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_categories SET id = '" .  $carousel_id . "', catagories_id = '" . $catagories_id . "'";
				$this->db->query($sql);
			}
		}
	   }

	   if(isset($data['image_catagories_id'])){
		if ($data['image_catagories_id'] &&  $carousel) {
			if(isset($data['carousels_image_id'])) {
			foreach ($data['carousels_image_id'] as $carousels_image_id) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_image_id SET id = '" .  $carousel_id . "', image_id = '" . $carousels_image_id . "'";
				$this->db->query($sql);
			}
		  }
		}
	  }
	
	}




	public function getPopularProduct($data = array(), $total = false)
	{
		$sql = "SELECT p.product_id,pd.name FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE p.status = '1'  AND pd.language_id='" . $this->config->get('config_language_id') .  "' AND p.date_available <= NOW() AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "'";
		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql .=  " ORDER BY p.viewed DESC, p.date_added DESC";

		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$query = $this->db->query($sql);

		if ($total) {
			return $query->num_rows;
		}

		$product_data = array();
		if ($query) {
			foreach ($query->rows as $result) {
				$product_data[] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		}

		return $product_data;
	}

	public function getBestProduct($data = array(), $total = false)
	{

		$sql = "SELECT op.product_id, SUM(op.quantity) AS total FROM " . DB_PREFIX . "order_product op LEFT JOIN `" . DB_PREFIX . "order` o ON (op.order_id = o.order_id) LEFT JOIN `" . DB_PREFIX . "product` p ON (op.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE o.order_status_id > '0' AND p.status = '1' AND pd.language_id='" . $this->config->get('config_language_id') .  "' AND p.date_available <= NOW() AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' GROUP BY op.product_id";

		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql .= " ORDER BY total DESC";
		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$query = $this->db->query($sql);

		if ($total) {
			return $query->num_rows;
		}

		$product_data = array();
		if ($query) {
			foreach ($query->rows as $result) {
				$product_data[] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		}

		return $product_data;
	}

	public function getLatestProduct($data = array(), $total = false)
	{

		$sql = "SELECT p.product_id FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE p.status = '1' AND pd.language_id='" . $this->config->get('config_language_id') .  "' AND p.date_available <= NOW() AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "'";

		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}

		$sql .= " ORDER BY p.date_added DESC";

		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$query = $this->db->query($sql);

		if ($total) {
			return $query->num_rows;
		}

		$product_data = array();
		if ($query) {
			foreach ($query->rows as $result) {
				$product_data[] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		}

		return $product_data;
	}
	public function getManufacturerProduct($data = array(), $total = false)
	{

		if (isset($data['manufacturer_id'])) {
			$manufacturer_id =  implode(",", $data['manufacturer_id']);
		} else {
			$manufacturer_id = null;
		}

		$sql = "SELECT * FROM `" . DB_PREFIX . "product` p LEFT JOIN " . DB_PREFIX . "manufacturer m on m.manufacturer_id=p.manufacturer_id LEFT JOIN  " . DB_PREFIX . "manufacturer_to_store m2s on m2s.manufacturer_id=m.manufacturer_id LEFT JOIN " . DB_PREFIX . "product_description pd on pd.product_id=p.product_id WHERE pd.language_id='" . $this->config->get('config_language_id') .  "' AND m2s.store_id = '" . $this->config->get('config_store_id') .  "' AND m.manufacturer_id IN (" .  $manufacturer_id   . ")";


		if (isset($data['filter_name'])) {
			$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
		}
		if (isset($data['filter_model'])) {
			$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
		}
		if (isset($data['filter_price'])) {
			$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
		}
		if (isset($data['filter_quantity'])) {
			$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
		}
		if (isset($data['filter_status'])) {
			$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
		}


		if ($total) {
			$query = $this->db->query($sql);
			return $query->num_rows;
		}
		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$query = $this->db->query($sql);



		$product_data = array();
		if ($query) {
			foreach ($query->rows as $result) {
				$product_data[] = $this->model_catalog_product->getProduct($result['product_id']);
			}
		}

		return $product_data;
	}


	public function getCatagoriesProduct($data = array(), $total = false)
	{


		$total_category_product_id = array();
		$product_data = array();

		if (isset($data['catagory_id']) && $data['catagory_id']) {
			$total_category_product_id  =  implode(",", $data['catagory_id']);

	
			$sql = sprintf("SELECT DISTINCT p.product_id 
			FROM %sproduct p
			LEFT JOIN %sproduct_description pd ON p.product_id = pd.product_id
			LEFT JOIN %sproduct_to_store p2s ON p2s.product_id = p.product_id
			LEFT JOIN %sproduct_to_category p2c ON p2c.product_id = p.product_id
			WHERE p2s.store_id = %d
			AND pd.language_id = %d
			AND p2c.category_id IN (%s)",
			DB_PREFIX,
			DB_PREFIX,
			DB_PREFIX,
			DB_PREFIX,
			(int)$this->config->get('config_store_id'),
			(int)$this->config->get('config_language_id'),
			$total_category_product_id);
			
		

			if (isset($data['filter_name'])) {
				$sql .=  " AND pd.name LIKE '%" . $data['filter_name'] . "%'";
			}
			if (isset($data['filter_model'])) {
				$sql .=  " AND p.model LIKE '%" . $data['filter_model'] . "%'";
			}
			if (isset($data['filter_price'])) {
				$sql .=  " AND p.price LIKE '%" . $data['filter_price'] . "%'";
			}
			if (isset($data['filter_quantity'])) {
				$sql .=  " AND p.quantity LIKE '%" . $data['filter_quantity'] . "%'";
			}
			if (isset($data['filter_status'])) {
				$sql .=  " AND p.status LIKE '%" . $data['filter_status'] . "%'";
			}




			if ($total) {
				$query = $this->db->query($sql);
				return $query->num_rows;
			}


			$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

			$query = $this->db->query($sql);
		
			if ($query) {
				foreach ($query->rows as $result) {
					$product_data[] = $this->model_catalog_product->getProduct($result['product_id']);
				}
			}
		}






		return $product_data;
	}

	public function addCarouselsById($data)
	{

		$product_ids = '';
		if (isset($data['product_id']) && $data['product_id']) {
			$product_ids = implode(",", $data['product_id']);
		} else {
			$product_ids = '';
		}

		$carousels_image_id = '';
		if (isset($data['carousels_image_id']) && $data['carousels_image_id']) {
			$carousels_image_id = implode(",", $data['carousels_image_id']);
		} else {
			$carousels_image_id = '';
		}

		if (isset($data['carousel_id']) && $data['carousel_id']) {
			$carousel_id = $data['carousel_id'];
		}

		$image =  (isset($data['image']) && $data['image']) ? $data['image'] : '';
		$color_code =  (isset($data['color_code']) && $data['color_code']) ? $data['color_code'] : '';
		$product_type =  (isset($data['product_type']) && $data['product_type']) ? $data['product_type'] : '';
		$status =  (isset($data['status']) && $data['status']) ? $data['status'] : 0;
		$sort_order =  (isset($data['sort_order']) && $data['sort_order']) ? $data['sort_order'] : 0;
		$image_sub_type =  (isset($data['image_sub_type']) && $data['image_sub_type']) ? $data['image_sub_type'] : '';

		if ($carousel_id) {

			$sql = "UPDATE " . DB_PREFIX . "mobikul_carousel SET type = '" . $data['type'] . "', product_type = '" . $product_type . "', status = '" . $status . "', image_sub_type = '" . $image_sub_type . "', sort_order = '" . $sort_order . "', image_ids = '" . $carousels_image_id . "' where id=" . $carousel_id;

			$carousel = $this->db->query($sql);

			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_description WHERE id =" . $carousel_id);

			if ($data['title'] &&  $carousel) {
				foreach ($data['title'] as $language_id => $title) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_description SET id = '" .  $carousel_id . "', language_id = '" . $language_id . "', title = '" .  $this->db->escape($title) . "'";
					$this->db->query($sql);
				}
			}
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_product WHERE id =" . $carousel_id);



			if (isset($data['saved_product_ids']) && $data['saved_product_ids'] && $data['type'] == 'Product' &&  $carousel) {
				if (!is_array($data['saved_product_ids'])) {
					$data['saved_product_ids'] = stripslashes(html_entity_decode($data['saved_product_ids']));
					$data['saved_product_ids'] = json_decode($data['saved_product_ids'], true);
				}


				foreach ($data['saved_product_ids'] as $product_id) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_product SET id = '" .  $carousel_id . "', product_id = '" . $product_id . "'";
					$this->db->query($sql);
				}
			}

			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_manufacturer WHERE id =" . $carousel_id);

			if (isset($data['manufacturer_id']) && $data['type'] == 'Product' &&  $carousel) {
				foreach ($data['manufacturer_id'] as $manufacturer_id) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_manufacturer SET id = '" .  $carousel_id . "', manufacturer_id = '" . $manufacturer_id . "'";
					$this->db->query($sql);
				}
			}
			if (isset($data['image_manufacturer_id'])  && $data['type'] == 'Image' &&  $carousel) {
				foreach ($data['image_manufacturer_id'] as $manufacturer_id) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_manufacturer SET id = '" .  $carousel_id . "', manufacturer_id = '" . $manufacturer_id . "'";
					$this->db->query($sql);
				}
			}
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_categories WHERE id =" . $carousel_id);
			if (isset($data['catagories_id']) && $data['type'] == 'Product' &&  $carousel) {
				foreach ($data['catagories_id'] as $catagories_id) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_categories SET id = '" .  $carousel_id . "', catagories_id = '" . $catagories_id . "'";
					$this->db->query($sql);
				}
			}

			if (isset($data['image_catagories_id']) && $data['type'] == 'Image' &&  $carousel) {
				foreach ($data['image_catagories_id'] as $catagories_id) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_categories SET id = '" .  $carousel_id . "', catagories_id = '" . $catagories_id . "'";
					$this->db->query($sql);
				}
			}
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_image_id WHERE id =" . $carousel_id);
			if (isset($data['saved_image_ids']) && $data['saved_image_ids']  && $data['type'] == 'Image' &&  $carousel) {
				if (!is_array($data['saved_image_ids'])) {
					$data['saved_image_ids'] = stripslashes(html_entity_decode($data['saved_image_ids']));
					$data['saved_image_ids'] = json_decode($data['saved_image_ids'], true);
				}

				foreach ($data['saved_image_ids'] as $carousels_image_id) {
					$sql = "INSERT INTO " . DB_PREFIX . "mobikul_carousel_to_image_id SET id = '" .  $carousel_id . "', image_id = '" .
						$carousels_image_id . "'";
					$this->db->query($sql);
				}
			}
		}
	}
	public function deleteCarousel($carousel_id)
	{
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel WHERE id =" . $carousel_id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_description WHERE id =" . $carousel_id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_categories WHERE id =" . $carousel_id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_manufacturer WHERE id =" . $carousel_id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_product WHERE id =" . $carousel_id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_carousel_to_image_id WHERE id =" . $carousel_id);
	}
}
