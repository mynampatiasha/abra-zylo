<?php
class ModelMobikulWalkthrough extends Model
{

	public function getWalkthrough($data = array(), $total = false)
	{

		$sql = "SELECT * FROM `" . DB_PREFIX . "mobikul_walkthrough` w where id != '' ";


		if (isset($data['filter_title'])) {
			$sql .= " AND w.title LIKE '%" . $data['filter_title'] . "%'";
		}

		if (isset($data['filter_status'])) {
			$sql .= " AND w.status='" . $data['filter_status'] . "'";
		}


		if (isset($data['sort']) && $data['sort']) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY w.sort_order";
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
	public function getwalkthroughById($id)
	{

		$walkthrough = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_walkthrough  where id = " . $id)->row;
		if ($walkthrough) {
			return $walkthrough;
		} else {
			return array();
		}
	}

	public function addwalkthrough($data = array())
	{

		$sql = "INSERT INTO " . DB_PREFIX . "mobikul_walkthrough SET image = '" . $data['image'] . "', title = '" . $data['title'] .  "', description = '" . $data['description']  .  "', status = '" . $data['status'] . "', sort_order = '" . $data['sort_order'] .  "'";

		$walkthrough = $this->db->query($sql);
		if ($walkthrough) {
			return true;
		} else {
			return false;
		}
	}

	public function addwalkthroughById($id, $data = array())
	{

		$sql = "UPDATE " . DB_PREFIX . "mobikul_walkthrough SET image = '" . $data['image'] . "', title = '" . $data['title'] .  "', description = '" . $data['description']  .  "', status = '" . $data['status'] . "', sort_order = '" . $data['sort_order'] .  "' where id= " . $id;
		$walkthrough = $this->db->query($sql);
		if ($walkthrough) {
			return true;
		} else {
			return false;
		}
	}
	public function deleteCarousel($id)
	{
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_walkthrough WHERE id =" . $id);
	}
}
