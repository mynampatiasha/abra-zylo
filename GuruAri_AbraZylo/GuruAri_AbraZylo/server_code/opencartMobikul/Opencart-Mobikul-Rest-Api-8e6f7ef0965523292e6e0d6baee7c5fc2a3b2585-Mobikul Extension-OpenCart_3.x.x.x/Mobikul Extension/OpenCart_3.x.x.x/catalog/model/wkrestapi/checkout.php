<?php
class ModelWkrestapiCheckout extends Model {

  /**
   * [addOrder] add only mobile order entry
   * @return [type]        none
   */
   public function addOrder() {
     if (isset($this->session->data['order_id'])) {
       $this->db->query("UPDATE `" . DB_PREFIX . "order` SET mobikul=1 WHERE order_id = '" . (int) $this->session->data['order_id'] . "'");
     }
   }
}
