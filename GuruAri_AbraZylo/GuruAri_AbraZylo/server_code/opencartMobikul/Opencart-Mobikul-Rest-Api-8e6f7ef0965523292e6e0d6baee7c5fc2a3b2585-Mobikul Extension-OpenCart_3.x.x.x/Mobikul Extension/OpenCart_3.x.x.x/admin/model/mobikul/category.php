<?php
class ModelMobikulCategory extends Model
{
	public function getCategories($data = array())
	{
		$sql = "SELECT cp.category_id AS category_id, mc.category_image, c1.image, mc.category_icon, GROUP_CONCAT(cd1.name ORDER BY cp.level SEPARATOR '&nbsp;&nbsp;&gt;&nbsp;&nbsp;') AS name, c1.parent_id FROM " . DB_PREFIX . "category_path cp LEFT JOIN " . DB_PREFIX . "category c1 ON (cp.category_id = c1.category_id) LEFT JOIN " . DB_PREFIX . "category c2 ON (cp.path_id = c2.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd1 ON (cp.path_id = cd1.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd2 ON (cp.category_id = cd2.category_id) LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON (cp.category_id = mc.category_id) WHERE cd1.language_id = '" . (int)$this->config->get('config_language_id') . "' AND cd2.language_id = '" . (int)$this->config->get('config_language_id') . "'";

		if (!empty($data['filter_name'])) {
			$sql .= " AND cd1.name LIKE '%" . $this->db->escape($data['filter_name']) . "%'";
		}

		$sql .= " GROUP BY cp.category_id";

		$sort_data = array(
			'name',
			'mc.category_image',
			'mc.category_icon'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY name";
		}

		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}

		if (isset($data['start']) || isset($data['limit'])) {
			if ($data['start'] < 0) {
				$data['start'] = 0;
			}

			if ($data['limit'] < 1) {
				$data['limit'] = 20;
			}

			$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
		}

		$query = $this->db->query($sql)->rows;

		if ($query) {
			foreach ($query as $result) {
				$sql = "SELECT cp.category_id AS category_id, mc.category_image, c1.image, mc.category_icon, GROUP_CONCAT(cd1.name ORDER BY cp.level SEPARATOR '&nbsp;&nbsp;&gt;&nbsp;&nbsp;') AS name, c1.parent_id FROM " . DB_PREFIX . "category_path cp LEFT JOIN " . DB_PREFIX . "category c1 ON (cp.category_id = c1.category_id) LEFT JOIN " . DB_PREFIX . "category c2 ON (cp.path_id = c2.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd1 ON (cp.path_id = cd1.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd2 ON (cp.category_id = cd2.category_id) LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON (cp.category_id = mc.category_id) WHERE cd1.language_id = '" . (int)$this->config->get('config_language_id') . "' AND cd2.language_id = '" . (int)$this->config->get('config_language_id') . "' AND cp.category_id=" . $result['category_id'];
				$query = $this->db->query($sql)->row;
				$category[] = array(
					"category_id" => $query['category_id'],
					"category_image" => $query['category_image'],
					"category_icon" => $query['category_icon'],
					"image" => $query['image'],
					"name" => $query['name'],
					"parent_id" => $query['parent_id']

				);
			}
			return $category;
		}

		return $query;
	}

	public function getTotalCategories($data = array(), $slab = false)
	{

		if ($slab == true) {
			$query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX . "category");
			return $query->row['total'];
		} else {

			$sql = "SELECT cp.category_id AS category_id, mc.category_image, c1.image, mc.category_icon, GROUP_CONCAT(cd1.name ORDER BY cp.level SEPARATOR '&nbsp;&nbsp;&gt;&nbsp;&nbsp;') AS name, c1.parent_id FROM " . DB_PREFIX . "category_path cp LEFT JOIN " . DB_PREFIX . "category c1 ON (cp.category_id = c1.category_id) LEFT JOIN " . DB_PREFIX . "category c2 ON (cp.path_id = c2.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd1 ON (cp.path_id = cd1.category_id) LEFT JOIN " . DB_PREFIX . "category_description cd2 ON (cp.category_id = cd2.category_id) LEFT JOIN " . DB_PREFIX . "mobikul_category mc ON (cp.category_id = mc.category_id) WHERE cd1.language_id = '" . (int)$this->config->get('config_language_id') . "' AND cd2.language_id = '" . (int)$this->config->get('config_language_id') . "'AND c1.status='1'";

			if (!empty($data['filter_name'])) {
				$sql .= " AND cd1.name LIKE '%" . $this->db->escape($data['filter_name']) . "%'";
			}

			$sql .= " GROUP BY cp.category_id";

			$query = $this->db->query($sql);
			return $query->num_rows;
		}
	}

	public function updateIcons($postData)
	{

		foreach ($postData as $data) {
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_category where category_id=" . $data['id']);
		}

		foreach ($postData as $data2) {
			$image_icon =  ($this->db->escape(html_entity_decode($data2['icon'])) == 'no_image.png') ? null :  $this->db->escape(html_entity_decode($data2['icon']));
			$image =  ($this->db->escape(html_entity_decode($data2['image'])) == 'no_image.png') ? null :  $this->db->escape(html_entity_decode($data2['image']));
			$sql = "INSERT INTO " . DB_PREFIX . "mobikul_category(`category_id`, `category_image`, `category_icon`) VALUES (" . $this->db->escape($data2['id']) . ",'" . $image . "','" . $image_icon . "')";

			$this->db->query($sql);
		}
	}
	public function delete($ids)
	{
		foreach ($ids as $id) {
			$sql = "DELETE FROM " . DB_PREFIX . "mobikul_category where category_id=" . $id;
			$this->db->query($sql);
		}
	}
}
