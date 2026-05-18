<?php
class ModelMobikulCustomcollection extends Model
{

	public function getLatestProducts($count = 10)
	{

		$queries = $this->db->query("SELECT p.product_id FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) WHERE p.status = '1' AND p.date_available <= NOW() AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "' ORDER BY p.date_added DESC LIMIT " . (int)$count)->rows;

		$data = array();
		if ($queries) {
			foreach ($queries as $key => $query) {
				$data[$key] = $query['product_id'];
			}
		}
		return $data;
	}

	public function getProductsByAttribute($attribute = 'price', $attribute_value = 100, $attribute_value_max = 100)
	{
		$sql = "";
		if ($attribute == 'model') {
			$sql = "p.model = '" . $attribute_value . "'";
		} elseif ($attribute == 'manufacturer') {
			$manufacturer = $this->db->query("SELECT DISTINCT manufacturer_id FROM " . DB_PREFIX . "manufacturer WHERE manufacturer_id = " . $attribute_value)->row;
			if (isset($manufacturer['manufacturer_id']) && $manufacturer['manufacturer_id']) {
				$sql = "p.manufacturer_id = '" . $manufacturer['manufacturer_id'] . "'";
			}
		} else {
			$sql = "p.price >= " . $attribute_value . " AND p.price <= " . $attribute_value_max;
		}


		$queries = $this->db->query("SELECT p.product_id FROM " . DB_PREFIX . "product p LEFT JOIN " . DB_PREFIX . "product_to_store p2s ON (p.product_id = p2s.product_id) WHERE p.status = '1' AND " . $sql . " AND p2s.store_id = '" . (int)$this->config->get('config_store_id') . "'")->rows;

		$data = array();
		if ($queries) {
			foreach ($queries as $key => $query) {
				$data[$key] = $query['product_id'];
			}
		}
		return $data;
	}

	public function getProductName($product_id)
	{
		return $this->db->query("SELECT name FROM " . DB_PREFIX . "product_description WHERE product_id = " . (int)$product_id)->row['name'];
	}

	public function addCollection($data)
	{

		$count = html_entity_decode($this->db->escape(!empty($data['latest_count']) ?  $data['latest_count'] : 'null'));
		$attribute = html_entity_decode($this->db->escape(!empty($data['product_attribute']) ? $data['product_attribute'] : 'null'));
		$latest_type = html_entity_decode($this->db->escape(!empty($data['collection_type']) ? $data['collection_type'] : 'null'));
		$price_from = html_entity_decode($this->db->escape(!empty($data['price_from']) ? $data['price_from'] : 'null'));
		$price_to = html_entity_decode($this->db->escape(!empty($data['price_to']) ? $data['price_to'] : 'null'));
		$manufacturer_id = html_entity_decode($this->db->escape(!empty($this->db->escape(html_entity_decode($data['manufacturer_id']))) ? $data['manufacturer_id'] : 'null'));
		$product_model = html_entity_decode($this->db->escape(!empty($this->db->escape(html_entity_decode($data['product_model']))) ? $this->db->escape(html_entity_decode($data['product_model'])) : 'null'));

		$sql = "INSERT INTO " . DB_PREFIX . "mobikul_custom_collection SET collection_type = '" . $latest_type . "', latest_count = " . $count . ", product_attribute = '" .  $attribute . "', price_from = " . $price_from . ", price_to = " . $price_to . ", manufacturer_id = '" . $manufacturer_id . "', product_model = '" . $product_model . "'";


		$this->db->query($sql);
		$last_id = $this->db->getLastId();

		if ($last_id) {

			foreach ($data['name'] as $language_id => $collection_names) {
				$sql2 =  "INSERT INTO " . DB_PREFIX . "mobikul_custom_collection_description SET id =" . $last_id . ", language_id = " . $language_id . ", name = '" . html_entity_decode($this->db->escape($data['name'][$language_id]['collection_name'])) . "'";

				$this->db->query($sql2);
			}
			foreach ($data['mobikul_customcollection_customcollection_product'] as $product_id) {
				$sql3 = "INSERT INTO " . DB_PREFIX . "mobikul_custom_collection_to_product SET id =" . $this->db->escape($last_id) . ", product_id = " . $this->db->escape($product_id);

				$this->db->query($sql3);
			}
		}
	}

	public function addCollectionById($id, $data)
	{
		$product_id = html_entity_decode($this->db->escape(implode(',', $data['mobikul_customcollection_customcollection_product'])));
		$count = html_entity_decode($this->db->escape(!empty($data['latest_count']) ?  $data['latest_count'] : 'null'));
		$attribute = html_entity_decode($this->db->escape(!empty($data['product_attribute']) ? $data['product_attribute'] : 'null'));
		$latest_type = html_entity_decode($this->db->escape(!empty($data['collection_type']) ? $data['collection_type'] : 'null'));
		$price_from = html_entity_decode($this->db->escape(!empty($data['price_from']) ? $data['price_from'] : 'null'));
		$price_to = html_entity_decode($this->db->escape(!empty($data['price_to']) ? $data['price_to'] : 'null'));
		$manufacturer_id = html_entity_decode($this->db->escape(!empty($this->db->escape(html_entity_decode($data['manufacturer_id']))) ? $data['manufacturer_id'] : 'null'));
		$product_model = html_entity_decode($this->db->escape(!empty($this->db->escape(html_entity_decode($data['product_model']))) ? $this->db->escape(html_entity_decode($data['product_model'])) : 'null'));

		$sql = "UPDATE " . DB_PREFIX . "mobikul_custom_collection SET collection_type = '" . $latest_type . "', latest_count = " . $count . ", product_attribute = '" .  $attribute . "', price_from = " . $price_from . ", price_to = " . $price_to . ", manufacturer_id = '" . $manufacturer_id . "', product_model = '" . $product_model . "' where id =" . $id;

		if ($this->db->query($sql)) {
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_custom_collection_description WHERE id=" . $id);
			foreach ($data['name'] as $language_id => $collection_names) {
				$sql2 =  "INSERT INTO " . DB_PREFIX . "mobikul_custom_collection_description SET id =" . $id . ", language_id = " . $language_id . ", name = '" . html_entity_decode($this->db->escape($data['name'][$language_id]['collection_name'])) . "'";

				$this->db->query($sql2);
			}
			$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_custom_collection_to_product WHERE id=" . $id);
			foreach ($data['mobikul_customcollection_customcollection_product'] as $product_id) {
				$sql3 = "INSERT INTO " . DB_PREFIX . "mobikul_custom_collection_to_product SET id =" . $id . ", product_id = " . $this->db->escape($product_id);

				$this->db->query($sql3);
			}
		}
	}

	public function getCustomCollection($data = array())
	{
		$sql = "SELECT * FROM " . DB_PREFIX . "mobikul_custom_collection mc LEFT JOIN " . DB_PREFIX . "mobikul_custom_collection_description mcd on (mc.id=mcd.id) where mcd.language_id=" . $this->config->get('config_language_id');

		if (isset($data['sort'])) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY mc.id";
		}

		if (isset($data['order'])) {
			$sql .= " " . $data['order'];
		} else {
			$sql .= " ASC";
		}

		$sql .= " LIMIT " . $data['start'] . ", " . $data['limit'];

		$results = $this->db->query($sql)->rows;
		$return_array = array();

		if ($results) {
			foreach ($results as $result) {

				$sql2 = "SELECT * FROM " . DB_PREFIX . "mobikul_custom_collection_description where id = " . $result['id'];

				$results2 = $this->db->query($sql2)->rows;

				foreach ($results2 as $language_id => $name) {
					$collection_name[$name['language_id']] = $name;
				}

				$sql3 = "SELECT cc2p.id, cc2p.product_id,pd.name FROM " . DB_PREFIX . "mobikul_custom_collection_to_product  as cc2p left join " . DB_PREFIX . "product_description as pd on cc2p.product_id=pd.product_id where cc2p.id=" . $result['id'] . " and language_id =" . (int)$this->config->get('config_language_id');

				$results3 = $this->db->query($sql3)->rows;

				$product_names = '';
				$product_ids = '';
				foreach ($results3 as $result3) {
					$product_names .= $result3['name'] . ',';
					$product_ids .= $result3['product_id'] . ',';
				}
				$product_names = rtrim($product_names, ",");
				$product_ids = rtrim($product_ids, ",");

				$return_array[] = array(
					"id" => $result['id'],
					"collection_type" => $result['collection_type'],
					"name" =>  $collection_name,
					"product_ids" => $product_ids,
					"product_name" => $product_names,
					"latest_count" => $result['latest_count'],
					"product_attribute" => $result['product_attribute'],
					"price_from" => $result['price_from'],
					"price_to" => $result['price_to'],
					"manufacturer_id" => $result['manufacturer_id'],
					"model" => $result['product_model']

				);
			}
		}
		return $return_array;
	}

