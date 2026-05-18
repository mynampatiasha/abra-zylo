<?php
class ModelMobikulBanner extends Model
{

	public function getBanner($data = array(), $total = false)
	{

		$sql = "SELECT b.id,bd.title,b.status,b.type,b.image,b.sort_order FROM " . DB_PREFIX . "mobikul_banner b left join " .  DB_PREFIX . "mobikul_banner_description bd on (b.id=bd.id) where bd.language_id =" . $this->config->get('config_language_id');

		if (isset($data['filter_status'])) {
			$sql .= " AND b.status='" . $data['filter_status'] . "'";
		}
		if (isset($data['filter_title'])) {
			$sql .= " AND bd.title LIKE '%" . $data['filter_title'] . "%'";
		}

		if (isset($data['filter_id_from'])) {
			$sql .= " AND b.id >= " . $data['filter_id_from'];
		}
		if (isset($data['filter_id_to'])) {
			$sql .= " AND b.id <= " . $data['filter_id_to'];
		}
		if (isset($data['filter_type'])) {
			$sql .= " AND b.type='" . $data['filter_type'] . "'";
		}

		if (isset($data['sort']) && $data['sort']) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY b.id";
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
	public function getBannerById($id)
	{
		$banner_title_array = array();
		$return_array = array();
		$result = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_banner  where id = " . $id)->row;
		$title = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_banner_description where id = " . $id)->rows;


		if ($title) {
			foreach ($title as $banner_title) {
				$banner_title_array[$banner_title['language_id']] = $banner_title['title'];
			}
		}

		if ($result) {


			$return_array   =  array(
				"id" => $result["id"],
				"title" => $banner_title_array,
				"image" => $result["image"],
				"type" => $result["type"],				
				"pro_cat_id" => $result["pro_cat_id"],
				"pro_cat_name" => $result["name"],
				"sort_order" => $result["sort_order"],
				"status" => $result["status"],
			);
		}


		return $return_array;
	}

	public function addBanner($data = array())
	{

		$sql = "INSERT INTO " . DB_PREFIX . "mobikul_banner SET image = '" . $data['image'] . "', type = '" . $data['type'] .  "', pro_cat_id = '" . $data['pro_cat_id']   .  "', name = '" . $data['product_category'] .  "', sort_order = '" . $data['sort_order'] . "', status = '" . $data['status'] .  "'";
		$carousel_image = $this->db->query($sql);
		$carousel_image_id = $this->db->getLastId();

		if ($data['title'] &&  $carousel_image) {
			foreach ($data['title'] as $language_id => $title) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_banner_description SET id = '" .  $carousel_image_id . "', language_id = '" . $language_id . "', title = '" . $this->db->escape(html_entity_decode($title)) . "'";
				$this->db->query($sql);
			}
		}
	}

	public function addBannerById($id, $data = array())
	{

		$sql = "UPDATE " . DB_PREFIX . "mobikul_banner SET image = '" . $data['image'] . "', type = '" . $data['type'] .  "', pro_cat_id = '" . $data['pro_cat_id']  . "', name = '" . $data['product_category'] . "', status = '" . $data['status'] . "', sort_order = '" . $data['sort_order'] .  "' where id=" . $id;
		$carousel_image = $this->db->query($sql);

		if ($data['title'] &&  $carousel_image) {
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_banner_description WHERE id =" . $id);
			foreach ($data['title'] as $language_id => $title) {
				$sql = "INSERT INTO " . DB_PREFIX . "mobikul_banner_description SET id = '" .  $id . "', language_id = '" . $language_id . "', title = '" . $this->db->escape(html_entity_decode($title)) . "'";
				$this->db->query($sql);
			}
		}
	}
	public function deleteBanner($id)
	{
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_banner WHERE id =" . $id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_banner_description WHERE id =" . $id);
	}
}
