<?php
class ModelMobikulAR extends Model
{
	public function getArProduct($product_id = 0)
	{
		$result = $this->db->query("SELECT p.product_id,pd.name,ma.*,p.image FROM " . DB_PREFIX . "mobikul_ar ma LEFT JOIN " . DB_PREFIX . "product p ON (ma.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id) WHERE ma.product_id='" . $this->db->escape($product_id) . "'");

		if ($result->num_rows) {
			return $result->row;
		}
	}

	public function updateAR($data = array())
	{
		$is_exist = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_ar WHERE product_id = '" . $this->db->escape($data['product_id']) . "'")->num_rows;
		if ($is_exist) {
			$this->db->query("UPDATE " . DB_PREFIX . "mobikul_ar SET android_file = '" . $this->db->escape($data['android_file']) . "', ios_file = '" . $this->db->escape($data['ios_file']) . "', status='" . $this->db->escape($data['status']) . "' WHERE product_id = '" . $this->db->escape($data['product_id']) . "'");
		} else {
			$this->db->query("INSERT INTO " . DB_PREFIX . "mobikul_ar SET product_id = '" . $this->db->escape($data['product_id']) . "', android_file = '" . $this->db->escape($data['android_file']) . "', ios_file = '" . $this->db->escape($data['ios_file']) . "', status='" . $this->db->escape($data['status']) . "'");
		}
	}

	public function getArProducts($data = array())
	{
		$sql = "SELECT p.product_id,pd.name,ma.*,p.image FROM " . DB_PREFIX . "mobikul_ar ma LEFT JOIN " . DB_PREFIX . "product p ON (ma.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id)";

		$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";

		if (!empty($data['filter_name'])) {
			$sql .= " AND pd.name LIKE '" . $this->db->escape($data['filter_name']) . "%'";
		}

		if (isset($data['filter_ios_file']) && !is_null($data['filter_ios_file'])) {
			$sql .= " AND ma.ios_file LIKE '%" . $this->db->escape($data['filter_ios_file']) . "%'";
		}

		if (isset($data['filter_android_file']) && !is_null($data['filter_android_file'])) {
			$sql .= " AND ma.android_file LIKE '%" . (int)$data['filter_android_file'] . "%'";
		}

		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$sql .= " AND ma.status = '" . (int)$data['filter_status'] . "'";
		}

		$sql .= " GROUP BY p.product_id";

		$sort_data = array(
			'p.product_id',
			'pd.name',
			'ma.android_file',
			'ma.ios_file',
			'ma.status'
		);

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY pd.name";
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

		$query = $this->db->query($sql);

		return $query->rows;
	}

	public function getTotalArProducts($data = array())
	{
		$sql = "SELECT COUNT(DISTINCT p.product_id) AS total FROM " . DB_PREFIX . "mobikul_ar ma LEFT JOIN " . DB_PREFIX . "product p ON (ma.product_id = p.product_id) LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id)";

		$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "'";

		if (!empty($data['filter_name'])) {
			$sql .= " AND pd.name LIKE '" . $this->db->escape($data['filter_name']) . "%'";
		}

		if (isset($data['filter_ios_file']) && !is_null($data['filter_ios_file'])) {
			$sql .= " AND ma.ios_file LIKE '%" . $this->db->escape($data['filter_ios_file']) . "%'";
		}

		if (isset($data['filter_android_file']) && !is_null($data['filter_android_file'])) {
			$sql .= " AND ma.android_file LIKE '%" . (int)$data['filter_android_file'] . "%'";
		}

		if (isset($data['filter_status']) && !is_null($data['filter_status'])) {
			$sql .= " AND ma.status = '" . (int)$data['filter_status'] . "'";
		}

		$query = $this->db->query($sql);

		return $query->row['total'];
	}

	public function deleteProduct($product_id)
	{
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_ar WHERE product_id = '" . (int)$this->db->escape($product_id) . "'");
	}

	public function getProducts($data = array())
	{
		$sql = "SELECT * FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_description pd ON (p.product_id = pd.product_id)";

		$sql .= " WHERE pd.language_id = '" . (int)$this->config->get('config_language_id') . "' AND p.product_id NOT IN(SELECT product_id FROM " . DB_PREFIX . "mobikul_ar)";

		if (!empty($data['filter_name'])) {
			$sql .= " AND pd.name LIKE '" . $this->db->escape($data['filter_name']) . "%'";
		}

		$sql .= " GROUP BY p.product_id";

		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY pd.name";
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

		$query = $this->db->query($sql);

		return $query->rows;
	}
}