	public function getCustomCollectionById($id)
	{
		$id =   $this->db->escape(html_entity_decode($id));
		$return_array = array();

		if (filter_var($id, FILTER_VALIDATE_INT)) {
			$all_collection = $this->db->query("SELECT * FROM " . DB_PREFIX . "mobikul_custom_collection where id=" . $id)->row;
		} else {
			$all_collection = array();
		}

		if ($all_collection) {
			$sql2 = "SELECT * FROM " . DB_PREFIX . "mobikul_custom_collection_description where id = " . $id;
			$results2 = $this->db->query($sql2)->rows;

			foreach ($results2 as $name) {
				$collection_name[$name['language_id']]['collection_name'] = $name['name'];
			}



			$sql3 = "SELECT cc2p.id, cc2p.product_id,pd.name FROM " . DB_PREFIX . "mobikul_custom_collection_to_product  as cc2p left join " . DB_PREFIX . "product_description as pd on cc2p.product_id=pd.product_id where cc2p.id=" . $id . " and language_id =" . (int)$this->config->get('config_language_id');
			$results3 = $this->db->query($sql3)->rows;

			$product = array();
			$return_array = array();
			foreach ($results3 as $result3) {
				$product[] = array(
					"product_name"   =>   $result3['name'],
					"product_id"   =>   $result3['product_id']
				);
			}

			$return_array = array(
				"collection_id"   =>   $all_collection['id'],
				"collection_type"   =>   $all_collection['collection_type'],
				"collection_name"   =>   $collection_name,
				"products"   =>    $product,
				"latest_count"   =>   isset($all_collection['latest_count']) ? $all_collection['latest_count'] : 'null',
				"product_attribute"   =>   isset($all_collection['product_attribute']) ? $all_collection['product_attribute'] : 'null',
				"price_from"   =>    isset($all_collection['price_from']) ? $all_collection['price_from'] : 'null',
				"price_to"   =>    isset($all_collection['price_to']) ? $all_collection['price_to'] : 'null',
				"manufacturer_id"   =>   isset($all_collection['manufacturer_id']) ? $all_collection['manufacturer_id'] : 'null',
				"product_model"   =>   isset($all_collection['product_model']) ? $all_collection['product_model'] : 'null',
			);
		}


		return $return_array;
	}

	public function getTotalCollection()
	{
		$sql = "SELECT COUNT(*) AS total FROM " . DB_PREFIX . "mobikul_custom_collection ";

		$query = $this->db->query($sql);

		return $query->row['total'];
	}

	public function getManufacturerName($id)
	{
		$sql = "SELECT name FROM " . DB_PREFIX . "manufacturer where manufacturer_id=" . $id;
		$query = $this->db->query($sql)->row;

		return isset($query['name']) ? $query['name'] : '';
	}

	public function deleteCollection($id = 0)
	{
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_custom_collection WHERE id = " . (int)$id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_custom_collection_to_product WHERE id = " . (int)$id);
		$this->db->query("DELETE FROM " . DB_PREFIX . "mobikul_custom_collection_description WHERE id = " . (int)$id);
	}
}
