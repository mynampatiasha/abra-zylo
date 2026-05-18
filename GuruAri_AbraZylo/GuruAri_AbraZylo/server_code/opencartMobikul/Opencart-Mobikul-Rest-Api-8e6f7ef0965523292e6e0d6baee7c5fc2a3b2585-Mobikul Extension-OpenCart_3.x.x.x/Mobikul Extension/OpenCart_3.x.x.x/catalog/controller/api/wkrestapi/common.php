<?php
class ControllerApiWkrestapiCommon extends Controller
{
    public function apiLogin()
    {
        //cc03e747a6afbbcbf8be7668acfebee5
        $this->load->language('account/api');

        $postData = array();

        foreach ($this->request->post as $key => $value) {
            $postData[$key] = $value;
        }

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $postData[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        $this->load->model('wkrestapi/customer');

        if ($this->config->get('mobikul_status') && isset($postData['apiPassword'])) {
            if (isset($postData['apiKey']) && isset($postData['apiPassword'])) {
                $apiData = $this->model_wkrestapi_customer->doAuthenticate($postData['apiKey'], $postData['apiPassword']);
            }
        } else {
            if (isset($postData['apiKey'])) {
                $apiData = $this->model_wkrestapi_customer->doAuthenticate($postData['apiKey']);
            }
        }

        if (isset($apiData) && $apiData) {

            if (version_compare(VERSION, '3.0.0.0', '>=')) {
                $session_id = $this->session->getId();
            } else {
                $session_id = session_id();
            }

            if (isset($postData['language']) && $postData['language']) {
                $this->session->data['language'] = $postData['language'];
            } else {
                $postData['language'] = $this->session->data['language'];
            }

            if (isset($postData['currency']) && $postData['currency']) {
                $this->session->data['currency'] = $postData['currency'];
            } else {
                $postData['currency'] = $this->session->data['currency'];
            }

            if (isset($postData['customer_id'])) {
                if (version_compare(VERSION, '3.0.0.0', '>=') || version_compare(VERSION, '2.3.0.0', '<')) {
                    $this->session->data['customer_id'] = $postData['customer_id'];
                } else {
                    $_SESSION[$session_id]['customer_id'] = $postData['customer_id'];
                }
            }

            $this->session->data['session_id'] = $session_id;

            $return_array = array(
                'error' => 0,
                'wk_token' => $session_id,
                'language' => $postData['language'],
                'currency' => $postData['currency'],
                'status' => $this->config->get('mobikul_status'),
                'walkthrough_status' => $this->config->get('module_mobikul_walkthrough_status'),
            );

            $this->response->addHeader('Content-Type: application/json');

            $this->response->setOutput(json_encode($return_array));
        } else {
            $return_array = array(
                'error' => 1,
                'message' => $this->language->get('text_api_login_message'),
            );
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    public function apiLogout()
    {

        $this->load->language('account/api');

        if (version_compare(VERSION, '3.0.0.0', '>=')) {
            unset($this->session->data['session_id']);
        } else {
            session_destroy();
        }

        $logout['error'] = 0;
        $logout['message'] = $this->language->get('text_api_logout_message');

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($logout));
    }

    /**
     * Changes language as per customer
     * @param  json $data contains language code
     * @return json       returns error if exist
     */
    public function language()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            if (isset($post['code']) && $post['code']) {
                $this->session->data['language'] = $post['code'];
                $return_array = array(
                    'error' => 0,
                );
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_language_message'),
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Changes currency as per user
     * @param  json $data contains currency code
     * @return json       returns error if exist
     */
    public function currency()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            if (isset($post['code']) && $post['code']) {
                $this->session->data['currency'] = $post['code'];
                unset($this->session->data['shipping_method']);
                unset($this->session->data['shipping_methods']);
                $return_array = array(
                    'error' => 0,
                );
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_language_message'),
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the data of home page along with banners
     * @param  json $data null
     * @return json       returns home page data
     */
    public function homepage()
    {
        $this->load->language('product/category');
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (!isset($data['width']) || !$data['width']) {
                $data['width'] = 100;
            } else {
                $data['width'] = (int) $data['width'];
            }

            if (!isset($data['count']) || !$data['count']) {
                $data['count'] = 3;
            }

            $this->load->model('catalog/category');
            $this->load->model('catalog/product');
            $this->load->model('tool/image');

            $category = array();
            $banners = array();
            $carousel = array();
            $featured = array();
            $popular = array();
            $best = array();
            $latest = array();
            $return_home_sequence = array();
            $home_sequence = $this->config->get('mobikulhome_sequence');
            
            if ($home_sequence && is_array($home_sequence)) {
                foreach ($home_sequence as $value) {
                    $key = explode("_", $value)[0];
                    
                    if ($key == 'banner') {
                        $type = 'banner';
                    } else {
                        $type = 'carousel';
                    }

                    $return_home_sequence[] = array(
                        "id" => $value,
                        "type" => $type,
                    );
                }
                foreach ($home_sequence as $type) {
                    if (strpos($type, "banner") !== false) {
                        $getBanner = $this->model_wkrestapi_catalog->banners($type, $data['width']);
                        if ($getBanner) {
                            $banners[] = $getBanner;
                        }
                    }
                    
                    if (strpos($type, "carousel") !== false) {
                        $getCarousel = $this->model_wkrestapi_catalog->carousel($type, $data);
                        if ($getCarousel) {
                            $carousel[] = $getCarousel; 
                        }
                    }
                }
                $category = $this->getCategoriesArray(0, $data['width']);
                if (in_array('category', $home_sequence)) {
                    $category = $this->getCategoriesArray(0, $data['width']);
                }

            }
            $partner = 0;
            $partner_approve_required = false;

            if ($this->config->get('marketplace_status') || $this->config->get('module_marketplace_status')) {
                $this->load->model('wkrestapi/customer');

                if ($this->model_wkrestapi_customer->chkIsPartner($this->customer->getId())) {
                    $partner = 1;
                }
                if ($partner == 0) {
                    $hasApplied = $this->model_wkrestapi_customer->IsApplyForSellership($this->customer->getId());
                    if ($hasApplied) {
                        $partner_approve_required = true;
                    }
                }
            }

            if ($data) {
                $return_array = array(
                    'error' => 0,
                    'guest_status' => $this->config->get('config_checkout_guest') ? true : false,
                    'partner' => $partner,
                    'partner_approve_required' => $partner_approve_required,
                    'home_sequence' => $return_home_sequence ? $return_home_sequence : array(),
                    'banners' => $banners,
                    'carousels' => $carousel,
                    'categories' => $category,
                    'languages' => $this->model_wkrestapi_catalog->languages(),
                    'currencies' => $this->model_wkrestapi_catalog->currencies(),
                    'cart' => $this->cart->countProducts(),
                    'language' => $this->config->get('config_language_id'),
                    'footerMenu' => $this->model_wkrestapi_catalog->footerMenu(),
                );
            } else {
                $return_array = array(
                    'error' => 1,
                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }
    public function getCarousels()
    {
        $this->load->language('product/category');
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            if (isset($post['carousel_id']) && $post['carousel_id']) {
                $carousel_id = $post['carousel_id'];
            } else {
                $carousel_id = 'carousel_0';
            }
            if (isset($post['width']) && $post['width']) {
                $width = (int) $post['width'];
            } else {
                $width = 500;
            }
            if (isset($post['page']) && $post['page']) {
                $page = $post['page'];
            } else {
                $page = 1;
            }
            if (isset($post['sort']) && $post['sort']) {
                $sort = $post['sort'];
            } else {
                $sort = null;
            }
            if (isset($post['order']) && $post['order']) {
                $order = $post['order'];
            } else {
                $order = null;
            }
            if (isset($post['limit']) && $post['limit']) {
                $limit = $post['limit'];
            } else {
                $limit = null;
            }
            $filter = array(
                "width" => (int) $width,
                "page" => $page,
                "sort" => $sort,
                "order" => $order,
                "limit" => $limit,
            );

            $this->load->model('wkrestapi/catalog');
            $this->load->model('catalog/product');
            $carousels = $this->model_wkrestapi_catalog->carousel($carousel_id, $filter);
            
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($carousels));
        }
    }

    public function getBestProducts()
    {
        $this->load->language('product/category');
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        $sort = array();

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_default')),
            'value' => 'total',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_asc')),
            'value' => 'pd.name',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_desc')),
            'value' => 'pd.name',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_asc')),
            'value' => 'p.price',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_desc')),
            'value' => 'p.price',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_asc')),
            'value' => 'p.model',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_desc')),
            'value' => 'p.model',
            'order' => 'DESC',
        );

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (!isset($data['width']) || !$data['width']) {
                $data['width'] = 100;
            } else {
                $data['width'] = (int) $data['width'];
            }

            if (!isset($data['limit']) || !$data['limit']) {
                $data['limit'] = 5;
            }

            if ($fetch = $this->model_wkrestapi_catalog->getBestSeller($data)) {
                $best_seller_product = $fetch;
            } else {
                $best_seller_product = array();
            }

            $data['total'] = '';

            $this->load->model('catalog/product');

            $total = $this->model_wkrestapi_catalog->getBestSeller($data);

            if ($data) {
                $return_array = array(
                    'error' => 0,
                    'products' => $best_seller_product,
                    'product_total' => (int) $total,
                    'sorts' => $sort,
                );
            } else {
                $return_array = array(
                    'error' => 1,

                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    public function getPopularProducts()
    {
        $this->load->language('product/category');
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        $sort = array();

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_default')),
            'value' => 'p.viewed DESC, p.date_added',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_asc')),
            'value' => 'pd.name',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_desc')),
            'value' => 'pd.name',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_asc')),
            'value' => 'p.price',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_desc')),
            'value' => 'p.price',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_asc')),
            'value' => 'p.model',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_desc')),
            'value' => 'p.model',
            'order' => 'DESC',
        );

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (!isset($data['width']) || !$data['width']) {
                $data['width'] = 100;
            } else {
                $data['width'] = (int) $data['width'];
            }

            if (!isset($data['limit']) || !$data['limit']) {
                $data['limit'] = 5;
            }

            if ($fetch = $this->model_wkrestapi_catalog->getPopularProduct($data)) {
                $best_seller_product = $fetch;
            } else {
                $best_seller_product = array();
            }

            $data['total'] = '';

            $this->load->model('catalog/product');

            $total = $this->model_wkrestapi_catalog->getPopularProduct($data);

            if ($data) {
                $return_array = array(
                    'error' => 0,
                    'sorts' => $sort,
                    'products' => $best_seller_product,
                    'product_total' => (int) $total,
                );
            } else {
                $return_array = array(
                    'error' => 1,

                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the data from latest products
     * @param  json $data null
     * @return json       returns latest products
     */
    public function latestProduct()
    {
        $this->load->language('product/category');
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        $sort = array();

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_default')),
            'value' => 'p.sort_order',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_asc')),
            'value' => 'pd.name',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_desc')),
            'value' => 'pd.name',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_asc')),
            'value' => 'p.price',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_desc')),
            'value' => 'p.price',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_asc')),
            'value' => 'p.model',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_desc')),
            'value' => 'p.model',
            'order' => 'DESC',
        );

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (!isset($data['width']) || !$data['width']) {
                $data['width'] = 100;
            } else {
                $data['width'] = (int) $data['width'];
            }

            if (!isset($data['limit']) || !$data['limit']) {
                $data['limit'] = 5;
            }

            if ($fetch = $this->model_wkrestapi_catalog->latestProduct($data)) {
                $latest_product = $fetch;
            } else {
                $latest_product = array();
            }

            $data['total'] = '';

            $this->load->model('catalog/product');

            $total = $this->model_wkrestapi_catalog->latestProduct($data);

            if ($data) {
                $return_array = array(
                    'error' => 0,
                    'products' => $latest_product,
                    'product_total' => (int) $total,
                    'sorts' => $sort,
                );
            } else {
                $return_array = array(
                    'error' => 1,

                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the data from featured
     * @param  json $data null
     * @return json       returns featured data
     */
    public function featured()
    {

        $this->load->language('account/api');
        $this->load->language('product/category');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        $sorts = array();

        $sorts[] = array(
            'text' => $this->language->get('text_default'),
            'value' => 'p.sort_order',
            'order' => 'ASC',
        );

        $sorts[] = array(
            'text' => $this->language->get('text_name_asc'),
            'value' => 'pd.name',
            'order' => 'ASC',
        );

        $sorts[] = array(
            'text' => $this->language->get('text_name_desc'),
            'value' => 'pd.name',
            'order' => 'DESC',
        );

        $sorts[] = array(
            'text' => $this->language->get('text_price_asc'),
            'value' => 'p.price',
            'order' => 'ASC',
        );

        $sorts[] = array(
            'text' => $this->language->get('text_price_desc'),
            'value' => 'p.price',
            'order' => 'DESC',
        );

        $sorts[] = array(
            'text' => $this->language->get('text_model_asc'),
            'value' => 'p.model',
            'order' => 'ASC',
        );

        $sorts[] = array(
            'text' => $this->language->get('text_model_desc'),
            'value' => 'p.model',
            'order' => 'DESC',
        );

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if ($fetch = $this->model_wkrestapi_catalog->featured($data)) {
                $featured = $fetch;
            } else {
                $featured = array();
            }

            if ($data) {
                $return_array = array(
                    'error' => 0,
                    'sorts' => $sorts,
                    'products' => $featured,
                    'product_total' => $this->model_wkrestapi_catalog->getTotalFeatured(),
                );
            } else {
                $return_array = array(
                    'error' => 1,
                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    /**
     * Fetches the data from cart
     * return cart data
     */
    protected function viewCart()
    {
        $this->load->language('account/api');
        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        if (isset($post) && $post) {
            if (isset($post['width'])) {
                $width = (int) $post['width'];
            } else {
                $width = 100;
            }

            $this->load->model('wkrestapi/cart');

            $this->load->language('checkout/cart');

            $cart = array();

            if ($this->cart->hasProducts() || !empty($this->session->data['vouchers'])) {

                if (!$this->cart->hasStock() && (!$this->config->get('config_stock_checkout') || $this->config->get('config_stock_warning'))) {
                    $cart['error_warning'] = $this->language->get('error_stock');
                } elseif (isset($this->session->data['error'])) {
                    $cart['error_warning'] = $this->session->data['error'];

                    unset($this->session->data['error']);
                } else {
                    $cart['error_warning'] = '';
                }

                if ($this->config->get('config_stock_checkout')) {
                    $cart['checkout'] = $this->config->get('config_stock_checkout');
                } else {
                    $cart['checkout'] = 0;
                }

                if ($this->config->get('config_customer_price') && !$this->customer->isLogged()) {
                    $cart['attention'] = strip_tags(sprintf($this->language->get('text_login'), '', ''));
                } else {
                    $cart['attention'] = '';
                }

                if (isset($this->session->data['success'])) {
                    $cart['success'] = $this->session->data['success'];

                    unset($this->session->data['success']);
                } else {
                    $cart['success'] = '';
                }

                $cart['action'] = $this->url->link('checkout/cart/edit', '', true);

                if ($this->config->get('config_cart_weight')) {
                    $cart['weight'] = $this->weight->format($this->cart->getWeight(), $this->config->get('config_weight_class_id'), $this->language->get('decimal_point'), $this->language->get('thousand_point'));
                } else {
                    $cart['weight'] = '';
                }

                $this->load->model('tool/image');
                if (version_compare(VERSION, '2.0.0.0', '>=')) {
                    $this->load->model('tool/upload');
                }

                $cart['products'] = array();

                $products = $this->cart->getProducts();

                foreach ($products as $product) {
                    $product_total = 0;

                    foreach ($products as $product_2) {
                        if ($product_2['product_id'] == $product['product_id']) {
                            $product_total += $product_2['quantity'];
                        }
                    }

                    if ($product['minimum'] > $product_total) {
                        $cart['error_warning'] = sprintf($this->language->get('error_minimum'), $product['name'], $product['minimum']);
                    }

                    if ($product['image']) {
                        $image = str_replace(' ', '%20', $this->model_tool_image->resize($product['image'], $width ? $width / 2.5 : $this->config->get('config_image_cart_width'), $width ? $width / 2.5 : $this->config->get('config_image_cart_height')));
                    } else {
                        $image = '';
                    }

                    $this->load->model('wkrestapi/catalog');
                    $dominant_color = $this->model_wkrestapi_catalog->getDominantColor($image);

                    $option_data = array();

                    foreach ($product['option'] as $option) {
                        if ($option['type'] != 'file') {

                            if (version_compare(VERSION, '2.0.0.0', '<')) {
                                $value = $option['price'];
                            } else {
                                $value = $option['value'];
                            }

                        } else {
                            if (version_compare(VERSION, '2.0.0.0', '>=')) {
                                $upload_info = $this->model_tool_upload->getUploadByCode($option['value']);
                                if ($upload_info) {
                                    $upload_info_value = $upload_info['name'];
                                } else {
                                    $upload_info_value = '';
                                }

                            } else {
                                $filename = $this->encryption->decrypt($option['option_value']);
                                $upload_info_value = utf8_substr($filename, 0, utf8_strrpos($filename, '.'));
                            }
                            if ($upload_info_value) {
                                $value = $upload_info_value;
                            } else {
                                $value = '';
                            }
                        }

                        $option_data[] = array(
                            'name' => $option['name'],
                            'value' => (utf8_strlen($value) > 20 ? utf8_substr($value, 0, 20) . '..' : $value),
                        );
                    }

                    // Display prices
                    if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                        $price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                    } else {
                        $price = false;
                    }

                    // Display prices
                    if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                        $total = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity'], $this->session->data['currency']);
                    } else {
                        $total = false;
                    }

                    $recurring = '';

                    if ($product['recurring']) {
                        $frequencies = array(
                            'day' => $this->language->get('text_day'),
                            'week' => $this->language->get('text_week'),
                            'semi_month' => $this->language->get('text_semi_month'),
                            'month' => $this->language->get('text_month'),
                            'year' => $this->language->get('text_year'),
                        );

                        if ($product['recurring']['trial']) {
                            $recurring = sprintf($this->language->get('text_trial_description'), $this->currency->format($this->tax->calculate($product['recurring']['trial_price'] * $product['quantity'], $product['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']), $product['recurring']['trial_cycle'], $frequencies[$product['recurring']['trial_frequency']], $product['recurring']['trial_duration']) . ' ';
                        }

                        if ($product['recurring']['duration']) {
                            $recurring .= sprintf($this->language->get('text_payment_description'), $this->currency->format($this->tax->calculate($product['recurring']['price'] * $product['quantity'], $product['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']), $product['recurring']['cycle'], $frequencies[$product['recurring']['frequency']], $product['recurring']['duration']);
                        } else {
                            $recurring .= sprintf($this->language->get('text_payment_cancel'), $this->currency->format($this->tax->calculate($product['recurring']['price'] * $product['quantity'], $product['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']), $product['recurring']['cycle'], $frequencies[$product['recurring']['frequency']], $product['recurring']['duration']);
                        }
                    }

                    if (version_compare(VERSION, '2.1.0.0', '>=')) {
                        $cart['products'][] = array(
                            'key' => $product['cart_id'],
                            'thumb' => $image,
                            'dominant_color' => $dominant_color,
                            'name' => $product['name'],
                            'model' => $product['model'],
                            'option' => $option_data,
                            'recurring' => $recurring,
                            'quantity' => $product['quantity'],
                            'stock' => $product['stock'] ? true : !(!$this->config->get('config_stock_checkout') || $this->config->get('config_stock_warning')),
                            'reward' => ($product['reward'] ? sprintf($this->language->get('text_points'), $product['reward']) : ''),
                            'points' => ($product['points'] ? $product['points'] : ''),
                            'price' => $price,
                            'total' => $total,
                            'product_id' => $product['product_id'],
                        );
                    } else {
                        $cart['products'][] = array(
                            'key' => $product['key'],
                            'thumb' => $image,
                            'dominant_color' => $dominant_color,
                            'name' => $product['name'],
                            'model' => $product['model'],
                            'option' => $option_data,
                            'recurring' => $recurring,
                            'quantity' => $product['quantity'],
                            'stock' => $product['stock'] ? true : !(!$this->config->get('config_stock_checkout') || $this->config->get('config_stock_warning')),
                            'reward' => ($product['reward'] ? sprintf($this->language->get('text_points'), $product['reward']) : ''),
                            'points' => ($product['points'] ? $product['points'] : ''),
                            'price' => $price,
                            'total' => $total,
                            'product_id' => $product['product_id'],
                        );
                    }
                }

                // Gift Voucher
                $cart['vouchers'] = array();

                if (!empty($this->session->data['vouchers'])) {
                    foreach ($this->session->data['vouchers'] as $key => $voucher) {
                        $cart['vouchers'][] = array(
                            'key' => $key,
                            'description' => $voucher['description'],
                            'amount' => $this->currency->format($voucher['amount'], $this->session->data['currency']),
                            'remove' => $this->url->link('checkout/cart', 'remove=' . $key),
                        );
                    }
                }

                // Totals
                if (version_compare(VERSION, '3.0.0.0', '>=') || version_compare(VERSION, '2.0.0.0', '<')) {
                    $this->load->model('setting/extension');
                } else {
                    $this->load->model('extension/extension');
                }

                $total_data = array();
                $total = 0;
                $taxes = $this->cart->getTaxes();

                if (version_compare(VERSION, '2.2.0.0', '>=')) {
                    $total_data = array(
                        'totals' => &$totals,
                        'taxes' => &$taxes,
                        'total' => &$total,
                    );
                }

                // Display prices
                if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                    $sort_order = array();

                    if (version_compare(VERSION, '3.0.0.0', '>=') || version_compare(VERSION, '2.0.0.0', '<')) {
                        $results = $this->model_setting_extension->getExtensions('total');
                    } else {
                        $results = $this->model_extension_extension->getExtensions('total');
                    }

                    foreach ($results as $key => $value) {
                        $sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
                    }

                    array_multisort($sort_order, SORT_ASC, $results);

                    foreach ($results as $result) {

                        if (version_compare(VERSION, '3.0.0.0', '>=')) {
                            $total_name = 'total_' . $result['code'] . '_status';
                        } else {
                            $total_name = $result['code'] . '_status';
                        }

                        if ($this->config->get($total_name)) {

                            if (version_compare(VERSION, '2.3.0.0', '>=')) {
                                $this->load->model('extension/total/' . $result['code']);

                                $this->{'model_extension_total_' . $result['code']}->getTotal($total_data);
                            } else {
                                $this->load->model('total/' . $result['code']);
                                if (version_compare(VERSION, '2.2.0.0', '>=')) {
                                    $this->{'model_total_' . $result['code']}->getTotal($total_data);
                                } else {
                                    $this->{'model_total_' . $result['code']}->getTotal($total_data, $total, $taxes);
                                }
                            }
                        }
                    }

                    $sort_order = array();

                    foreach ($total_data as $key => $value) {
                        if (isset($value['sort_order'])) {
                            $sort_order[$key] = $value['sort_order'];
                        } else {
                            $sort_order[$key] = 1;
                        }
                    }

                    array_multisort($sort_order, SORT_ASC, $total_data);
                }

                $cart['totals'] = array();

                if (version_compare(VERSION, '2.2.0.0', '>=')) {
                    if (isset($total_data['totals']) && $total_data['totals']) {
                        foreach ($total_data['totals'] as $total) {
                            $cart['totals'][] = array(
                                'title' => isset($total['title']) ? $total['title'] : '',
                                'text' => isset($total['value']) ? $this->currency->format($total['value'], $this->session->data['currency']) : '',
                            );
                        }
                    }
                } else {
                    if (isset($total_data) && $total_data) {
                        foreach ($total_data as $total) {
                            $cart['totals'][] = array(
                                'title' => isset($total['title']) ? $total['title'] : '',
                                'text' => isset($total['value']) ? $this->currency->format($total['value'], $this->session->data['currency']) : '',
                            );
                        }
                    }
                }

                $cart['total_products'] = $this->cart->countProducts();

                $return_array = array(
                    'cart' => $cart,
                    'coupon' => $this->model_wkrestapi_cart->coupon(),
                    'voucher' => $this->model_wkrestapi_cart->voucher(),
                    'reward' => $this->model_wkrestapi_cart->reward(),
                    'shipping' => '',
                );
            } else {
                $return_array = array('cart' => array());
            }
            return $return_array;
        }
    }

    protected function getCategoriesArray($category_id, $width)
    {
        $category_data = array();

        $children_data = array();

        $categories = $this->model_wkrestapi_catalog->getCategories($category_id);
        
        if ($categories) {
            foreach ($categories as $category) {
                
                $filter_data = array(
                    'filter_category_id' => $category['category_id'],
                    'filter_sub_category' => true,
                );
                
                $children = $this->model_catalog_category->getCategories($category['category_id']);
                // print_r($children);die;

                if ($children) {
                    $child_exist = true;
                } else {
                    $child_exist = false;
                }

                if (is_file(DIR_IMAGE . $category['category_image']) && $category['category_image'] != 'no_image.png' && isset($category['category_icon'])) {
                    $image = DIR_IMAGE . $category['category_image'];
                    $imagelink = $category['category_image'];
                } elseif (is_file(DIR_IMAGE . $category['image'])) {
                    $image = DIR_IMAGE . $category['image'];
                    $imagelink = $category['image'];
                } else {
                    $image = DIR_IMAGE . 'no_image.png';
                    $imagelink = 'no_image.png';
                }

                if (is_file(DIR_IMAGE . $category['category_icon']) && isset($category['category_icon'])) {
                    $category_icon = DIR_IMAGE . $category['category_icon'];
                    $category_icon_link = $category['category_icon'];
                } else {
                    $category_icon = DIR_IMAGE . 'no_image.png';
                    $category_icon_link = 'no_image.png';
                }

                // Level 1
                $category_data[] = array(
                    'name' => html_entity_decode($category['name'], ENT_QUOTES, 'UTF-8') . ($this->config->get('config_product_count') ? ' (' . $this->model_catalog_product->getTotalProducts($filter_data) . ')' : ''),
                    'child_status' => $child_exist,
                    'path' => $category['category_id'],
                    'image' => str_replace(' ', '%20', $this->model_tool_image->resize($imagelink, $width, $width / 2)),
                    'dominant_color' => $this->model_wkrestapi_catalog->getDominantColor($image),
                    "icon" => str_replace(' ', '%20', $this->model_tool_image->resize($category_icon_link, $width, $width)),
                    'dominant_color_icon' => $this->model_wkrestapi_catalog->getDominantColor($category_icon),

                );
            }
        }
        return $category_data;
    }

    public function getSubCategory()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (!isset($data['width']) || !$data['width']) {
                $data['width'] = 100;
            } else {
                $data['width'] = (int) $data['width'];
            }

            if (!isset($data['category_id']) || !$data['category_id']) {
                $data['category_id'] = 0;
            }

            $this->load->model('catalog/category');
            $this->load->model('catalog/product');
            $this->load->model('tool/image');

            $categories_data = $this->getCategoriesArray($data['category_id'], $data['width']);

            if ($categories_data) {
                $return_array = array(
                    'error' => 0,
                    'categories' => $categories_data,
                );
            } else {
                $return_array = array(
                    'error' => 1,
                    'message' => $this->language->get('text_no_data'),
                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    public function getAllCategories()
    {
        $this->load->language('product/category');
        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        $sort = array();

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_default')),
            'value' => 'p.viewed DESC, p.date_added',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_asc')),
            'value' => 'pd.name',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_name_desc')),
            'value' => 'pd.name',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_asc')),
            'value' => 'p.price',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_price_desc')),
            'value' => 'p.price',
            'order' => 'DESC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_asc')),
            'value' => 'p.model',
            'order' => 'ASC',
        );

        $sort[] = array(
            'text' => htmlspecialchars_decode($this->language->get('text_model_desc')),
            'value' => 'p.model',
            'order' => 'DESC',
        );

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token']) || $post['wk_token'] == 'Session_Not_Loggin') {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            $data = array();

            foreach ($post as $key => $value) {
                $data[$key] = $value;
            }

            $this->load->model('wkrestapi/catalog');

            if (!isset($data['width']) || !$data['width']) {
                $data['width'] = 100;
            } else {
                $data['width'] = (int) $data['width'];
            }

            if (!isset($data['category_id']) || !$data['category_id']) {
                $data['category_id'] = 0;
            }

            $this->load->model('catalog/category');
            $this->load->model('catalog/product');
            $this->load->model('tool/image');

            $categories_data = $this->getCategoriesArray($data['category_id'], $data['width']);

            if ($categories_data) {
                $return_array = array(
                    'error' => 0,
                    'guest_status' => $this->config->get('config_checkout_guest') ? true : ($this->config->get('config_guest_checkout') ? true : false),
                    'category' => $categories_data,
                    'sorts' => $sort
                );
            } else {
                $return_array = array(
                    'error' => 1,
                );
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    public function getFooter()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $this->load->model('catalog/information');

            $data['informations'] = array();

            foreach ($this->model_catalog_information->getInformations() as $result) {
                if ($result['bottom']) {
                    $data['informations'][] = array(
                        'information_id' => $result['information_id'],
                        'title' => $result['title'],
                        'status' => $result['status'],
                        'sort_order' => $result['sort_order'],
                    );
                }
            }

            if ($data['informations']) {

                $return_array = array(
                    'error' => 0,
                    'information' => $data['informations'],
                );
            } else {
                $return_array = array(
                    'error' => 1,
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }
    public function getWalkThrough()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        $this->load->model('wkrestapi/catalog');
        if (isset($post['width'])) {
            $width = (int) $post['width'];
        } else {
            $width = 100;
        }
        if (isset($post['height'])) {
            $height = $post['height'];
        } else {
            $height = 100;
        }
        if (isset($post['filter_title'])) {
            $filter_title = $post['filter_title'];
        } else {
            $filter_title = null;
        }

        if (isset($post['filter_status'])) {
            $filter_status = $post['filter_status'];
        } else {
            $filter_status = null;
        }

        if (isset($post['sort'])) {
            $sort = $post['sort'];
        } else {
            $sort = null;
        }

        if (isset($post['order'])) {
            $order = $post['order'];
        } else {
            $order = '';
        }

        if (isset($post['page'])) {
            $page = $post['page'];
        } else {
            $page = 1;
        }

        $filter = array(
            'filter_title' => $filter_title,
            'filter_status' => $filter_status,
            'sort' => $sort,
            'order' => $order,
            'start' => ($page - 1) * $this->config->get('config_limit_admin'),
            'limit' => $this->config->get('config_limit_admin'),
        );

        $walkthroughs = $this->model_wkrestapi_catalog->getWalkthrough($filter);
        $this->load->model('tool/image');
        foreach ($walkthroughs as $key => $value) {

            $data['walkthrough_list'][] = array(
                "id" => $value['id'],
                //"image" => $this->model_tool_image->resize($value['image'], $width, $height),
                "image" => str_replace(' ', '%20', $this->model_tool_image->resize($value['image'], $width, $height)),
                "title" => $value['title'],
                "description" => $value['description'],
                "status" => $value['status'],
                "sort_order" => $value['sort_order'],

            );
            return $data;
        }
        // }
    }

    public function getInformationPage()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {
            if (isset($post['information_id'])) {
                $this->load->model('catalog/information');

                $information_info = $this->model_catalog_information->getInformation($post['information_id']);

                if ($information_info) {

                    $return_array = array(
                        'error' => 0,
                        'information_id' => $information_info['information_id'],
                        'title' => html_entity_decode($information_info['title'], ENT_QUOTES, 'UTF-8'),
                        'description' => html_entity_decode(html_entity_decode($information_info['description'], ENT_QUOTES, 'UTF-8'), ENT_QUOTES, 'UTF-8'),
                    );
                } else {
                    $return_array = array(
                        'error' => 1,
                    );
                }
            } else {
                $return_array = array(
                    'error' => 1,
                );
            }
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($return_array));
        }
    }

    public function getSplashScreen()
    {

        $this->load->language('account/api');

        $post = $this->request->post;

        //Accepting data in json format / raw data

        $raw_data = json_decode(file_get_contents("php://input"), true);

        if ($raw_data) {
            foreach ($raw_data as $key => $value) {
                $post[$key] = $value;
            }
        }

        //Get wk_token from header
        if (isset(getallheaders()['wk_token'])) {
            $post['wk_token'] = getallheaders()['wk_token'];
        } elseif (isset(getallheaders()['Wk-Token'])) {
            $post['wk_token'] = getallheaders()['Wk-Token'];
        }

        if (!isset($post['wk_token']) || !$this->checkSession($post['wk_token'])) {
            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode(array('fault' => 1, 'message' => $this->language->get('text_token_message'))));
        } else {

            $data['WalkthroughData'] = $this->getWalkThrough();

            $default_array = array(
                'mobikul_theme_bright_app_button_color' => '#000000',
                'mobikul_theme_bright_app_button_text_theme_color' => '#ffffff',
                'mobikul_theme_bright_app_theme_color' => '#546E7A',
                'mobikul_theme_bright_theme_text_color' => '#ffffff',
                'mobikul_theme_bright_background_color' => '#ffffff',
                'mobikul_theme_bright_splash' => '',
                'mobikul_theme_bright_logo' => '',
                'mobikul_theme_dark_app_button_color' => '#ffffff',
                'mobikul_theme_dark_app_button_text_theme_color' => '#000000',
                'mobikul_theme_dark_app_theme_color' => '#000000',
                'mobikul_theme_dark_theme_text_color' => '#ffffff',
                'mobikul_theme_dark_background_color' => '#000000',
                'mobikul_theme_dark_splash' => '',
                'mobikul_theme_dark_logo' => '',
            );

            $data_array = array(
                'app_button_color',
                'app_button_text_theme_color',
                'app_theme_color',
                'theme_text_color',
                'background_color',
                'splash',
                'logo',
            );
            $data['light_theme_config'] = array();

            foreach ($data_array as $value) {
                if ($this->config->get('mobikul_theme_bright_' . $value)) {
                    $data['light_theme_config']['mobikul_theme_bright_' . $value] = $this->config->get('mobikul_theme_bright_' . $value);
                } else {
                    $data['light_theme_config']['mobikul_theme_bright_' . $value] = $default_array['mobikul_theme_bright_' . $value];
                }
            }

            $data['dark_theme_config'] = array();

            foreach ($data_array as $value) {
                if ($this->config->get('mobikul_theme_dark_' . $value)) {
                    $data['dark_theme_config']['mobikul_theme_dark_' . $value] = $this->config->get('mobikul_theme_dark_' . $value);
                } else {
                    $data['dark_theme_config']['mobikul_theme_dark_' . $value] = $default_array['mobikul_theme_dark_' . $value];
                }
            }

            $data['launcher_icon_configuration'] = $this->config->get('module_mobikul_launcher_icon_type');
            $data['app_category_view_configuration'] = $this->config->get('mobikul_app_category_view_status');

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($data));
        }
    }

    protected function checkSession($session_id)
    {

        if (version_compare(VERSION, '3.0.0.0', '>=')) {
            if (isset($this->session->data['session_id']) && $this->session->data['session_id'] == $session_id) {
                return true;
            }
        } else {
            foreach ($_SESSION as $key => $value) {
                if (isset($value['session_id']) && $session_id == $value['session_id']) {
                    return true;
                }
            }

            if (isset($_SESSION['session_id']) && $_SESSION['session_id'] == $session_id) {
                return true;
            }
        }
        return false;
    }
}
if (!function_exists('getallheaders')) {
    function getallheaders()
    {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
            }
        }
        return $headers;
    }
}
